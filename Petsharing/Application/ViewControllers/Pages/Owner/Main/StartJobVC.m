//
//  HireSitterVC.m
//  Petsharing
//
//  Created by LandToSky on 8/27/17.
//  Copyright © 2017 LandToSky. All rights reserved.
//

#import "StartJobVC.h"

@interface StartJobVC ()
{
    IBOutlet UIScrollView *mScrollView;
    IBOutlet UIView *contentView;
}

@end

@implementation StartJobVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
}

- (void)initData
{
    
}

- (void)initUI
{
    [mScrollView setContentSize:contentView.frame.size];
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
