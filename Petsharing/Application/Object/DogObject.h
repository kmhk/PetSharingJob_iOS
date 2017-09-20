//
//  DogObject.h
//  Petsharing
//
//  Created by user on 9/19/17.
//  Copyright © 2017 LandToSky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FirebaseRef.h"


@class DogJob;


typedef void (^CompletionCallback)(NSError *error);
typedef void (^FetchJobCallback)(DogJob *job);


typedef NS_ENUM(NSInteger, DogUserRole) {
	DogUserRoleSitter = 0,
	DogUserRoleOwner = 1,
};

