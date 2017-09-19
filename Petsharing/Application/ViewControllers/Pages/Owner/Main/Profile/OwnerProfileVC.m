//
//  OwnerProfileVC.m
//  Petsharing
//
//  Created by LandToSky on 8/25/17.
//  Copyright © 2017 LandToSky. All rights reserved.
//

#import "OwnerProfileVC.h"
#import "DogUser.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface OwnerProfileVC ()
{
    IBOutlet UIScrollView *mScrollView;
    IBOutlet UIView *contentView;
	
	IBOutlet UIImageView *imgViewAvatar;
	IBOutlet UILabel *lblName;
	IBOutlet UITextView *txtViewAboutMe;
	IBOutlet UITextView *txtViewAboutDog;
}

@end

@implementation OwnerProfileVC

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
	
	txtViewAboutMe.text = [DogUser curUser].strAboutMe;
	
	txtViewAboutDog.text = [DogUser curUser].strAboutDog;
}

- (void)initUI
{
    [mScrollView setContentSize:contentView.frame.size];
}

- (IBAction)onOwnerSignout:(id)sender
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
