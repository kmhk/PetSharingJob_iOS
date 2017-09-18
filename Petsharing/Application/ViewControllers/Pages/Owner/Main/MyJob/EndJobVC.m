//
//  EndJobVC.m
//  Petsharing
//
//  Created by LandToSky on 8/25/17.
//  Copyright © 2017 LandToSky. All rights reserved.
//

#import "EndJobVC.h"
#import "HCSStarRatingView.h"

@interface EndJobVC ()
{
    IBOutlet UIScrollView *mScrollView;
    IBOutlet UIView *contentView;
    IBOutlet HCSStarRatingView *starRatingView;
    IBOutlet UILabel *ratingLbl;
}

@end

@implementation EndJobVC

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
- (IBAction)changeStarRating:(HCSStarRatingView*)sender {
    
    [ratingLbl setText:[NSString stringWithFormat:@"%.02f", sender.value]];
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
