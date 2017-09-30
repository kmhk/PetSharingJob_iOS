//
//  FindJobDetailVC.m
//  Petsharing
//
//  Created by LandToSky on 8/22/17.
//  Copyright © 2017 LandToSky. All rights reserved.
//

#import "FindJobDetailVC.h"
#import "DogJob.h"
#import "FirebaseRef.h"
#import "DogUser.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SitterTbVC.h"


@interface FindJobDetailVC ()
{
    IBOutlet UIScrollView *mScrollView;
    IBOutlet UIView *contentView;
	
	IBOutlet UIImageView *imgViewAvatar;
	IBOutlet UILabel *lblTitle;
	IBOutlet UILabel *lblPrice;
	IBOutlet UILabel *lblOwner;
	IBOutlet UILabel *lblJobAddress;
	IBOutlet UILabel *txtDescription;
	IBOutlet UILabel *lblStartDate;
	IBOutlet UILabel *lblEndDate;

	IBOutlet UIButton *btnApply;
	IBOutlet UILabel *lblNoteApplied;
}

@end

@implementation FindJobDetailVC

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
	if (self.job) {
		[[FirebaseRef storageForAvatar:self.job.jobOwnerID] downloadURLWithCompletion:^(NSURL * _Nullable URL, NSError * _Nullable error) {
			if (error) {
				[commonUtils showAlert:@"Warning!" withMessage:error.localizedDescription];
				return;
			}
			
			[imgViewAvatar sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"avatar5"]];
		}];
		
		lblTitle.text = self.job.jobTitle;
		lblOwner.text = [NSString stringWithFormat:@"$ %.0f", self.job.jobPrice];
		lblJobAddress.text = self.job.jobAddress;
		txtDescription.text = self.job.jobDescription;
		lblStartDate.text = [commonUtils convertDateToString:self.job.jobStartDate];
		lblEndDate.text = [commonUtils convertDateToString:self.job.jobEndDate];
		
	} else {
		[commonUtils showAlert:@"Warning!" withMessage:@"Failed to load job detail"];
	}
	
	if (self.job.appliedUsers && [self.job.appliedUsers indexOfObject:[DogUser curUser].userID] != NSNotFound) {
		[btnApply setEnabled:NO];
		[lblNoteApplied setHidden:NO];
	}
}

- (void)initUI
{
    [mScrollView setContentSize:contentView.frame.size];
    
}


// MARK: - button action

- (IBAction)applyBtnTapped:(id)sender {
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	
	[sitterViewModel applyJobTo:self.job completion:^(NSError *error) {
		[MBProgressHUD hideHUDForView:self.view animated:YES];
		
		if (error) {
			[commonUtils showAlert:@"Warning!" withMessage:error.localizedDescription];
			return;
		}
		
		[commonUtils showAlert:@"Success" withMessage:@"You have applied to this job"];
		
		[btnApply setEnabled:NO];
		
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
