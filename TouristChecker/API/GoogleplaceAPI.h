//
//  GoogleplaceAPI.h
//  TouristChecker
//
//  Created by Wane Wang on 2015/8/20.
//  Copyright (c) 2015年 Wane Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoogleplaceAPI : NSObject

+ (GoogleplaceAPI *)sharedAPI;

// query user location nearby place
- (void)searchLocationSuccess:(void (^)(NSArray *dataArray))complete;

@end
