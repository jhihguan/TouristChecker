//
//  ListViewModel.m
//  TouristChecker
//
//  Created by Wane Wang on 2015/8/21.
//  Copyright (c) 2015年 Wane Wang. All rights reserved.
//

#import "ListViewModel.h"

@implementation ListViewModel

- (instancetype)initWithDataArray:(NSArray *)mapDataArray {
    self = [super init];
    if (self) {
        self.dataArray = [[NSArray alloc] initWithArray:mapDataArray];
    }
    return self;
}

@end
