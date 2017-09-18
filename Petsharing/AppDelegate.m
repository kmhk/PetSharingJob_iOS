//
//  AppDelegate.m
//  Petsharing
//
//  Created by LandToSky on 7/30/17.
//  Copyright © 2017 LandToSky. All rights reserved.
//

#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    //    [commonUtils initAddressBook]; // Get contact list from iphone
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    //    [self updateLocationManager];
    
    
    // Register Push Notification
    /*
     if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
     [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings
     settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
     [[UIApplication sharedApplication] registerForRemoteNotifications];
     } else {
     [[UIApplication sharedApplication] registerForRemoteNotifications];
     [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
     }
     
     if(launchOptions != nil && [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]) {
     NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
     appController.apnsMessage = [[userInfo objectForKey:@"aps"] objectForKey:@"info"];
     [commonUtils setUserDefault:@"apns_message_arrived" withFormat:@"1"];
     }
     */
    
    // First VC whether exists default user in app
   // UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
 //   UINavigationController *rootNav = [storyboard instantiateViewControllerWithIdentifier:@"MainNavigationController"];
    
    
  //  [self.window setRootViewController:rootNav];
   // [self.window makeKeyAndVisible];
    
    /*
     if ([commonUtils getUserDefault:@"current_user_user_id"] != nil)
     { //In case login is built
     
     appController.currentUser = [commonUtils getUserDefaultDicByKey:@"current_user"];
     [rootNav pushViewController:[storyboard instantiateViewControllerWithIdentifier:@"SidePanelVC"] animated:NO];
     
     } else {    // In case signup
     [rootNav pushViewController:[storyboard instantiateViewControllerWithIdentifier:@"FirstVC"] animated:NO];
     }
     */
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - FB Sign up
#ifdef __IPHONE_9_0
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary *)options
{
    [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey] annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];   return YES;
}
#else
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    return YES;
}
#endif


#pragma mark - Remote Notification
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken {
    
    NSString* newToken = [[[NSString stringWithFormat:@"%@",deviceToken]
                           stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [commonUtils setUserDefault:@"user_apns_id" withFormat:newToken];
    NSLog(@"My saved token is: %@", [commonUtils getUserDefault:@"user_apns_id"]);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
    //    NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    appController.apnsMessage = [[NSMutableDictionary alloc] init];
    appController.apnsMessage = [[userInfo objectForKey:@"aps"] objectForKey:@"info"];
    NSLog(@"APNS Info Fetched : %@", userInfo);
    NSLog(@"My Received Message : %@", appController.apnsMessage);
    [commonUtils setUserDefault:@"apns_message_arrived" withFormat:@"1"];
    [application setApplicationIconBadgeNumber:[[[userInfo objectForKey:@"aps"] objectForKey:@"badge"] intValue]];
}




#pragma mark - CLLocationManagerDelegate
- (void)updateLocationManager {
    //    if([commonUtils getUserDefault:@"flag_location_query_enabled"] != nil && [[commonUtils getUserDefault:@"flag_location_query_enabled"] isEqualToString:@"1"]) {
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    [_locationManager setDistanceFilter:804.17f]; // Distance Filter as 0.5 mile (1 mile = 1609.34m)
    //locationManager.distanceFilter=kCLDistanceFilterNone;
    
    
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    //    if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
    //        [_locationManager requestWhenInUseAuthorization];
    //    }
    
    if(IS_OS_8_OR_LATER) {
        [_locationManager requestAlwaysAuthorization];
    }
    //        [_locationManager startMonitoringSignificantLocationChanges];
    //        [_locationManager startUpdatingLocation];
    //    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    //    NSLog(@"didFailWithError: %@", error);
    [commonUtils showAlert:@"Error" withMessage:@"Failed to Get Your Location"];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"didUpdateToLocation: %@", [locations lastObject]);
    CLLocation *currentLocation = [locations lastObject];
    if (currentLocation != nil) {
        BOOL locationChanged = NO;
        if(![commonUtils getUserDefault:@"currentLatitude"] || ![commonUtils getUserDefault:@"currentLongitude"]) {
            locationChanged = YES;
        } else if(![[commonUtils getUserDefault:@"currentLatitude"] isEqualToString:[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude]] || ![[commonUtils getUserDefault:@"currentLongitude"] isEqualToString:[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude]]) {
            locationChanged = YES;
        }
        if(locationChanged) {
            [commonUtils setUserDefault:@"currentLatitude" withFormat:[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude]];
            [commonUtils setUserDefault:@"currentLongitude" withFormat:[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude]];
            //            [commonUtils setUserDefault:@"barksUpdate" withFormat:@"1"];
        }
    }
    [_locationManager stopUpdatingLocation];
    //    [self updateUserLocation];
}

- (void)updateUserLocation {  //for update user's coordinate automatically
    NSString *msg = [NSString stringWithFormat:@"%@:%@", [commonUtils getUserDefault:@"currentLatitude"], [commonUtils getUserDefault:@"currentLongitude"]];
    [commonUtils showAlert:@"Location Updated" withMessage:msg];
}



#pragma mark - Log Out
-(void) logOut
{
    // Remove data from singleton (where all my app data is stored)
    if([[commonUtils getUserDefault:@"logged_out"] isEqualToString:@"1"]) {
        [commonUtils removeUserDefault:@"logged_out"];
        
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logOut];
        [FBSDKAccessToken setCurrentAccessToken:nil];
        
    }
    
    // Show login screen
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UINavigationController *nav = [storyboard instantiateViewControllerWithIdentifier:@"MainNavigationController"];
    
    [self.window setRootViewController:nav];
    [self.window makeKeyAndVisible];
    
    
}


#pragma mark - AppDelegate shareAppDelegate
+(AppDelegate *)sharedAppDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

@end
