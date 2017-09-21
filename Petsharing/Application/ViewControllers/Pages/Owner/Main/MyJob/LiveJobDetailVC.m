//
//  LiveTaskDetailVC.m
//  Petsharing
//
//  Created by LandToSky on 8/23/17.
//  Copyright © 2017 LandToSky. All rights reserved.
//

#import "LiveJobDetailVC.h"
#import "CustomBadge.h"  //https://github.com/ckteebe/CustomBadge
#import "DogJob.h"
#import "SitterListVC.h"


@interface LiveJobDetailVC ()

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblPrice;
@property (strong, nonatomic) IBOutlet UILabel *lblJobAddress;
@property (strong, nonatomic) IBOutlet UILabel *txtDescription;
@property (strong, nonatomic) IBOutlet UILabel *lblStartDate;
@property (strong, nonatomic) IBOutlet UILabel *lblEndDate;

@end


@implementation LiveJobDetailVC

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
		self.lblTitle.text = self.job.jobTitle;
		self.lblPrice.text = [NSString stringWithFormat:@"$ %.0f", self.job.jobPrice];
		self.lblJobAddress.text = self.job.jobAddress;
		self.txtDescription.text = self.job.jobDescription;
		self.lblStartDate.text = [commonUtils convertDateToString:self.job.jobStartDate];
		self.lblEndDate.text = [commonUtils convertDateToString:self.job.jobEndDate];
		
	} else {
		[commonUtils showAlert:@"Warning!" withMessage:@"Failed to load job detail"];
	}
}

- (void) initUI
{
	if (self.job.appliedUsers && self.job.appliedUsers.count) {
		CustomBadge *badge = [CustomBadge customBadgeWithString:[NSString stringWithFormat:@"%lu", (unsigned long)self.job.appliedUsers.count]];
		UIView *applicantView = [self.view viewWithTag:1001];
		[applicantView addSubview:badge];
		[commonUtils moveView:badge withMoveX:90 withMoveY:0];
	}
//
//    CustomBadge *badge1 = [CustomBadge customBadgeWithString:@"3"];
//    UIView *messageView = [self.view viewWithTag:1002];
//    [messageView addSubview:badge1];
//    [commonUtils moveView:badge1 withMoveX:90 withMoveY:0];
}

- (IBAction)userListBtnTapped:(id)sender {
	if (self.job.appliedUsers && self.job.appliedUsers.count) {
		[self performSegueWithIdentifier:@"segueListUsers" sender:nil];
	}
}

- (IBAction)chatListBtnTapped:(id)sender {
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
	if ([segue.identifier isEqualToString:@"segueListUsers"]) {
		SitterListVC *vc = (SitterListVC *)segue.destinationViewController;
		vc.arrayUsers = self.job.appliedUsers;
		vc.jobTitle = self.job.jobTitle;
	}
}


@end
