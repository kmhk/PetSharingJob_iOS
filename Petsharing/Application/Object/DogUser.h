//
//  DogUser.h
//  Petsharing
//
//  Created by user on 9/18/17.
//  Copyright © 2017 LandToSky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DogObject.h"


#define kUserFirstName			@"firstname"
#define kUserLastName			@"lastname"
#define kUserEmail				@"email"
#define kUserPhone				@"phone"
#define kUserAboutMe			@"aboutme"
#define kUserAboutDog			@"aboutdog"
#define kUserCategory			@"category"
#define kUserRole				@"role"
#define kUserRate				@"rate"
#define kPostedJob				@"postedjob"
#define kHiredJob				@"hiredjob"
#define kFinishedJob			@"finishedjob"


// DogUser class

@interface DogUser : NSObject

@property (nonatomic) NSString *userID;

@property (nonatomic) DogUserRole userRole;

@property (nonatomic) UIImage *dogAvatar;
@property (nonatomic) NSString *strFirstName;
@property (nonatomic) NSString *strLastName;
@property (nonatomic) NSString *strEmail;
@property (nonatomic) NSString *strPhone;
@property (nonatomic) NSString *strPassword;

// for dog owner only
@property (nonatomic) NSString *strAboutMe;
@property (nonatomic) NSString *strAboutDog;
@property (nonatomic) NSMutableArray *postedJobIDs;
@property (nonatomic) NSMutableArray *hiredJobIDs;
@property (nonatomic) NSMutableArray *finishedJobIDs;

// for dog sitter only
@property (nonatomic) NSString *strCategory;
@property (nonatomic) float fRate;


// MARK: - public methods

+ (NSArray *)dogSitterCategories;

+ (DogUser *)curUser;
+ (void)fetchUser:(NSString *)userID completion:(FetchUserCallback)completion;

- (void)setWith:(NSString *)userID
			role:(DogUserRole)role
		  avatar:(UIImage *)avatar
	   firstName:(NSString *)first
		lastName:(NSString *)last
		   email:(NSString *)email
		password:(NSString *)password
		   phone:(NSString *)phone
		 aboutMe:(NSString *)aboutMe
		aboutDog:(NSString *)aboutDog
		category:(NSString *)category;

- (void)loadUser:(CompletionCallback)completion;
- (void)watchingUser:(CompletionCallback)completion;

- (void)signUp:(CompletionCallback)completion;
- (void)login:(NSString *)email password:(NSString *)password completion:(CompletionCallback)completion;
- (void)logout;

- (void)save:(CompletionCallback)completion;

// for job
- (void)addPostedJobID:(NSString *)jobID completion:(CompletionCallback)completion;
- (void)addHiredJobID:(NSString *)jobID completion:(CompletionCallback)completion;
- (void)addCompletedJob:(NSString *)jobID completion:(CompletionCallback)completion;

- (void)removeJob:(NSString *)jobID completion:(CompletionCallback)completion;

@end
