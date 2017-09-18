//
//  LiveTaskDetailVC.m
//  Petsharing
//
//  Created by LandToSky on 8/23/17.
//  Copyright © 2017 LandToSky. All rights reserved.
//

#import "LiveJobDetailVC.h"
#import "CustomBadge.h"  //https://github.com/ckteebe/CustomBadge

@interface LiveJobDetailVC ()

@end

@implementation LiveJobDetailVC

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
    CustomBadge *badge = [CustomBadge customBadgeWithString:@"6"];
    UIView *applicantView = [self.view viewWithTag:1001];
    [applicantView addSubview:badge];
    [commonUtils moveView:badge withMoveX:90 withMoveY:0];
    
    CustomBadge *badge1 = [CustomBadge customBadgeWithString:@"3"];
    UIView *messageView = [self.view viewWithTag:1002];
    [messageView addSubview:badge1];
    [commonUtils moveView:badge1 withMoveX:90 withMoveY:0];
}
@end
