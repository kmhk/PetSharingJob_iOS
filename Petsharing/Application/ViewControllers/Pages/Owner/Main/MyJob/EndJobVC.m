//
//  EndJobVC.m
//  Petsharing
//
//  Created by LandToSky on 8/25/17.
//  Copyright © 2017 LandToSky. All rights reserved.
//

#import "EndJobVC.h"
#import "HCSStarRatingView.h"
#import "DogJob.h"
#import "DogUser.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "OwnerTbVC.h"


@interface EndJobVC ()
{
    IBOutlet UIScrollView *mScrollView;
    IBOutlet UIView *contentView;

	IBOutlet UILabel *lblJobTitle;
	IBOutlet UILabel *lblJobAddress;
	IBOutlet UILabel *lblJobPrice;
	IBOutlet UILabel *lblJobStart;
	IBOutlet UILabel *lblJobEnd;
	IBOutlet UIImageView *imgViewAvatarOwner;
	IBOutlet UILabel *lblOwnerName;
	IBOutlet UIImageView *imgViewAvatarSitter;
	IBOutlet UILabel *lblSitterName;
	IBOutlet UILabel *txtViewDescription;
    IBOutlet HCSStarRatingView *starRatingView;
    IBOutlet UILabel *ratingLbl;
	
	DogUser *sitter;
}

@end

@implementation EndJobVC

- (void)viewDidLoad {
    [super viewDidLoad];
	
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	[self initData];
	[self initUI];
}

- (void)initData
{
	lblJobTitle.text = self.curJob.jobTitle;
	lblJobAddress.text = self.curJob.jobAddress;
	txtViewDescription.text = self.curJob.jobDescription;
	lblJobPrice.text = [NSString stringWithFormat:@"%.0f USD", self.curJob.jobPrice];
	lblJobStart.text = [commonUtils convertDateToString:self.curJob.jobStartDate];
	lblJobEnd.text = [commonUtils convertDateToString:self.curJob.jobEndDate];
	
	[[FirebaseRef storageForAvatar:[DogUser curUser].userID] downloadURLWithCompletion:^(NSURL * _Nullable URL, NSError * _Nullable error) {
		if (error) {
			[commonUtils showAlert:@"Warning!" withMessage:error.localizedDescription];
			return;
		}
		
		[imgViewAvatarOwner sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"avatar5"]];
	}];
	lblOwnerName.text = [NSString stringWithFormat:@"%@ %@", [DogUser curUser].strFirstName, [DogUser curUser].strLastName];
	
	// for sitter
	[DogUser fetchUser:self.curJob.hiredUsers.firstObject completion:^(DogUser *user) {
		sitter = user;
		
		[[FirebaseRef storageForAvatar:user.userID] downloadURLWithCompletion:^(NSURL * _Nullable URL, NSError * _Nullable error) {
			if (error) {
				[commonUtils showAlert:@"Warning!" withMessage:error.localizedDescription];
				return;
			}
			
			[imgViewAvatarSitter sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"avatar5"]];
		}];
		lblSitterName.text = [NSString stringWithFormat:@"%@ %@", user.strFirstName, user.strLastName];
	}];
}

- (void)initUI
{
    [mScrollView setContentSize:contentView.frame.size];
}

- (IBAction)changeStarRating:(HCSStarRatingView*)sender {
    
    [ratingLbl setText:[NSString stringWithFormat:@"%.02f", sender.value]];
}

- (IBAction)endJob:(id)sender {
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	
	[ownerViewModel finishJob:sitter job:self.curJob completion:^(NSError *error) {
		[MBProgressHUD hideHUDForView:self.view animated:YES];
		
		if (error) {
			[commonUtils showAlert:@"Warning!" withMessage:error.localizedDescription];
		} else {
			[commonUtils showAlert:@"Success" withMessage:@"Job finished successfully"];
		}
		
		[self.navigationController popViewControllerAnimated:YES];
	}];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
