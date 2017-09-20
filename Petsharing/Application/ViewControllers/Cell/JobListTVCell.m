//
//  JobListTVCell.m
//  Petsharing
//
//  Created by LandToSky on 8/21/17.
//  Copyright © 2017 LandToSky. All rights reserved.
//

#import "JobListTVCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DogUser.h"
#import "DogJob.h"


@implementation JobListTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setJob:(DogJob *)job {
	[[FirebaseRef storageForAvatar:job.jobOwnerID] downloadURLWithCompletion:^(NSURL * _Nullable URL, NSError * _Nullable error) {
		
		[self.jobOwnerPhotoIv sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"avatar5"]];
	}];
	
	self.jobTitleLbl.text = job.jobTitle;
}

@end
