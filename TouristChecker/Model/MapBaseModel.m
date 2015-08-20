//
//  MapBaseModel.m
//  TouristChecker
//
//  Created by Wane Wang on 2015/8/18.
//  Copyright (c) 2015年 Wane Wang. All rights reserved.
//

#import "MapBaseModel.h"

@implementation MapBaseModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{ @"latitude" : @"latitude", @"longitude" : @"longitude", @"name" : @"name", @"type" : @"type", @"distance" : @"dist", @"source" : @"source" };
}

// parse foursquare venue dictionary to target transform dictionary
+ (NSDictionary *)transFourSquareVenueDict:(NSDictionary *)venueDict {
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] init];
    NSDictionary *locationDictionary = [venueDict valueForKey:@"location"];
    [dataDict setValue:@([[locationDictionary valueForKey:@"lat"] doubleValue]) forKey:@"latitude"];
    [dataDict setValue:@([[locationDictionary valueForKey:@"lng"] doubleValue]) forKey:@"longitude"];
    [dataDict setValue:@([[locationDictionary valueForKey:@"distance"] doubleValue]) forKey:@"dist"];
    [dataDict setValue:[venueDict valueForKey:@"name"] forKey:@"name"];
    NSDictionary *categoryDictionary = [[venueDict valueForKey:@"categories"] firstObject];
    [dataDict setValue:[categoryDictionary valueForKey:@"shortName"] forKey:@"type"];
    static NSString *const FOUR_SQUARE_SOURCE = @"foursquare";
    [dataDict setValue:FOUR_SQUARE_SOURCE forKey:@"source"];
    return dataDict;
}

@end
