//
//  DogObject.h
//  Petsharing
//
//  Created by user on 9/19/17.
//  Copyright © 2017 LandToSky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FirebaseRef.h"


typedef void (^CompletionCallback)(NSError *error);
typedef void (^FetchImageCallback)(UIImage *image);


typedef NS_ENUM(NSInteger, DogUserRole) {
	DogUserRoleSitter = 0,
	DogUserRoleOwner = 1,
};

