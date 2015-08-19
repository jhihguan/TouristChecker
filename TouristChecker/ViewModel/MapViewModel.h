//
//  MapViewModel.h
//  TouristChecker
//
//  Created by Wane Wang on 2015/8/18.
//  Copyright (c) 2015年 Wane Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QueryAnnotation.h"
@import CoreLocation;

@protocol MapViewModelDelegate;
@interface MapViewModel : NSObject

@property (nonatomic) BOOL isQuery;

@property (nonatomic, strong) NSArray *mapDataArray;
@property (nonatomic, strong) QueryAnnotation *queryPoint;
@property (nonatomic, weak) id<MapViewModelDelegate> delegate;

- (void)queryPlace;

@end
@protocol MapViewModelDelegate <NSObject>

- (void)viewModelGetNewData:(NSArray *)dataArray;

@end
