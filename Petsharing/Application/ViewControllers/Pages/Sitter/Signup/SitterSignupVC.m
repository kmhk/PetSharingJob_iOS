//
//  DogsitterViewController.m
//  PetSharing
//
//  Created by panda on 12/17/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "SitterSignupVC.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "LogInVC.h"

@interface SitterSignupVC (){
}

@end

@implementation SitterSignupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    appController.currentUserType = @"sitter";
}

- (IBAction)onDogOwner:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    UIViewController *vc = [self.navigationController.viewControllers objectAtIndex:0];
    [vc performSegueWithIdentifier:@"OwnerSignupVCSegue" sender:nil];
}


- (IBAction)onLogin:(id)sender
{
    LogInVC *vc= [self.storyboard instantiateViewControllerWithIdentifier:@"LogInVC"];
    vc.providesPresentationContextTransitionStyle = YES;
    vc.definesPresentationContext = YES;
    [vc setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}


#pragma mark - Facebook Login
- (IBAction)onLoginFacebook:(id)sender {
    if(self.isLoadingUserBase) return;
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    
    if([FBSDKAccessToken currentAccessToken]){
        [self fetchUserInfo];
    }else{
        [login
         logInWithReadPermissions: @[@"public_profile", @"email", @"user_friends"]
         fromViewController:self
         handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
             if (error) {
                 NSLog(@"Process error");
             } else if (result.isCancelled) {
                 NSLog(@"Cancelled");
             } else {
                 NSLog(@"Logged in with token : @%@", result.token);
                 if ([result.grantedPermissions containsObject:@"email"]) {
                     
                     [self performSelectorOnMainThread:@selector(fetchUserInfo) withObject:nil waitUntilDone:YES];
                 }
             }
         }];
    }
}

- (void)fetchUserInfo {
    
    self.isLoadingUserBase = YES;
//    [commonUtils showActivityIndicator:self.view];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    
//    if([commonUtils getUserDefault:@"currentLatitude"] && [commonUtils getUserDefault:@"currentLongitude"]) {
//        [paramDic setObject:[commonUtils getUserDefault:@"currentLatitude"] forKey:@"user_location_latitude"];
//        [paramDic setObject:[commonUtils getUserDefault:@"currentLongitude"] forKey:@"user_location_longitude"];
//    } else {
//        [commonUtils showVAlertSimple:@"Warning" body:[NSString stringWithFormat:@"You must allow Petshare to access your location to use this app.\nGo to settings and allow location access."] duration:1.2];
//        return;
//    }
    
    if ([FBSDKAccessToken currentAccessToken]) {
        NSLog(@"Token is available : %@",[[FBSDKAccessToken currentAccessToken] tokenString]);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, link, first_name, last_name, picture.type(large), email, gender"}]
             startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                 if (!error) {
                     NSLog(@"facebook fetched info : %@", result);
                     
                     [paramDic setObject:@"Sitter" forKey:@"user_type"];
                     
                     NSDictionary *temp = (NSDictionary *)result;
                     NSMutableDictionary *userTemp = [[NSMutableDictionary alloc] initWithDictionary:temp];
                     
                     [paramDic setObject:[temp objectForKey:@"id"] forKey:@"user_facebook_id"];
                     
                     if([commonUtils checkKeyInDic:@"email" inDic:userTemp]) {
                         [paramDic setObject:[temp objectForKey:@"email"] forKey:@"user_email"];
                     }
                     
                     if([commonUtils checkKeyInDic:@"first_name" inDic:userTemp]) {
                         [paramDic setObject:[temp objectForKey:@"first_name"] forKey:@"user_first_name"];
                     }
                     if([commonUtils checkKeyInDic:@"last_name" inDic:userTemp]) {
                         [paramDic setObject:[temp objectForKey:@"last_name"] forKey:@"user_last_name"];
                     }
                     
                     NSString *fbProfilePhoto = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [temp objectForKey:@"id"]];
                     [paramDic setObject:fbProfilePhoto forKey:@"user_photo_url"];
                     
                     [paramDic setObject:@"2" forKey:@"signin_mode"];
//                     [self requestAPI:paramDic];
                     
                 } else {
                     self.isLoadingUserBase = NO;
                     [commonUtils hideActivityIndicator];
                     [commonUtils showVAlertSimple:@"Error" body:[NSString stringWithFormat:@"%@", error] duration:2.0f];
                 }
             }];
            
        });
    }
    
}
#pragma mark - API Request
- (void)requestAPI:(NSMutableDictionary *)dic {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loginWithParam:dic];
    });
}
- (void)loginWithParam:(NSMutableDictionary *)loginDic {
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_USER_LOGIN withJSON:(NSMutableDictionary *) loginDic];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary*)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            appController.currentUser = [result objectForKey:@"current_user"];
            [commonUtils setUserDefaultDic:@"current_user"  withDic:appController.currentUser];
            [self requestOverLogin:appController.currentUser];
            
        } else if([status intValue] == 2) {
            appController.signupMode = @"2";
//            appController.sitterSignUpDataDic = loginDic;
//            [self performSegueWithIdentifier:@"sittersignupSegue" sender:nil];
        }
    } else {
        [commonUtils showVAlertSimple:@"Connection Error" body:@"Please check your internet connection status" duration:1.0];
    }
    
    
}
- (void)requestOverLogin:(id)params {
    NSLog(@"%@",[params objectForKey:@"user_type"]);
    if ([[params objectForKey:@"user_type"] isEqualToString:@"Sitter"]) {
//        MainVC *mainVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MainVC"];
//        [mainVC setSharedInstance];
//        [self presentViewController:mainVC animated:YES completion:nil];
    } else {
//        EmployerMainVC *employerMainVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployerMainVC"];
//        [employerMainVC setSharedInstance];
//        [self presentViewController:employerMainVC animated:YES completion:nil];
    }
}



@end
