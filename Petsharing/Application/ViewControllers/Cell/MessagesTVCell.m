//
//  MessagesTVCell.m
//  Petsharing
//
//  Created by LandToSky on 8/27/17.
//  Copyright © 2017 LandToSky. All rights reserved.
//

#import "MessagesTVCell.h"
#import "DogUser.h"
#import "DogJob.h"
#import <SDWebImage/UIImageView+WebCache.h>


@implementation MessagesTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDogUser:(DogUser *)user {
	[[FirebaseRef storageForAvatar:user.userID] downloadURLWithCompletion:^(NSURL * _Nullable URL, NSError * _Nullable error) {
		if (error) {
			[commonUtils showAlert:@"Warning!" withMessage:error.localizedDescription];
			return;
		}
		
		[self.userPhotoIv sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"avatar5"]];
	}];
	
	self.userNameLbl.text = [NSString stringWithFormat:@"%@ %@", user.strFirstName, user.strLastName];
}

- (void)setJobID:(NSString *)jobID opUserID:(NSString *)opUserID {
	[self.phoneCallBtn setEnabled:NO];
	[self.chatBtn setEnabled:NO];
	
	[DogJob fetchJob:jobID completion:^(DogJob *job) {
		if (job == nil) {
			return;
		}
		
		self.curJob = job;
		
		self.jobTitleLbl.text = job.jobTitle;
		
		// check if it is hired
		if (job.hiredUsers && job.hiredUsers.count > 0) {
			[self.hireBtn setEnabled:NO];
		}
		
		[DogUser fetchUser:opUserID completion:^(DogUser *user) {
			if (user == nil) {
				return;
			}
			self.opUser = user;
			
			[self.phoneCallBtn setEnabled:YES];
			[self.chatBtn setEnabled:YES];
			
			[self setDogUser:user];
		}];
	}];
}

@end
