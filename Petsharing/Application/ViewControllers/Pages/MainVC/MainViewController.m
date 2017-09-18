//
//  MainViewController.m
//  ArmyAsap
//
//  Copyright © 2015 admin. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController (){
    
    __weak IBOutlet UIView *overlayerView;
    __weak IBOutlet UIButton *btn_login;
    __weak IBOutlet UIView *facebookView;
}

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [commonUtils overlayGradientView:overlayerView];
    overlayerView.layer.opacity = 0.6;
    overlayerView.layer.masksToBounds = YES;
    [commonUtils setRoundedRectBorderButton:btn_login withBorderWidth:2 withBorderColor:[UIColor whiteColor] withBorderRadius:15];
    [commonUtils setRoundedRectView:facebookView withCornerRadius:15];
}

@end
