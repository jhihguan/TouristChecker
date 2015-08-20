//
//  GoogleplaceAPI.m
//  TouristChecker
//
//  Created by Wane Wang on 2015/8/20.
//  Copyright (c) 2015年 Wane Wang. All rights reserved.
//

#import "GoogleplaceAPI.h"
#import "MapBaseModel.h"
@import GoogleMaps;

@interface GoogleplaceAPI ()

@property (nonatomic, strong) GMSPlacesClient *placesClient;

@end

@implementation GoogleplaceAPI

+ (GoogleplaceAPI *)sharedAPI {
    static GoogleplaceAPI *_api;
    static dispatch_once_t onceGoogleAPIToke;
    dispatch_once(&onceGoogleAPIToke, ^{
        _api = [[GoogleplaceAPI alloc] init];
        _api.placesClient = [[GMSPlacesClient alloc] init];
    });
    return _api;
}

- (void)searchLocationSuccess:(void (^)(NSArray *))complete {
    [self.placesClient currentPlaceWithCallback:^(GMSPlaceLikelihoodList *GMS_NULLABLE_PTR likelihoodList, NSError *GMS_NULLABLE_PTR error) {
        if (error) {
            complete(@[]);
            return;
        }
        NSMutableArray *dataArray = [[NSMutableArray alloc] init];
        for (GMSPlaceLikelihood *likelihood in likelihoodList.likelihoods) {
            NSDictionary *dataDict = [MapBaseModel transGooglePlaceData:likelihood.place];
            NSError *error = nil;
            MapBaseModel *model = [MTLJSONAdapter modelOfClass:MapBaseModel.class fromJSONDictionary:dataDict error:&error];
            if (!error) {
                [dataArray addObject:model];
            }
        }
        complete(dataArray);
    }];
}

@end
