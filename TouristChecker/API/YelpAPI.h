//
//  YelpAPI.h
//  TouristChecker
//
//  Created by Wane Wang on 2015/8/21.
//  Copyright (c) 2015年 Wane Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YelpAPI : NSObject

+ (YelpAPI *)sharedAPI;

- (void)searchLocationPlaces:(NSString *)loc success:(void (^)(NSArray *dataArray))complete;

@end
