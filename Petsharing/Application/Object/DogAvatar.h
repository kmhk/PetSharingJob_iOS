//
//  DogAvatar.h
//  Petsharing
//
//  Created by user on 9/18/17.
//  Copyright © 2017 LandToSky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DogObject.h"

@interface DogAvatar : NSObject

@property (assign) NSString *userID;

@property (assign) UIImage *imgAvatar;


+ (DogAvatar *)avatar:(NSString *)userID image:(UIImage *)image;

@end
