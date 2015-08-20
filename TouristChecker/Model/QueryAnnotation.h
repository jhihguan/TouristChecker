//
//  QueryAnnotation.h
//  TouristChecker
//
//  Created by Wane Wang on 2015/8/18.
//  Copyright (c) 2015年 Wane Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MapKit;

@interface QueryAnnotation : NSObject <MKAnnotation>

- (instancetype)initWithLocation:(CLLocationCoordinate2D)coord;

@end
