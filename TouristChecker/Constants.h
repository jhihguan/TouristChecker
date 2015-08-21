//
//  Constants.h
//  TouristChecker
//
//  Created by Wane Wang on 2015/8/18.
//  Copyright (c) 2015年 Wane Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

// Foursquare API Setting
static NSString *const FOUR_API_BASE = @"https://api.foursquare.com/v2/";
static NSString *const FOUR_EXPLORE_API = @"venues/explore";
static NSString *const FOUR_CLIENT_ID_KEY = @"client_id";
static NSString *const FOUR_CLIENT_ID_VALUE = @"PSRBJ5R0XI5U5WX4EV3LLYZT2YUOHTK3DIKKIHP5HGB2D5RK";
static NSString *const FOUR_CLIENT_SECRET_KEY = @"client_secret";
static NSString *const FOUR_CLIENT_SECRET_VALUE = @"WLSN1QOBBFIEUWUM5LGVH4OS154UYK1CQYPVLRNWTVQDG50F";
static NSString *const FOUR_VERSION_KEY = @"v";
static NSString *const FOUR_VERSION_VALUE = @"20150818";

// GooglePlace API KEY
static NSString *const GOOGLE_PLACE_API_KEY = @"AIzaSyCRfPjlM9pWH_vKH2iXkNVMdXOIJihMX4A";

// Yelp API Setting
static NSString *const YELP_CONSUMER_KEY = @"JFD8zxCM26QDprOOdZp-Kg";
static NSString *const YELP_CONSUMER_SECRET = @"GTVeOBL7FFeKAeBUH1gYm3PoI1E";
static NSString *const YELP_TOKEN = @"4iOyMidQizSf1-mLAXiD_gHQE0R7fayR";
static NSString *const YELP_TOKEN_SECRET = @"ozt0UGWlX8T0eQyOZ86cWHeGQ94";
static NSString *const YELP_API_BASE = @"api.yelp.com";
static NSString *const YELP_SEARCH_API = @"/v2/search/";

@interface Constants : NSObject

@end
