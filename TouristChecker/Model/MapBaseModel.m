//
//  MapBaseModel.m
//  TouristChecker
//
//  Created by Wane Wang on 2015/8/18.
//  Copyright (c) 2015年 Wane Wang. All rights reserved.
//

#import "MapBaseModel.h"
#import <GoogleMaps/GMSPlace.h>

static NSString *const NAME_KEY = @"name";
static NSString *const LAT_KEY = @"latitude";
static NSString *const LNG_KEY = @"longitude";
static NSString *const TYPE_KEY = @"type";
static NSString *const SOURCE_KEY = @"source";
static NSString *const DIST_KEY = @"distance";

@implementation MapBaseModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{ LAT_KEY : LAT_KEY, LNG_KEY : LNG_KEY, NAME_KEY : NAME_KEY, TYPE_KEY : TYPE_KEY, DIST_KEY : DIST_KEY, SOURCE_KEY : SOURCE_KEY };
}

+ (NSDictionary *)transFourSquareVenueDict:(NSDictionary *)venueDict {
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] init];
    NSDictionary *locationDictionary = [venueDict valueForKey:@"location"];
    [dataDict setValue:@([[locationDictionary valueForKey:@"lat"] doubleValue]) forKey:LAT_KEY];
    [dataDict setValue:@([[locationDictionary valueForKey:@"lng"] doubleValue]) forKey:LNG_KEY];
    [dataDict setValue:@([[locationDictionary valueForKey:@"distance"] doubleValue]) forKey:DIST_KEY];
    [dataDict setValue:[venueDict valueForKey:@"name"] forKey:NAME_KEY];
    NSDictionary *categoryDictionary = [[venueDict valueForKey:@"categories"] firstObject];
    [dataDict setValue:[categoryDictionary valueForKey:@"shortName"] forKey:TYPE_KEY];
    static NSString *const FOUR_SQUARE_SOURCE = @"foursquare";
    [dataDict setValue:FOUR_SQUARE_SOURCE forKey:SOURCE_KEY];
    return dataDict;
}

+ (NSDictionary *)transGooglePlaceData:(GMSPlace *)place {
//    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] init];
    static NSString *const GOOGLE_PLACE_SOURCE = @"google";
    NSString *type = @"";
    if (place.types.count > 0) {
        type = [place.types firstObject];
    }
    return @{NAME_KEY: place.name, LAT_KEY: @(place.coordinate.latitude), LNG_KEY:@(place.coordinate.longitude), SOURCE_KEY: GOOGLE_PLACE_SOURCE, TYPE_KEY: type };;
}

@end
