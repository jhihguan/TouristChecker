//
//  MapViewModel.m
//  TouristChecker
//
//  Created by Wane Wang on 2015/8/18.
//  Copyright (c) 2015年 Wane Wang. All rights reserved.
//

#import "MapViewModel.h"
#import "FoursquareAPI.h"
#import "GoogleplaceAPI.h"
#import "YelpAPI.h"
#import "MapBaseModel.h"

@interface MapViewModel ()

@property (nonatomic, strong) NSString *locationString;

@end

@implementation MapViewModel

- (void)queryPlace {
    
    if (!self.queryPoint) {
        return;
    }
    self.isQuery = YES;
    self.mapDataArray = [[NSArray alloc] init];
    
    [[FoursquareAPI sharedAPI] searchLocationPlaces:self.locationString success:^(NSArray *dataArray) {
        [self addAndNotifyNewMapDataArray:dataArray];
    }];
    
    [[GoogleplaceAPI sharedAPI] searchLocationSuccess:^(NSArray *dataArray) {
        [self addAndNotifyNewMapDataArray:dataArray];
    }];
    
    [[YelpAPI sharedAPI] searchLocationPlaces:self.locationString success:^(NSArray *dataArray) {
        [self addAndNotifyNewMapDataArray:dataArray];
    }];
}

- (void)calculateWalkRouteSuccess:(void (^)(MKRoute *))complete failure:(void (^)())fail{
    if (!self.queryPoint && !self.destinationPoint) {
        return;
    }
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    MKPlacemark *sourcePlaceMark = [[MKPlacemark alloc] initWithCoordinate:self.queryPoint.coordinate addressDictionary:nil];
    MKPlacemark *destinationPlaceMark = [[MKPlacemark alloc] initWithCoordinate:self.destinationPoint.coordinate addressDictionary:nil];
    request.source = [[MKMapItem alloc] initWithPlacemark:sourcePlaceMark];
    request.destination = [[MKMapItem alloc] initWithPlacemark:destinationPlaceMark];
    request.transportType = MKDirectionsTransportTypeWalking;
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if (error) {
            fail();
//            NSLog(@"There was an error getting your directions");
            return;
        }
        if (complete) {
            MKRoute *route = [response.routes firstObject];
            self.walkRoute = route;
            complete(route);
        }
    }];
}

- (void)addAndNotifyNewMapDataArray:(NSArray *)dataArray {
    self.isQuery = NO;
    [self showAnnotationsFromMapModelArray:dataArray];
    NSMutableArray *tempArray = [self.mapDataArray mutableCopy];
    [tempArray addObjectsFromArray:dataArray];
    self.mapDataArray = [[NSArray alloc] initWithArray:tempArray];
}

- (void)showAnnotationsFromMapModelArray:(NSArray *)baseArray {
    NSMutableArray *transArray = [[NSMutableArray alloc] init];
    CLLocation *baseLocation = [[CLLocation alloc] initWithLatitude:self.queryPoint.coordinate.latitude longitude:self.queryPoint.coordinate.longitude];
    for (MapBaseModel *baseModel in baseArray) {
        if (baseModel.distance == 0) {
            CLLocation *targetLocation = [[CLLocation alloc] initWithLatitude:baseModel.latitude longitude:baseModel.longitude];
            [baseModel setDistance:[baseLocation distanceFromLocation:targetLocation]];
        }
        PlaceAnnotation *mapAnno = [[PlaceAnnotation alloc] initWithMapModel:baseModel];
        [transArray addObject:mapAnno];
    }
    if ([self.delegate respondsToSelector:@selector(viewModelGetNewData:)]) {
        [self.delegate viewModelGetNewData:transArray];
    }
}

- (ListViewModel *)generateListViewModel {
    NSSortDescriptor *distanceDescriptor = [[NSSortDescriptor alloc] initWithKey:@"distance" ascending:YES];
    NSArray *sortDescriptors = @[distanceDescriptor];
    NSArray *sortedArray = [self.mapDataArray sortedArrayUsingDescriptors:sortDescriptors];
    ListViewModel *viewModel = [[ListViewModel alloc] initWithDataArray:sortedArray];
    return viewModel;
}



- (void)setQueryPoint:(QueryAnnotation *)queryPoint {
    _queryPoint = queryPoint;
    self.locationString = [[NSString alloc] initWithFormat:@"%lf,%lf", queryPoint.coordinate.latitude, queryPoint.coordinate.longitude];
}

@end
