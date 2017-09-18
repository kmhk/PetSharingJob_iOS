//
//  tabBarVC.m
//  Hungri
//
//  Created by LandtoSky on 7/30/16.
//  Copyright © 2016 mobiledev87. All rights reserved.
//

#import "TabBarVC.h"

@interface TabBarVC ()

@end

@implementation TabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    [self initData];
}

- (void) initUI {
    // tabbar item tint color
    [self.tabBar setTintColor:[UIColor blackColor]];
    
    // remove tabbar upper line
    [self.tabBar setValue:@(YES) forKeyPath:@"_hidesShadow"];
    
    //set tabbar backgournd color as clear
    [[UITabBar appearance] setBarTintColor:[UIColor clearColor]];
    [[UITabBar appearance] setBackgroundImage:[UIImage new]];
    
}

- (void) initData {
    
}

@end
