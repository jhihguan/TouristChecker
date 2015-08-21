//
//  MapBaseModel.h
//  TouristChecker
//
//  Created by Wane Wang on 2015/8/18.
//  Copyright (c) 2015年 Wane Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle.h>

@class GMSPlace;
@interface MapBaseModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *type;
@property (nonatomic, strong, readonly) NSString *source;
@property (nonatomic, assign, readonly) int distance;
@property (nonatomic, assign, readonly) double latitude;
@property (nonatomic, assign, readonly) double longitude;

- (void)setDistance:(int)distance;

// transform foursquare venue dictionary to target structure
+ (NSDictionary *)transFourSquareVenueDict:(NSDictionary *)venueDict;
// transform GMSPlace object to target structure
+ (NSDictionary *)transGooglePlaceData:(GMSPlace *)place;

// transform Yelp business dictionary to target structure
+ (NSDictionary *)transYelpBusinessDict:(NSDictionary *)venueDict;

@end
