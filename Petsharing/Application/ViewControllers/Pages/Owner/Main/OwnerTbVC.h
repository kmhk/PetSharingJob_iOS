//
//  OwnerTbVC.h
//  Petsharing
//
//  Created by LandToSky on 8/23/17.
//  Copyright © 2017 LandToSky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OwnerViewModel.h"


#define ownerViewModel	(((OwnerTbVC *)self.tabBarController).viewModel)


@interface OwnerTbVC : UITabBarController

@property (nonatomic) OwnerViewModel *viewModel;

@end
