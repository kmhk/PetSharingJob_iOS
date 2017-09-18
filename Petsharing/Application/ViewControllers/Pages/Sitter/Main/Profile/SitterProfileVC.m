//
//  SitterProfileVC.m
//  Petsharing
//
//  Created by LandToSky on 8/23/17.
//  Copyright © 2017 LandToSky. All rights reserved.
//

#import "SitterProfileVC.h"

@interface SitterProfileVC ()
{
    IBOutlet UIScrollView *mScrollView;
    IBOutlet UIView *contentView;
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
    
}

- (void)initUI
{
    [mScrollView setContentSize:contentView.frame.size];
}

- (IBAction)onSitterSignout:(id)sender
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
