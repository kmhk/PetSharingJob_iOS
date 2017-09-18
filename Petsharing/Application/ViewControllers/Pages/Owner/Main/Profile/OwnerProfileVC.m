//
//  OwnerProfileVC.m
//  Petsharing
//
//  Created by LandToSky on 8/25/17.
//  Copyright © 2017 LandToSky. All rights reserved.
//

#import "OwnerProfileVC.h"

@interface OwnerProfileVC ()
{
    IBOutlet UIScrollView *mScrollView;
    IBOutlet UIView *contentView;
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
    
}

- (void)initUI
{
    [mScrollView setContentSize:contentView.frame.size];
}

- (IBAction)onOwnerSignout:(id)sender
{
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
