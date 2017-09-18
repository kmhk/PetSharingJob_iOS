//
//  FindJobVC.m
//  Petsharing
//
//  Created by LandToSky on 8/22/17.
//  Copyright © 2017 LandToSky. All rights reserved.
//

#import "FindJobVC.h"

@interface FindJobVC ()
{
    IBOutlet UIView *containerMapView;
    IBOutlet UIView *containerListView;
    IBOutlet UIImageView *mapSegmentBackIv;
    IBOutlet UIImageView *listSegmentBackIv;
  
    
}

@end

@implementation FindJobVC

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

- (IBAction)onMap:(id)sender
{
    [mapSegmentBackIv setImage:[UIImage imageNamed:@"segment-off"]];
    [listSegmentBackIv setImage:[UIImage imageNamed:@"segment-on"]];
    [UIView animateWithDuration:0.5 animations:^{
        containerMapView.alpha = 1;
        containerListView.alpha = 0;
    }];
}

- (IBAction)onList:(id)sender
{
    [mapSegmentBackIv setImage:[UIImage imageNamed:@"segment-on"]];
    [listSegmentBackIv setImage:[UIImage imageNamed:@"segment-off"]];
    [UIView animateWithDuration:0.5 animations:^{
        containerMapView.alpha = 0;
        containerListView.alpha = 1;
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
