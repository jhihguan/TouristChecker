//
//  FoursquareAPI.m
//  TouristChecker
//
//  Created by Wane Wang on 2015/8/18.
//  Copyright (c) 2015年 Wane Wang. All rights reserved.
//

#import "FoursquareAPI.h"
#import "Constants.h"
#import "MapBaseModel.h"
#import <AFNetworking.h>

@implementation FoursquareAPI

+ (FoursquareAPI *)sharedAPI {
    static FoursquareAPI *_api;
    static dispatch_once_t onceFourAPIToke;
    dispatch_once(&onceFourAPIToke, ^{
        _api = [[FoursquareAPI alloc] init];
    });
    return _api;
}

- (void)searchLocationPlaces:(NSString *)loc success:(void (^)(NSArray *))complete {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *parmas = [self getBaseParams];
    [parmas setValue:loc forKey:@"ll"];
    [parmas setValue:@(5) forKey:@"limit"];
    [parmas setValue:@(1500) forKey:@"radius"];
    [manager GET:[FOUR_API_BASE stringByAppendingString:FOUR_EXPLORE_API] parameters:parmas success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *dataArray = [[NSMutableArray alloc] init];
        NSArray *itemArray = [[[[responseObject valueForKey:@"response"] valueForKey:@"groups"] firstObject] valueForKey:@"items"];
        for (NSDictionary *item in itemArray) {
            NSDictionary *dataDict = [MapBaseModel transFourSquareVenueDict:[item valueForKey:@"venue"]];
            NSError *error = nil;
            MapBaseModel *model = [MTLJSONAdapter modelOfClass:MapBaseModel.class fromJSONDictionary:dataDict error:&error];
            if (!error) {
                [dataArray addObject:model];
            }
        }
        if (complete) {
            complete(dataArray);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (complete) {
            complete(@[]);
        }
    }];
}

- (NSMutableDictionary *)getBaseParams {
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    [parmas setValue:FOUR_CLIENT_ID_VALUE forKey:FOUR_CLIENT_ID_KEY];
    [parmas setValue:FOUR_CLIENT_SECRET_VALUE forKey:FOUR_CLIENT_SECRET_KEY];
    [parmas setValue:FOUR_VERSION_VALUE forKey:FOUR_VERSION_KEY];
    return parmas;
}

@end
