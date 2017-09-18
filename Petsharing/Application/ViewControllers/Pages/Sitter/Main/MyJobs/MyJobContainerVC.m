//
//  MyJobContainerVC.m
//  Petsharing
//
//  Created by LandToSky on 8/22/17.
//  Copyright © 2017 LandToSky. All rights reserved.
//

#import "MyJobContainerVC.h"

@interface MyJobContainerVC ()
{
    IBOutlet UIImageView *hiredSegmentIv;
    IBOutlet UIImageView *pastSegmentIv;
    IBOutlet UIView *containerHiredView;
    IBOutlet UIView *containerPastView;
    
    
}

@end

@implementation MyJobContainerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
}

- (void)initData
{
    
}

- (void) initUI
{
    
}

- (IBAction)onHired:(id)sender
{
    [hiredSegmentIv setImage:[UIImage imageNamed:@"segment-back-off"]];
    [pastSegmentIv setImage:[UIImage imageNamed:@"segment-back-on"]];
    [UIView animateWithDuration:0.5 animations:^{
        containerHiredView.alpha = 1;
        containerPastView.alpha = 0;
    }];
}

- (IBAction)onPast:(id)sender
{
    [hiredSegmentIv setImage:[UIImage imageNamed:@"segment-back-on"]];
    [pastSegmentIv setImage:[UIImage imageNamed:@"segment-back-off"]];
    [UIView animateWithDuration:0.5 animations:^{
        containerHiredView.alpha = 0;
        containerPastView.alpha = 1;
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
