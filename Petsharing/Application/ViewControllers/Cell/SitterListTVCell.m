//
//  SitterListTVCell.m
//  Petsharing
//
//  Created by LandToSky on 8/25/17.
//  Copyright © 2017 LandToSky. All rights reserved.
//

#import "SitterListTVCell.h"

@implementation SitterListTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
