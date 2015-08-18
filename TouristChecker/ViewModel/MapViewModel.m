//
//  MapViewModel.m
//  TouristChecker
//
//  Created by Wane Wang on 2015/8/18.
//  Copyright (c) 2015年 Wane Wang. All rights reserved.
//

#import "MapViewModel.h"

@implementation MapViewModel

/**
 * query place data with location
 */
- (void)queryPlaceSuccess:(void (^)(NSArray *))complete {
    
    if (self.queryPoint.coordinate.latitude == 0) {
        return;
    }
    self.isQuery = YES;
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    self.mapDataArray = [[NSArray alloc] initWithArray:dataArray];
    if (complete) {
        self.isQuery = NO;
        complete(self.mapDataArray);
    }
}

@end
