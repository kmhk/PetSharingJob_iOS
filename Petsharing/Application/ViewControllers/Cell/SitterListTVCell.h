//
//  SitterListTVCell.h
//  Petsharing
//
//  Created by LandToSky on 8/25/17.
//  Copyright © 2017 LandToSky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SitterListTVCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *sitterPhotoIv;
@property (nonatomic, strong) IBOutlet UILabel *sitterNameLbl;
@property (nonatomic, strong) IBOutlet UIButton *sitterProfileOpenBtn;
@property (nonatomic, strong) IBOutlet UIButton *chatBtn;
@property (nonatomic, strong) IBOutlet UIButton *callBtn;
@property (nonatomic, strong) IBOutlet UIButton *hireBtn;

@end
