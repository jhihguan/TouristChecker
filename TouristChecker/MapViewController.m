//
//  ViewController.m
//  TouristChecker
//
//  Created by Wane Wang on 2015/8/17.
//  Copyright (c) 2015年 Wane Wang. All rights reserved.
//

#import "MapViewController.h"
#import "MapViewModel.h"
#import "ListViewController.h"
#import <SVProgressHUD.h>
@import MapKit;

@interface MapViewController () <CLLocationManagerDelegate, MKMapViewDelegate, MapViewModelDelegate, ListViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) MapViewModel *viewModel;
@end

@implementation MapViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Interact Function

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan) {
        return;
    }
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D coordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    [self queryPlaceWithCoordinate:coordinate];
}

#pragma mark - Private Function

- (void)queryPlaceWithCoordinate:(CLLocationCoordinate2D)coordinate {
    if (self.viewModel.isQuery) {
        return;
    }
    if (self.viewModel.walkRoute) {
        [self.mapView removeOverlay:self.viewModel.walkRoute.polyline];
    }
    [self.mapView removeAnnotations:self.mapView.annotations];
    self.viewModel.queryPoint = [[QueryAnnotation alloc] initWithLocation:coordinate];
    [self.mapView addAnnotation:self.viewModel.queryPoint];
    [self.viewModel queryPlace];
}

- (void)queryDestRoute:(PlaceAnnotation *)destPlace {
    self.viewModel.destinationPoint = destPlace;
    if (self.viewModel.walkRoute) {
        [self.mapView removeOverlay:self.viewModel.walkRoute.polyline];
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.viewModel calculateWalkRouteSuccess:^(MKRoute *route){
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self.mapView addOverlay:route.polyline];
    } failure:^{
        [SVProgressHUD showErrorWithStatus:@"Error Loading"];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
}

#pragma mark - ViewModel Delegate

- (void)viewModelGetNewData:(NSArray *)dataArray {
    [self.mapView addAnnotations:dataArray];
}

#pragma mark - ListView Delegate

- (void)listController:(ListViewController *)listVC selectMapModel:(MapBaseModel *)baseModel {
    [listVC.navigationController popViewControllerAnimated:YES];
    MKCoordinateRegion region = self.mapView.region;
    region.center = CLLocationCoordinate2DMake(baseModel.latitude, baseModel.longitude);
    [self.mapView setRegion:region animated:YES];
    [self.mapView selectAnnotation:baseModel.mapAnno animated:NO];
    [self queryDestRoute:baseModel.mapAnno];
    
}

#pragma mark - MapView Delegate

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    renderer.strokeColor = [UIColor colorWithRed:0.216 green:0.327 blue:0.967 alpha:0.800];
    renderer.lineWidth = 3.0;
    return renderer;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    if ([view.annotation isKindOfClass:[PlaceAnnotation class]]) {
        PlaceAnnotation *destPlace = (PlaceAnnotation *)view.annotation;
        [self queryDestRoute:destPlace];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[QueryAnnotation class]]) {
        static NSString *const REUSE_QUERY_ANNOTATION = @"QUERY_ANNOTATION";
        MKPinAnnotationView *pinAnnoView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:REUSE_QUERY_ANNOTATION];
        pinAnnoView.canShowCallout = YES;
        pinAnnoView.pinColor = MKPinAnnotationColorPurple;
        return pinAnnoView;
    } else if ([annotation isKindOfClass:[PlaceAnnotation class]]) {
        static NSString *const REUSE_PLACE_ANNOTATION = @"PLACE_ANNOTATION";
        MKAnnotationView *annotateView = [mapView dequeueReusableAnnotationViewWithIdentifier:REUSE_PLACE_ANNOTATION];
        if (!annotateView) {
            annotateView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:REUSE_PLACE_ANNOTATION];
        }
        
        PlaceAnnotation *place = annotation;
        UIButton *directionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *directionIcon = [UIImage imageNamed:@"route_button"];
        directionButton.frame = CGRectMake(0, 0, 30, 30);
        [directionButton setImage:directionIcon forState:UIControlStateNormal];
        UIImageView *sourceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        sourceImageView.image = [UIImage imageNamed:[[NSString alloc] initWithFormat:@"icon_%@", place.source]];
        
        annotateView.image = [UIImage imageNamed:[[NSString alloc] initWithFormat:@"map_%@", place.source]];
        annotateView.canShowCallout = YES;
        annotateView.rightCalloutAccessoryView = directionButton;
        annotateView.leftCalloutAccessoryView = sourceImageView;
        return annotateView;
    }
    
    return nil;
}

// animation for drop annotation inside view
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    MKAnnotationView *aV;
    for (aV in views) {
        // Don't pin drop if annotation is user location
        if ([aV.annotation isKindOfClass:[MKUserLocation class]]) {
            continue;
        }
        
        // Check if current annotation is inside visible map rect, else go to next one
        MKMapPoint point = MKMapPointForCoordinate(aV.annotation.coordinate);
        if (!MKMapRectContainsPoint(self.mapView.visibleMapRect, point)) {
            continue;
        }
        
        CGRect endFrame = aV.frame;
        
        // Move annotation out of view
        aV.frame = CGRectMake(aV.frame.origin.x, aV.frame.origin.y - self.view.frame.size.height, aV.frame.size.width, aV.frame.size.height);
        
        // Animate drop
        [UIView animateWithDuration:0.5 delay:0.04 *[views indexOfObject:aV] options:UIViewAnimationOptionCurveEaseInOut animations:^{
            aV.frame = endFrame;
            
            // Animate squash
        } completion:^(BOOL finished) {
            if (finished) {
                [UIView animateWithDuration:0.05 animations:^{
                    aV.transform = CGAffineTransformMakeScale(1.0, 0.8);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.1 animations:^{
                        aV.transform = CGAffineTransformIdentity;
                    }];
                }];
            }
        }];
    }
}

#pragma mark - LocationManager Delegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways:
            [manager startUpdatingLocation];
            self.mapView.showsUserLocation = YES;
            break;

        case kCLAuthorizationStatusNotDetermined:
            if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                [self.locationManager requestWhenInUseAuthorization];
            }
            break;

        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted:
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [manager stopUpdatingLocation];
    CLLocationCoordinate2D coordinate = manager.location.coordinate;
    [self.mapView setRegion:MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(0.01, 0.01)) animated:YES];
    [self queryPlaceWithCoordinate:coordinate];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController respondsToSelector:@selector(setViewModel:)]) {
        [segue.destinationViewController performSelector:@selector(setViewModel:) withObject:[self.viewModel generateListViewModel]];
    }
    if ([segue.destinationViewController respondsToSelector:@selector(setDelegate:)]) {
        [segue.destinationViewController performSelector:@selector(setDelegate:) withObject:self];
    }
}

#pragma mark - Init Setup

- (void)setupView {
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    longPressGestureRecognizer.minimumPressDuration = 0.6f;
    [_mapView addGestureRecognizer:longPressGestureRecognizer];
    
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;

    self.viewModel = [[MapViewModel alloc] init];
    self.viewModel.delegate = self;
}

@end
