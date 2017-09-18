//
//  OwnerSignupVC.m
//  Petsharing
//
//  Created by LandToSky on 7/27/17.
//  Copyright © 2017 LandToSky. All rights reserved.
//

#import "OwnerSignupVC.h"
#import "LogInVC.h"

@interface OwnerSignupVC ()

@end

@implementation OwnerSignupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)onDogSitter:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    UIViewController *vc = [self.navigationController.viewControllers objectAtIndex:0];
    [vc performSegueWithIdentifier:@"SitterSignupVCSegue" sender:nil];
}


- (IBAction)onLogin:(id)sender
{
    LogInVC *vc= [self.storyboard instantiateViewControllerWithIdentifier:@"LogInVC"];
    vc.providesPresentationContextTransitionStyle = YES;
    vc.definesPresentationContext = YES;
    [vc setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self.navigationController presentViewController:vc animated:YES completion:nil];
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
