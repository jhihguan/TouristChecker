//
//  PlaceAnnotation.h
//  TouristChecker
//
//  Created by Wane Wang on 2015/8/19.
//  Copyright (c) 2015年 Wane Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MapKit;

@class MapBaseModel;
@interface PlaceAnnotation : NSObject<MKAnnotation>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *imageName;

- (instancetype)initWithMapModel:(MapBaseModel *)baseModel;

@end
