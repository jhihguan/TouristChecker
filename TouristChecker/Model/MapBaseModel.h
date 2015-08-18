//
//  MapBaseModel.h
//  TouristChecker
//
//  Created by Wane Wang on 2015/8/18.
//  Copyright (c) 2015年 Wane Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle.h>

@interface MapBaseModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *type;
@property (nonatomic, strong, readonly) NSString *source;
@property (nonatomic, assign, readonly) int distance;
@property (nonatomic, assign, readonly) double latitude;
@property (nonatomic, assign, readonly) double longitude;

+ (NSDictionary *)transFourSquareVenueDict:(NSDictionary *)venueDict;

@end
