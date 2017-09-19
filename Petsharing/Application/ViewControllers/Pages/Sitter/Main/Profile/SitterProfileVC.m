//
//  SitterProfileVC.m
//  Petsharing
//
//  Created by LandToSky on 8/23/17.
//  Copyright © 2017 LandToSky. All rights reserved.
//

#import "SitterProfileVC.h"
#import "DogUser.h"
#import "HCSStarRatingView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DogUser.h"

@interface SitterProfileVC ()
{
    IBOutlet UIScrollView *mScrollView;
    IBOutlet UIView *contentView;
	
	IBOutlet UIImageView *imgViewAvatar;
	IBOutlet UILabel *lblName;
	IBOutlet HCSStarRatingView *viewRate;
	IBOutlet UILabel *lblJobs;
	IBOutlet UITextView *txtViewIntroduction;
}

@end

@implementation SitterProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
}

- (void) initData
{
	[[FirebaseRef storageForAvatar:[DogUser curUser].userID] downloadURLWithCompletion:^(NSURL * _Nullable URL, NSError * _Nullable error) {
		if (error) {
			[commonUtils showAlert:@"Warning!" withMessage:error.localizedDescription];
			return;
		}
		
		[imgViewAvatar sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"avatar5"]];
	}];
	
	lblName.text = [NSString stringWithFormat:@"%@ %@", [DogUser curUser].strFirstName, [DogUser curUser].strLastName];
	
	viewRate.value = 2.5;//gCurUser.fRate;
	
	lblJobs.text = [NSString stringWithFormat:@"from %d jobs", 3];
	
	txtViewIntroduction.text = [DogUser curUser].strCategory;
}

- (void)initUI
{
    [mScrollView setContentSize:contentView.frame.size];
}

- (IBAction)onSitterSignout:(id)sender
{
	[[DogUser curUser] logout];
	
    [[AppDelegate sharedAppDelegate] logOut];
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
