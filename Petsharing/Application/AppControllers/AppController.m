//
//  AppController.m
//  WebServiceSample
//
//  Created by LandtoSky on 6/14/16.
//  Copyright © 2016 LandtoSky. All rights reserved.
//

#import "AppController.h"


static AppController *_appController;

@implementation AppController

+ (AppController *)sharedInstance {
    static dispatch_once_t predicate;
    if (_appController == nil) {
        dispatch_once(&predicate, ^{
            _appController = [[AppController alloc] init];
        });
    }
    return _appController;
}

- (id)init {
    self = [super init];
    if (self) {
        
        // Utility Data
        _appOverlayerColor = RGBA(95, 191, 237, .4f);
        _appGradientTopColor = RGBA(10, 71, 217, 1.0f);
        _appGradientBottomColor = RGBA(45, 167, 220, 1.0f);
        _contactArray = [[NSArray alloc] init];
        _vAlert = [[DoAlertView alloc] init];
        _vAlert.nAnimationType = 2;  // there are 5 type of animation
        _vAlert.dRound = 7.0;
        _vAlert.bDestructive = NO;  // for destructive mode
        
        
        // ----------- Petsharing ---------
        _appMainColor = [UIColor colorWithHex:@"#009ee3" alpha:1.0f];
        _appRowBlueColor = [UIColor colorWithHex:@"#d8e9f0" alpha:1.0f];
        _appRowGreyColor = [UIColor colorWithHex:@"#f1f1f1" alpha:1.0f];
        
        
        
    
    }
    return self;
}

@end
