//
//  DatabaseController.m
//  Heaters1
//
//  Created by Alex on 12/27/15.
//  Copyright © 2015 Alex. All rights reserved.
//

#import "DatabaseController.h"
#import "AppDelegate.h"

@implementation DatabaseController
+ (DatabaseController *)sharedManager {
    static DatabaseController *sharedManager = nil;
    static dispatch_once_t onceToken=0;
    dispatch_once(&onceToken, ^{
        sharedManager = [DatabaseController manager];
        [sharedManager setRequestSerializer:[AFJSONRequestSerializer serializer]];
        [sharedManager.requestSerializer setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        [sharedManager.requestSerializer setValue:API_KEY forHTTPHeaderField:@"api-key"];
        [sharedManager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
        
        
        
    });
    return sharedManager;
}

#pragma mark - User APIs

-(void)userSocialSignup:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock
{
    NSString *urlStr = API_URL_USER_SOCIAL_SIGNUP;
    [self POST:urlStr parameters:[params mutableCopy] onSuccess:completionBlock onFailure:failureBlock];
}

-(void)userManualSignup:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock
{
    NSString *urlStr = API_URL_USER_MANUAL_SIGNUP;
    [self POST:urlStr parameters:[params mutableCopy] onSuccess:completionBlock onFailure:failureBlock];
}

-(void)userCheckNameExist:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock
{
    NSString *urlStr = API_URL_USER_CHECK_NAME_EXIST;
    [self POST:urlStr parameters:[params mutableCopy] onSuccess:completionBlock onFailure:failureBlock];
}

-(void)userManualSignin:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock
{
    NSString *urlStr = API_URL_USER_MANUAL_SIGNIN;
    [self POST:urlStr parameters:[params mutableCopy] onSuccess:completionBlock onFailure:failureBlock];
}


-(void)userLogout:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock
{
    NSString *urlStr = API_URL_USER_LOGOUT;
    [self POST:urlStr parameters:[params mutableCopy] onSuccess:completionBlock onFailure:failureBlock];
}


-(void)userForgotPswd:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock
{
    NSString *urlStr = API_URL_USER_FORGOT_PASSWORD;
    [self POST:urlStr parameters:[params mutableCopy] onSuccess:completionBlock onFailure:failureBlock];
}

-(void)userVerifyCode:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock
{
    NSString *urlStr = API_URL_USER_VERIFY_CODE;
    [self POST:urlStr parameters:[params mutableCopy] onSuccess:completionBlock onFailure:failureBlock];
}

-(void)userSetNewPswd:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock
{
    NSString *urlStr = API_URL_USER_SET_NEW_PASSWORD;
    [self POST:urlStr parameters:[params mutableCopy] onSuccess:completionBlock onFailure:failureBlock];
}

-(void)userChangePswd:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock
{
    NSString *urlStr = API_URL_USER_CHANGE_PASSWORD;
    [self POST:urlStr parameters:[params mutableCopy] onSuccess:completionBlock onFailure:failureBlock];
}

-(void)updateMyLocation:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock
{
    NSString *urlStr = API_URL_UPDATE_MY_LOCATION;
    [self POST:urlStr parameters:[params mutableCopy] onSuccess:completionBlock onFailure:failureBlock];
}

-(void)getFeed:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock
{
    NSString *urlStr = API_URL_GET_FEED;
    [self POST:urlStr parameters:[params mutableCopy] onSuccess:completionBlock onFailure:failureBlock];
}

-(void)getRestaurantDetail:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock
{
    NSString *urlStr = API_URL_GET_RESTAURANT_DETAIL;
    [self POST:urlStr parameters:[params mutableCopy] onSuccess:completionBlock onFailure:failureBlock];
}

-(void)favoriteRestaurant:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock
{
    NSString *urlStr = API_URL_FAVORITE_RESTAURANT;
    [self POST:urlStr parameters:[params mutableCopy] onSuccess:completionBlock onFailure:failureBlock];
}

-(void)ignoreRestaurant:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock
{
    NSString *urlStr = API_URL_IGNORE_RESTAURANT;
    [self POST:urlStr parameters:[params mutableCopy] onSuccess:completionBlock onFailure:failureBlock];
}

-(void)rate:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock
{
    NSString *urlStr = API_URL_RATE;
    [self POST:urlStr parameters:[params mutableCopy] onSuccess:completionBlock onFailure:failureBlock];
}

-(void)userProfileUpdate:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock
{
    NSString *urlStr = API_URL_USER_PROFILE_UPDATE;
    [self POST:urlStr parameters:[params mutableCopy] onSuccess:completionBlock onFailure:failureBlock];
}

-(void)userProfilePhotoUpdate:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock
{
    NSString *urlStr = API_URL_USER_PROFILE_PHOTO_UPDATE;
    [self POST:urlStr parameters:[params mutableCopy] onSuccess:completionBlock onFailure:failureBlock];
}

-(void)userSettingsUpdate:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock
{
    NSString *urlStr = API_URL_USER_SETTINGS_UPDATE;
    [self POST:urlStr parameters:[params mutableCopy] onSuccess:completionBlock onFailure:failureBlock];
}

-(void)contact:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock
{
    NSString *urlStr = API_URL_CONTACT;
    [self POST:urlStr parameters:[params mutableCopy] onSuccess:completionBlock onFailure:failureBlock];
}

-(void)feedback:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock
{
    NSString *urlStr = API_URL_FEEDBACK;
    [self POST:urlStr parameters:[params mutableCopy] onSuccess:completionBlock onFailure:failureBlock];
}

-(void)addResPhoto:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock
{
    NSString *urlStr = API_URL_ADD_RES_PHOTO;
    [self POST:urlStr parameters:[params mutableCopy] onSuccess:completionBlock onFailure:failureBlock];
}



-(void)test:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock
{
    NSString *urlStr = API_URL_HG_TEST;
    [self POST:urlStr parameters:[params mutableCopy] onSuccess:completionBlock onFailure:failureBlock];
}

#pragma mark - Post and Get Function

- (void)POST:(NSString *)url
  parameters:(NSMutableDictionary*)parameters
   onSuccess:(SuccessBlock)completionBlock
   onFailure:(FailureBlock)failureBlock
{
    // Check out network connection
    NetworkStatus networkStatus = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@"There IS NO internet connection");
        [SHAlertHelper showOkAlertWithTitle:@"Error" message:@"We are unable to connect to our servers.\rPlease check your connection."];
        failureBlock(nil);
        return;
    }
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary * tempDic;
    if (parameters == nil) {
        tempDic = [NSMutableDictionary dictionary];
    }else{
        tempDic= [NSMutableDictionary dictionaryWithDictionary:parameters];
    }
    
//    [tempDic setObject:[User sharedInstance].strToken forKey:@"token"];
    parameters = tempDic;

    
//    NSLog(@"POST url : %@", url);
//    NSLog(@"POST param : %@", parameters);
//    NSLog(@"Debug____________POST_____________!pause");
    
    [self POST:url
          parameters:parameters
          success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject){
              NSData* data = (NSData*)responseObject;
              NSError* error = nil;
              NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
//              NSLog(@"POST success : %@", dict);
              
              completionBlock(dict);
              
        
          }failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error){
              NSLog(@"POST Error  %@", error);
              [SHAlertHelper showOkAlertWithTitle:@"Connection Error" andMessage:@"Error occurs while connecting to web-service. Please try again!" andOkBlock:nil];
              failureBlock(nil);
          }
    ];
    
  }




