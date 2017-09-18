//
//  SitterPaymentInfoVC.m
//  Petsharing
//
//  Created by LandToSky on 7/25/17.
//  Copyright © 2017 LandToSky. All rights reserved.
//

#import "SitterPaymentInfoVC.h"
#import "SitterTbVC.h"

@interface SitterPaymentInfoVC ()<UIScrollViewDelegate, UITextFieldDelegate>
{
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIView *containerView;
}
@end

@implementation SitterPaymentInfoVC

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
    scrollView.delegate = self;
    [scrollView setContentSize:containerView.frame.size];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTappedScreen)]];
}

#pragma mark - Button Action
- (IBAction)onStartPetsharing:(id)sender
{
    SitterTbVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SitterTbVC"];
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}
- (IBAction)onSkip:(id)sender
{
    SitterTbVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SitterTbVC"];
    [self.navigationController presentViewController:vc animated:YES completion:nil];

}


#pragma mark - Text Field Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.isLoadingUserBase) return NO;
    
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    return [textField resignFirstResponder];
}

- (void)onTappedScreen {
    [self.view endEditing:YES];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
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
