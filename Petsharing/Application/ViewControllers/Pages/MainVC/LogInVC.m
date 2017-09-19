//
//  LogInViewController.m
//  ArmyAsap
//
//  Copyright © 2015 admin. All rights reserved.
//

#import "LogInVC.h"
#import "DogUser.h"
#import "SitterTbVC.h"
#import "OwnerTbVC.h"

@interface LogInVC () <UIScrollViewDelegate, UITextFieldDelegate>
{
    IBOutlet UIScrollView *scrollView;
    IBOutlet UITextField *txtFieldUserEmail;
    IBOutlet UITextField *txtFieldPwd;
    IBOutlet UIButton *btn_login;
    
}
@end

@implementation LogInVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.view endEditing:YES];
}


#pragma mark - init
- (void)initUI {

    [scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTappedScreen)]];
}

- (IBAction)onBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)onLogin:(id)sender {
    [self.view endEditing:YES];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    NSString *email = txtFieldUserEmail.text;
    NSString *Password = txtFieldPwd.text;
    
    if (!email.length) {
        [commonUtils showAlert:@"Warning!" withMessage:@"Email is required."];
		
    } else if (!Password.length) {
        [commonUtils showAlert:@"Warning!" withMessage:@"Password is required."];
		
    } else if(![commonUtils validateEmail:email]) {
        [commonUtils showAlert:@"Warning!" withMessage:@"Email is not valid."];
		
    } else {
		[MBProgressHUD showHUDAddedTo:self.view animated:YES];
		
		[[DogUser curUser] login:email password:Password completion:^(NSError *error) {
			[MBProgressHUD hideHUDForView:self.view animated:YES];
			
			if (error) {
				[commonUtils showAlert:@"Warning!" withMessage:error.localizedDescription];
				return;
			}
			
			NSMutableDictionary *loginDic = [[NSMutableDictionary alloc] init];
			[loginDic setObject:@"1" forKey:@"signin_mode"];
			[loginDic setObject:email forKey:@"user_email"];
			[loginDic setObject:Password forKey:@"user_password"];

			if ([DogUser curUser].userRole == DogUserRoleOwner) {
				OwnerTbVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"OwnerTbVC"];
				[self presentViewController:vc animated:YES completion:nil];
				
			} else {
				SitterTbVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SitterTbVC"];
				[self presentViewController:vc animated:YES completion:nil];
			}

		}];
    }
}




#pragma mark - TextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    float offset = 0;
    if(textField == txtFieldUserEmail) {
        offset = 250;
    } else if(textField == txtFieldPwd) {
        offset = 220;
    }
    
    [scrollView setContentOffset:CGPointMake(0, offset) animated:YES];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    return [textField resignFirstResponder];
}


#pragma mark - UIButtonEvents
- (IBAction)onForgotBtn:(id)sender
{
    [self.view endEditing:YES];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];

}


#pragma mark - ScrollView Tap
- (void) onTappedScreen {
    [self.view endEditing:YES];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}
@end
