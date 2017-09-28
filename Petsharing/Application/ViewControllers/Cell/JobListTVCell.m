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
#import "AppDelegate.h"


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
	
	CLLocation *loc = [[CLLocation alloc] initWithLatitude:job.jobLocation.latitude longitude:job.jobLocation.longitude];
	CLLocationDistance distance = [[AppDelegate sharedAppDelegate].currentLocation distanceFromLocation:loc];
	
	if (distance > 1000) {
		self.jobStatusLbl.text = [NSString stringWithFormat:@"%.1f Km", distance/1000];
	} else {
		self.jobStatusLbl.text = [NSString stringWithFormat:@"%.1f m", distance];
	}
}

- (void)setJob:(DogJob *)job arrangedType:(NSInteger)type {
	[[FirebaseRef storageForAvatar:job.jobOwnerID] downloadURLWithCompletion:^(NSURL * _Nullable URL, NSError * _Nullable error) {
		
		[self.jobOwnerPhotoIv sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"avatar5"]];
	}];
	
	self.jobTitleLbl.text = job.jobTitle;
	
	if (type == 0) { // by time
		self.jobStatusLbl.text = [commonUtils convertDateToString:job.jobCreatedDate];
		self.markLocation.hidden = YES;
		
	} else if (type == 1) { // by price
		self.jobStatusLbl.text = [NSString stringWithFormat:@"$ %.0f", job.jobPrice];
		self.markLocation.hidden = YES;
		
	} else { // by distance
		CLLocation *loc = [[CLLocation alloc] initWithLatitude:job.jobLocation.latitude longitude:job.jobLocation.longitude];
		CLLocationDistance distance = [[AppDelegate sharedAppDelegate].currentLocation distanceFromLocation:loc];
		
		if (distance > 1000) {
			self.jobStatusLbl.text = [NSString stringWithFormat:@"%.1f Km", distance/1000];
		} else {
			self.jobStatusLbl.text = [NSString stringWithFormat:@"%.1f m", distance];
		}
		self.markLocation.hidden = NO;
	}
}

- (void)setJobID:(NSString *)jobID {
	[DogJob fetchJob:jobID completion:^(DogJob *job) {
		self.jobTitleLbl.text = job.jobTitle;
		[[FirebaseRef storageForAvatar:job.jobOwnerID] downloadURLWithCompletion:^(NSURL * _Nullable URL, NSError * _Nullable error) {
			
			[self.jobOwnerPhotoIv sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"avatar5"]];
		}];
	}];
}

@end
