//
//  AppController.h
//  WebServiceSample
//
//  Created by LandtoSky on 6/14/16.
//  Copyright © 2016 LandtoSky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppController : NSObject

+ (AppController *)sharedInstance;
// Utility Variables
@property (nonatomic, strong) DoAlertView *vAlert;
@property (nonatomic, strong) UIColor *appMainColor;
@property (nonatomic, strong) UIColor *appOverlayerColor;
@property (nonatomic, strong) UIColor *appGradientTopColor, *appGradientBottomColor;

// Phone Contact Array
@property (nonatomic, strong) NSArray *contactArray;
@property (nonatomic, strong) NSMutableDictionary *currentUser, *apnsMessage;


// Petsharing
@property(nonatomic,strong) NSString* currentUserType,*signupMode;
@property (nonatomic, strong) UIColor *appRowBlueColor, *appRowGreyColor;




@end
