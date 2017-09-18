//
//  FirstVC.m
//  TemplateObj-C
//
//  Created by LandtoSky on 10/6/16.
//  Copyright © 2016 landtosky2018. All rights reserved.
//

#import "FirstVC.h"

@interface FirstVC () {
    
    IBOutlet UILabel *requestResLbl;
}

@end

@implementation FirstVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self initData];
}

- (void)initUI {
    
}

- (void)initData {
    NSDictionary *param = @{
                            @"user_id":@(1)
                            
                            };
    [self requestSocialSignUp:param];
}

#pragma mark - Request Social Sign Up
- (void) requestSocialSignUp:(NSDictionary *)param{
    
    self.isLoadingUserBase = YES;
    NSLog(@" User Info ==>\n%@", param);
    
    
    [JSWaiter ShowWaiter:self.view title:@"Testing now..." type:0];
    [[DatabaseController sharedManager] test:param onSuccess:^(id response){
        
        [JSWaiter HideWaiter];
        NSLog(@"response Data : %@", response);
        self.isLoadingUserBase = NO;
        
        [self requestSocialSignUpOver:response];
        
        
    } onFailure:^(id error){
        
        [JSWaiter HideWaiter];
        [commonUtils showVAlertSimple:@"Connection Error" body:MSG_CHECK_INTERNET_CONNECTION duration:1.2f];
        self.isLoadingUserBase = NO;
    }];
    
}

- (void) requestSocialSignUpOver: (NSDictionary*)response {
    
    [requestResLbl setText:response[@"test"]];
//    if ([response[@"status"] integerValue] == 1) {
    
        
//        appController.currentUser = [response objectForKey:@"current_user"];
//        [commonUtils setUserDefaultDic:@"current_user" withDic:appController.currentUser];
        
//        SidePanelVC *vc = (SidePanelVC*) [self.storyboard instantiateViewControllerWithIdentifier:@"SidePanelVC"];
//        [self.navigationController pushViewController:vc animated:YES];
        
        
//    } else {
//        
//        NSString *msg = (NSString *)[response objectForKey:@"msg"];
//        if([msg isEqualToString:@""]) msg = MSG_FILL_FORM_CORRECTLY;
//        [commonUtils showVAlertSimple:@"Failed" body:msg duration:1.4f];
//        
//    }
}

@end
