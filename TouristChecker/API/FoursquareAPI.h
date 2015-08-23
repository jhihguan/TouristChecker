//
//  FoursquareAPI.h
//  TouristChecker
//
//  Created by Wane Wang on 2015/8/18.
//  Copyright (c) 2015年 Wane Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoursquareAPI : NSObject

+ (FoursquareAPI *)sharedAPI;

// search location with latitude,longitude string
- (void)searchLocationPlaces:(NSString *)loc success:(void (^)(NSArray *dataArray))complete;

@end
