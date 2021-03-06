//
//  YelpAPI.m
//  TouristChecker
//
//  Created by Wane Wang on 2015/8/21.
//  Copyright (c) 2015年 Wane Wang. All rights reserved.
//

#import "YelpAPI.h"
#import "NSURLRequest+OAuth.h"
#import "Constants.h"
#import "MapBaseModel.h"

@implementation YelpAPI

+ (YelpAPI *)sharedAPI {
    static YelpAPI *_api;
    static dispatch_once_t onceYelpAPIToke;
    dispatch_once(&onceYelpAPIToke, ^{
        _api = [[YelpAPI alloc] init];
    });
    return _api;
}

- (void)searchLocationPlaces:(NSString *)loc success:(void (^)(NSArray *))complete {
    NSURLRequest *searchRequest = [self requestWithLocation:loc];
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:searchRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;

        if (!error && httpResponse.statusCode == 200) {
            NSDictionary *searchResponseJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            NSArray *businessArray = searchResponseJSON[@"businesses"];
            NSMutableArray *dataArray = [[NSMutableArray alloc] init];
            for (NSDictionary *sourceDict in businessArray) {
                NSDictionary *dataDict = [MapBaseModel transYelpBusinessDict:sourceDict];
                NSError *error = nil;
                MapBaseModel *model = [MTLJSONAdapter modelOfClass:MapBaseModel.class fromJSONDictionary:dataDict error:&error];
                if (!error) {
                    [dataArray addObject:model];
                }
            }
            if (complete) {
                complete(dataArray);
            }
            
        }
    }] resume];
}

// generate request with parameter and url
- (NSURLRequest *)requestWithLocation:(NSString *)location {
    NSDictionary *params = @{
        @"ll" : location, @"limit" : @(20)
    };

    return [NSURLRequest requestWithHost:YELP_API_BASE path:YELP_SEARCH_API params:params];
}

@end
