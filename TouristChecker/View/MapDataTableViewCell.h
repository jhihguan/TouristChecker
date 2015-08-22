//
//  MapDataTableViewCell.h
//  TouristChecker
//
//  Created by Wane Wang on 2015/8/22.
//  Copyright (c) 2015年 Wane Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapBaseModel.h"

@interface MapDataTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *sourceImageView;
@property (weak, nonatomic) IBOutlet UILabel *placeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeDistanceLabel;
- (void)setupCellView:(MapBaseModel *)model;

@end
