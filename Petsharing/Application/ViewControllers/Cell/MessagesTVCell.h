//
//  MessagesTVCell.h
//  Petsharing
//
//  Created by LandToSky on 8/27/17.
//  Copyright © 2017 LandToSky. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MessagesTVCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *userPhotoIv;
@property (nonatomic, strong) IBOutlet UILabel *userNameLbl;
@property (nonatomic, strong) IBOutlet UIButton *chatBtn;
@property (nonatomic, strong) IBOutlet UIButton *phoneCallBtn;
@property (nonatomic, strong) IBOutlet UIButton *hireBtn;

@property (nonatomic, strong) IBOutlet UILabel *jobTitleLbl;


// for message list vc only
@property (nonatomic) DogJob *curJob;
@property (nonatomic) DogUser *opUser;

- (void)setDogUser:(DogUser *)user;

- (void)setJobID:(NSString *)jobID opUserID:(NSString *)opUserID;

@end
