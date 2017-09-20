//
//  SitterTbVC.h
//  Petsharing
//
//  Created by LandToSky on 8/21/17.
//  Copyright © 2017 LandToSky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SitterViewModel.h"


#define sitterViewModel	(((SitterTbVC *)self.tabBarController).viewModel)


@interface SitterTbVC : UITabBarController

@property (nonatomic) SitterViewModel *viewModel;

@end
