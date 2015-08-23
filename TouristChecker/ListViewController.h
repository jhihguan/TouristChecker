//
//  ListViewController.h
//  TouristChecker
//
//  Created by Wane Wang on 2015/8/21.
//  Copyright (c) 2015年 Wane Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListViewModel.h"

@class MapBaseModel;
@protocol ListViewDelegate;
@interface ListViewController : UIViewController

@property (strong, nonatomic) IBOutlet ListViewModel *viewModel;

@property (nonatomic, weak) id<ListViewDelegate> delegate;
@end
@protocol ListViewDelegate <NSObject>

// select cell
- (void)listController:(ListViewController *)listVC selectMapModel:(MapBaseModel *)baseModel;

@end
