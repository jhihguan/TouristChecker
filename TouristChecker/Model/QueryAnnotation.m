//
//  QueryAnnotation.m
//  TouristChecker
//
//  Created by Wane Wang on 2015/8/18.
//  Copyright (c) 2015年 Wane Wang. All rights reserved.
//

#import "QueryAnnotation.h"

@implementation QueryAnnotation
@synthesize coordinate;

- (instancetype)initWithLocation:(CLLocationCoordinate2D)coord {
    self = [super init];
    if (self) {
        self.coordinate = coord;
    }
    return self;
}

- (NSString *)title {
    static NSString *const QUERY_TITLE = @"Search";
    return QUERY_TITLE;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    coordinate = newCoordinate;
}

@end
