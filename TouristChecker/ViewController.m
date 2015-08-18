//
//  ViewController.m
//  TouristChecker
//
//  Created by Wane Wang on 2015/8/17.
//  Copyright (c) 2015年 Wane Wang. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>

@interface ViewController () <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;
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
    [self.mapView setRegion:MKCoordinateRegionMake(manager.location.coordinate, MKCoordinateSpanMake(0.01, 0.01)) animated:YES];
    [manager stopUpdatingLocation];
}

#pragma mark - Init Setup

- (void)setupView {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
}

@end
