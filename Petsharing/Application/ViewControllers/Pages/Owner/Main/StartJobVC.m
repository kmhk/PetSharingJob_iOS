//
//  HireSitterVC.m
//  Petsharing
//
//  Created by LandToSky on 8/27/17.
//  Copyright © 2017 LandToSky. All rights reserved.
//

#import "StartJobVC.h"
#import "DogJob.h"
#import "DogUser.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "OwnerTbVC.h"


@interface StartJobVC ()
{
    IBOutlet UIScrollView *mScrollView;
    IBOutlet UIView *contentView;
	
	IBOutlet UILabel *lblTitle;
	IBOutlet UILabel *lblAdress;
	IBOutlet UILabel *txtViewDescription;
	IBOutlet UILabel *lblPrice;
	IBOutlet UILabel *lblStartTime;
	IBOutlet UILabel *lblEndTime;
	
	IBOutlet UIImageView *imgViewOwner;
	IBOutlet UILabel *lblOwnerName;
	
	IBOutlet UIImageView *imgViewSitter;
	IBOutlet UILabel *lblSitterName;
}

@end

@implementation StartJobVC

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
	lblTitle.text = self.curJob.jobTitle;
	lblAdress.text = self.curJob.jobAddress;
	txtViewDescription.text = self.curJob.jobDescription;
	lblPrice.text = [NSString stringWithFormat:@"%.0f USD", self.curJob.jobPrice];
	lblStartTime.text = [commonUtils convertDateToString:self.curJob.jobStartDate];
	lblEndTime.text = [commonUtils convertDateToString:self.curJob.jobEndDate];
	
	[[FirebaseRef storageForAvatar:[DogUser curUser].userID] downloadURLWithCompletion:^(NSURL * _Nullable URL, NSError * _Nullable error) {
		if (error) {
			[commonUtils showAlert:@"Warning!" withMessage:error.localizedDescription];
			return;
		}
		
		[imgViewOwner sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"avatar5"]];
	}];
	lblOwnerName.text = [NSString stringWithFormat:@"%@ %@", [DogUser curUser].strFirstName, [DogUser curUser].strLastName];
	
	[[FirebaseRef storageForAvatar:self.choosenSitter.userID] downloadURLWithCompletion:^(NSURL * _Nullable URL, NSError * _Nullable error) {
		if (error) {
			[commonUtils showAlert:@"Warning!" withMessage:error.localizedDescription];
			return;
		}
		
		[imgViewSitter sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"avatar5"]];
	}];
	lblSitterName.text = [NSString stringWithFormat:@"%@ %@", self.choosenSitter.strFirstName, self.choosenSitter.strLastName];
}

- (void)initUI
{
    [mScrollView setContentSize:contentView.frame.size];
}

- (IBAction)startJobBtnTapped:(id)sender {
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	
	[ownerViewModel hireSitter:self.choosenSitter job:self.curJob completion:^(NSError *error) {
		[MBProgressHUD hideHUDForView:self.view animated:NO];
		
		if (error) {
			[commonUtils showAlert:@"Warning!" withMessage:error.localizedDescription];
			return;
		}
		
		[commonUtils showAlert:@"Success" withMessage:@"You hired sitter successfully."];
		[self.navigationController popToRootViewControllerAnimated:YES];
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
