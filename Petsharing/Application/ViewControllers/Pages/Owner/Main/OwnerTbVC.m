//
//  OwnerTbVC.m
//  Petsharing
//
//  Created by LandToSky on 8/23/17.
//  Copyright © 2017 LandToSky. All rights reserved.
//

#import "OwnerTbVC.h"

@interface OwnerTbVC ()<UITabBarControllerDelegate>

@end

@implementation OwnerTbVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // remove tabbar upper line
    [self.tabBar setValue:@(YES) forKeyPath:@"_hidesShadow"];
    
    //set tabbar backgournd color as clear
    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"top-back"]];
    [[UITabBar appearance] setTintColor:[UIColor blackColor]]; // for selected items that are gray
    [[UITabBar appearance] setUnselectedItemTintColor:[UIColor whiteColor]]; // for unselected items that are green
    
    
    for (UITabBarItem* item in self.tabBar.items)
    {
        [item setTitlePositionAdjustment:UIOffsetMake(0, -10)];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName :[UIColor blackColor]} forState:UIControlStateSelected];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName :[UIColor whiteColor],
                                       NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:13.0f]}
                            forState:UIControlStateNormal];
        
    }
    self.delegate = self;
	
	self.viewModel = [[OwnerViewModel alloc] init];
	
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	[self.viewModel loadAllMyJobs:^(NSError *error) {
		[MBProgressHUD hideHUDForView:self.view animated:YES];
		
		if (error) {
			[commonUtils showAlert:@"Warning!" withMessage:error.localizedDescription];
			return;
		}
	}];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.tabBar invalidateIntrinsicContentSize];
    
    CGFloat tabSize = 64.0;
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if (UIInterfaceOrientationIsLandscape(orientation))
    {
        tabSize = 40.0f;
    }
    
    CGRect tabFrame = self.tabBar.frame;
    
    tabFrame.size.height = tabSize;
    
    tabFrame.origin.y = self.view.frame.origin.y;
    
    self.tabBar.frame = tabFrame;
    
    // Set the translucent property to NO then back to YES to
    // force the UITabBar to reblur, otherwise part of the
    // new frame will be completely transparent if we rotate
    // from a landscape orientation to a portrait orientation.
    
    self.tabBar.translucent = NO;
    self.tabBar.translucent = YES;
}

@end