- (void)POST:(NSString *)url
  parameters:(NSMutableDictionary*)parameters
      vImage:(NSData*)vImage
   onSuccess:(SuccessBlock)completionBlock
   onFailure:(FailureBlock)failureBlock
{
    // Check out network connection
    NetworkStatus networkStatus = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@"There IS NO internet connection");
        [SHAlertHelper showOkAlertWithTitle:@"Error" message:@"We are unable to connect to our servers.\rPlease check your connection."];
        failureBlock(nil);
        return;
    }
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"POST url : %@", url);
    NSLog(@"POST param : %@", parameters);
    NSLog(@"Debug____________POST_____________!pause");
    
    [self POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (vImage != nil) {
            [formData appendPartWithFormData:vImage name:@"vImage"];
        }
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSData* data = (NSData*)responseObject;
        NSError* error = nil;
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        NSLog(@"POST success : %@", dict);
        
       completionBlock(dict);
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"POST Error  %@", error);
        [SHAlertHelper showOkAlertWithTitle:@"Connection Error" andMessage:@"Error occurs while connecting to web-service. Please try again!" andOkBlock:nil];
        failureBlock(nil);
    }];
}


- (void)GET:(NSString *)url
 parameters:(NSMutableDictionary*)parameters
  onSuccess:(SuccessBlock)completionBlock
  onFailure:(FailureBlock)failureBlock
{
    // Check out network connection
    NetworkStatus networkStatus = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@"There IS NO internet connection");
        [SHAlertHelper showOkAlertWithTitle:@"Error" message:@"We are unable to connect to our servers.\rPlease check your connection."];
        
        failureBlock(nil);
        return;
    }
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"GET url : %@", url);
    NSLog(@"GET param : %@", parameters);
    
    [self GET:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSData* data = (NSData*)responseObject;
        NSError* error = nil;
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        NSLog(@"GET success : %@", dict);
        completionBlock(dict);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"GET Error  %@", error);
        [SHAlertHelper showOkAlertWithTitle:@"Connection Error" andMessage:@"Error occurs while connecting to web-service. Please try again!" andOkBlock:nil];
        failureBlock(nil);
    }];
}

@end
