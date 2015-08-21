//
//  MapDataTableViewCell.m
//  TouristChecker
//
//  Created by Wane Wang on 2015/8/22.
//  Copyright (c) 2015年 Wane Wang. All rights reserved.
//

#import "MapDataTableViewCell.h"

@implementation MapDataTableViewCell

- (void)setupCellView:(MapBaseModel *)model {
    self.sourceImageView.image = [UIImage imageNamed:[[NSString alloc] initWithFormat:@"icon_%@", model.source]];
    self.placeNameLabel.text = model.name;
    self.placeTypeLabel.text = model.type;
    self.placeDistanceLabel.text = [[NSString alloc] initWithFormat:@"%zd m", model.distance];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
