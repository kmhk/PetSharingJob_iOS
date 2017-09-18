//
//  MyTaskContainerVC.m
//  Petsharing
//
//  Created by LandToSky on 8/23/17.
//  Copyright © 2017 LandToSky. All rights reserved.
//

#import "MyTaskContainerVC.h"
#import "PastJobVC.h"

@interface MyTaskContainerVC ()
{
    IBOutlet UIImageView *liveSegmentIv;
    IBOutlet UIImageView *pastSegmentIv;
    IBOutlet UIView *containerLiveView;
    IBOutlet UIView *containerPastView;
}

@end

@implementation MyTaskContainerVC

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
    PastJobVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PastJobVC"];
    [vc willMoveToParentViewController:self];
    [containerPastView addSubview:vc.view];
    [self addChildViewController:vc];
    [vc didMoveToParentViewController:self];    
    
}

- (IBAction)onLive:(id)sender
{
    [liveSegmentIv setImage:[UIImage imageNamed:@"segment-back-off"]];
    [pastSegmentIv setImage:[UIImage imageNamed:@"segment-back-on"]];
    [UIView animateWithDuration:0.5 animations:^{
        containerLiveView.alpha = 1;
        containerPastView.alpha = 0;
    }];
}

- (IBAction)onPast:(id)sender
{
    [liveSegmentIv setImage:[UIImage imageNamed:@"segment-back-on"]];
    [pastSegmentIv setImage:[UIImage imageNamed:@"segment-back-off"]];
    [UIView animateWithDuration:0.5 animations:^{
        containerLiveView.alpha = 0;
        containerPastView.alpha = 1;
    }];
}
@end
