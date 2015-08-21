//
//  MapViewModel.h
//  TouristChecker
//
//  Created by Wane Wang on 2015/8/18.
//  Copyright (c) 2015年 Wane Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QueryAnnotation.h"
#import "MapBaseModel.h"
#import "ListViewModel.h"
@import CoreLocation;

@protocol MapViewModelDelegate;
@interface MapViewModel : NSObject

@property (nonatomic) BOOL isQuery;

@property (nonatomic, strong) NSArray *mapDataArray;
@property (nonatomic, strong) QueryAnnotation *queryPoint;
@property (nonatomic, strong) PlaceAnnotation *destinationPoint;
@property (nonatomic, strong) MKRoute *walkRoute;
@property (nonatomic, weak) id<MapViewModelDelegate> delegate;

/**
 * Query place data nearby queryPoint
 */
- (void)queryPlace;

/**
 * Calculate route by queryPoint and destinationPoint
 */
- (void)calculateWalkRouteSuccess:(void (^)(MKRoute *route))complete failure:(void (^)())fail;

/**
 * Create ListViewModel for list view
 */
- (ListViewModel *)generateListViewModel;

@end
@protocol MapViewModelDelegate <NSObject>

- (void)viewModelGetNewData:(NSArray *)dataArray;

@end
