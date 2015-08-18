//
//  ViewController.m
//  TouristChecker
//
//  Created by Wane Wang on 2015/8/17.
//  Copyright (c) 2015年 Wane Wang. All rights reserved.
//

#import "ViewController.h"
#import "MapViewModel.h"
@import MapKit;

@interface ViewController () <CLLocationManagerDelegate, MKMapViewDelegate, MapViewModelDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) MapViewModel *viewModel;
@end

@implementation ViewController

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
    if (self.viewModel.queryPoint) {
        [self.mapView removeAnnotation:self.viewModel.queryPoint];
    }
    self.viewModel.queryPoint = [[QueryAnnotation alloc] initWithLocation:coordinate];
    [self.mapView addAnnotation:self.viewModel.queryPoint];
    [self.viewModel queryPlace];
}

#pragma mark - ViewModel Delegate

- (void)viewModelGetNewData:(NSArray *)dataArray {
    [self.mapView addAnnotations:dataArray];
}

#pragma mark - MapView Delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[QueryAnnotation class]]) {
        static NSString *const REUSE_QUERY_ANNOTATION = @"QUERY_ANNOTATION";
        MKPinAnnotationView *pinAnnoView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:REUSE_QUERY_ANNOTATION];
        pinAnnoView.canShowCallout = YES;
        pinAnnoView.pinColor = MKPinAnnotationColorRed;
        return pinAnnoView;
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
