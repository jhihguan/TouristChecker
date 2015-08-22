//
//  ListViewModel.h
//  TouristChecker
//
//  Created by Wane Wang on 2015/8/21.
//  Copyright (c) 2015年 Wane Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListViewModel : NSObject

@property (nonatomic, strong) NSArray *dataArray;

- (instancetype)initWithDataArray:(NSArray *)mapDataArray;

@end
