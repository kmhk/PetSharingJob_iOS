//
//  SitterTermsVC.m
//  Petsharing
//
//  Created by LandToSky on 7/25/17.
//  Copyright © 2017 LandToSky. All rights reserved.
//

#import "SitterTermsVC.h"

@interface SitterTermsVC ()

@end

@implementation SitterTermsVC

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
    
}



#pragma mark - Button Action

- (IBAction)onContinue:(id)sender
{
    [self performSegueWithIdentifier:@"SitterPaymentInfoVCSegue" sender:nil];
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
