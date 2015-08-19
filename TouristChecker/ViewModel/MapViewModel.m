//
//  MapViewModel.m
//  TouristChecker
//
//  Created by Wane Wang on 2015/8/18.
//  Copyright (c) 2015年 Wane Wang. All rights reserved.
//

#import "MapViewModel.h"
#import "FoursquareAPI.h"
#import "MapBaseModel.h"
#import "PlaceAnnotation.h"

@interface MapViewModel ()

@property (nonatomic, strong) NSString *locationString;

@end

@implementation MapViewModel

/**
 * query place data with location
 */
- (void)queryPlace {
    
    if (!self.queryPoint) {
        return;
    }
    self.isQuery = YES;
    self.mapDataArray = [[NSArray alloc] init];
    
    [[FoursquareAPI sharedAPI] searchLocationPlaces:self.locationString success:^(NSArray *dataArray) {
        self.isQuery = NO;
        NSMutableArray *transArray = [[NSMutableArray alloc] init];
        for (MapBaseModel *baseModel in dataArray) {
            PlaceAnnotation *mapAnno = [[PlaceAnnotation alloc] initWithMapModel:baseModel];
            [transArray addObject:mapAnno];
        }
        if ([self.delegate respondsToSelector:@selector(viewModelGetNewData:)]) {
            [self.delegate viewModelGetNewData:transArray];
        }
        NSMutableArray *tempArray = [self.mapDataArray mutableCopy];
        [tempArray addObjectsFromArray:dataArray];
        self.mapDataArray = [[NSArray alloc] initWithArray:tempArray];
    }];
}

- (void)setQueryPoint:(QueryAnnotation *)queryPoint {
    _queryPoint = queryPoint;
    self.locationString = [[NSString alloc] initWithFormat:@"%lf,%lf", queryPoint.coordinate.latitude, queryPoint.coordinate.longitude];
}

@end
