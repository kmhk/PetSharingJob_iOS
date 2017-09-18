//
//  UserBaseViewController.m
//  Doo
//
//  Created by Jose on 2/25/16.
//  Copyright © 2016 simon. All rights reserved.
//

#import "UserBaseViewController.h"


@interface UserBaseViewController ()

@end

@implementation UserBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if([commonUtils getUserDefault:@"current_user_user_id"] != nil) {
//        appController.currentUser = [commonUtils getUserDefaultDicByKey:@"current_user"];
//        MySidePanelVC *sidePanelVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MySidePanelVC"];
//      [self.navigationController presentViewController:sidePanelVC animated:NO completion: nil];
        return;
    }
    if([[commonUtils getUserDefault:@"logged_out"] isEqualToString:@"1"]) {
        [commonUtils removeUserDefault:@"logged_out"];

//        
//        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
//        [login logOut];
//        [FBSDKAccessToken setCurrentAccessToken:nil];
        
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    
    self.isLoadingUserBase = NO;
}


- (BOOL) prefersStatusBarHidden {
    return NO;
}

#pragma mark - Nagivate Events
- (void) navToMainView {
//    MySidePanelVC *sidePanelVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MySidePanelVC"];
//    [self.navigationController presentViewController:sidePanelVC animated:YES completion: nil];

}
- (IBAction)onBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
