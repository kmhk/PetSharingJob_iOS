//
//  AppDelegate.h
//  Petsharing
//
//  Created by LandToSky on 7/30/17.
//  Copyright © 2017 LandToSky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic) CLLocation *currentLocation;

- (void)updateLocationManager;
-(void) logOut;
+(AppDelegate *)sharedAppDelegate;


@end


