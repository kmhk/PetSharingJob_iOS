//
//  PastJobDetailVC.m
//  Petsharing
//
//  Created by LandToSky on 8/22/17.
//  Copyright © 2017 LandToSky. All rights reserved.
//

#import "PastJobDetailVC.h"
#import "DogJob.h"
#import "DogUser.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface PastJobDetailVC ()

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblLocation;
@property (strong, nonatomic) IBOutlet UILabel *lblDescription;

@property (strong, nonatomic) IBOutlet UILabel *lblPrice;
@property (strong, nonatomic) IBOutlet UILabel *lblStartTime;
@property (strong, nonatomic) IBOutlet UILabel *lblEndTime;

@property (strong, nonatomic) IBOutlet UIImageView *imgOwner;
@property (strong, nonatomic) IBOutlet UILabel *lblOwnerName;

@property (strong, nonatomic) IBOutlet UIImageView *imgSitter;
@property (strong, nonatomic) IBOutlet UILabel *lblSittername;

@property (strong, nonatomic) IBOutlet UILabel *lblFinishedTime;

@end

@implementation PastJobDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData {
	if (!self.jobID) {
		return;
	}
	
	[DogJob fetchJob:self.jobID completion:^(DogJob *job) {
		self.lblTitle.text = job.jobTitle;
		self.lblLocation.text = job.jobAddress;
		self.lblDescription.text = job.jobDescription;
		self.lblPrice.text = [NSString stringWithFormat:@"%.0f", job.jobPrice];
		self.lblStartTime.text = [commonUtils convertDateToString:job.jobStartDate];
		self.lblEndTime.text = [commonUtils convertDateToString:job.jobEndDate];
		self.lblFinishedTime.text = [commonUtils convertDateToString:job.jobFinishedDate];
		
		[DogUser fetchUser:job.jobOwnerID completion:^(DogUser *user) {
			self.lblOwnerName.text = [NSString stringWithFormat:@"%@ %@", user.strFirstName, user.strLastName];
		}];
		
		[DogUser fetchUser:job.hiredUsers.firstObject completion:^(DogUser *user) {
			self.lblSittername.text = [NSString stringWithFormat:@"%@ %@", user.strFirstName, user.strLastName];
		}];
		
		[[FirebaseRef storageForAvatar:job.jobOwnerID] downloadURLWithCompletion:^(NSURL * _Nullable URL, NSError * _Nullable error) {
			[self.imgOwner sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"avatar5"]];
		}];
		
		[[FirebaseRef storageForAvatar:job.hiredUsers.firstObject] downloadURLWithCompletion:^(NSURL * _Nullable URL, NSError * _Nullable error) {
			[self.imgSitter sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"avatar5"]];
		}];
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
