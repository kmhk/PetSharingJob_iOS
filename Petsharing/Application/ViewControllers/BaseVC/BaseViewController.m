//
//  BaseViewController.m
//  Doo
//
//  Created by Jose on 12/19/15.
//  Copyright © 2015 simon. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isLoadingBase = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (IBAction)onBack:(id)sender{
   if (self.isLoadingBase) return;
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onMenuShow:(id)sender{
    [self.sideMenuController showLeftViewAnimated:sender];

}



@end
