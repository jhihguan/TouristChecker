//
//  PlaceAnnotation.m
//  TouristChecker
//
//  Created by Wane Wang on 2015/8/19.
//  Copyright (c) 2015年 Wane Wang. All rights reserved.
//

#import "PlaceAnnotation.h"
#import "MapBaseModel.h"

@implementation PlaceAnnotation
@synthesize coordinate;

- (instancetype)initWithMapModel:(MapBaseModel *)baseModel {
    self = [super init];
    if (self) {
        self.name = baseModel.name;
        self.type = baseModel.type;
        self.source = baseModel.source;
        self.coordinate = CLLocationCoordinate2DMake(baseModel.latitude, baseModel.longitude);
    }
    return self;
}

- (NSString *)title {
    return self.name;
}

- (NSString *)subtitle {
    return self.type;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    coordinate = newCoordinate;
}

@end
