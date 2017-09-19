//
//  DogUser.h
//  Petsharing
//
//  Created by user on 9/18/17.
//  Copyright © 2017 LandToSky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DogAvatar.h"
#import "DogObject.h"


#define kUserFirstName			@"firstname"
#define kUserLastName			@"lastname"
#define kUserEmail				@"email"
#define kUserPhone				@"phone"
#define kUserAboutMe			@"aboutme"
#define kUserAboutDog			@"aboutdog"
#define kUserCategory			@"category"
#define kUserRole				@"role"


// DogUser class

@interface DogUser : NSObject

@property (assign) NSString *userID;

@property (assign) DogUserRole userRole;

@property (assign) DogAvatar *dogAvatar;
@property (assign) NSString *strFirstName;
@property (assign) NSString *strLastName;
@property (assign) NSString *strEmail;
@property (assign) NSString *strPhone;
@property (assign) NSString *strPassword;	

// for dog owner only
@property (assign) NSString *strAboutMe;
@property (assign) NSString *strAboutDog;

// for dog sitter only
@property (assign) NSString *strCategory;


+ (DogUser *)user:(NSString *)userID
			 role:(DogUserRole)role
		   avatar:(DogAvatar *)avatar
		firstName:(NSString *)first
		 lastName:(NSString *)last
			email:(NSString *)email
		 password:(NSString *)password
			phone:(NSString *)phone
		  aboutMe:(NSString *)aboutMe
		 aboutDog:(NSString *)aboutDog
		 category:(NSString *)category;


- (void)signUp:(CompletionCallback)completion;
- (void)save:(CompletionCallback)completion;

@end

