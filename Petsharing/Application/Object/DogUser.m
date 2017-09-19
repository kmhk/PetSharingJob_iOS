//
//  DogUser.m
//  Petsharing
//
//  Created by user on 9/18/17.
//  Copyright © 2017 LandToSky. All rights reserved.
//

#import "DogUser.h"


DogUser *gCurUser;

@implementation DogUser

- (id)init {
	self = [super init];
	
	if (self) {
		self.userID = @"";
		
		self.userRole = DogUserRoleOwner;
		
		self.dogAvatar = nil;
		self.strFirstName = @"";
		self.strLastName = @"";
		self.strEmail = @"";
		self.strPhone = @"";
		self.strPassword = @"";
		
		self.strAboutMe = @"";
		self.strAboutDog = @"";
		
		self.strCategory = @"";
	}
	
	return self;
}


// MARK: - creation methods

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
		 category:(NSString *)category {
	
	DogUser *user = [[DogUser alloc] init];
	user.userID = userID;
	user.userRole = role;
	user.dogAvatar = avatar;
	user.strFirstName = first;
	user.strLastName = last;
	user.strEmail = email;
	user.strPhone = phone;
	user.strPassword = password;
	user.strAboutMe = aboutMe;
	user.strAboutDog = aboutDog;
	user.strCategory = category;
	
	return user;
}


// MARK: - firebase interacting methods

- (void)signUp:(CompletionCallback)completion {
	[FirebaseRef signup:self.strEmail password:self.strPassword completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
		if (error) {
			completion(error);
			return;
		}
		
		self.userID = user.uid;
		[self save:^(NSError *error) {
			completion(error);
		}];
	}];
}


- (void)save:(CompletionCallback)completion {
	// store avatar image first
	NSData *imgData = UIImageJPEGRepresentation(self.dogAvatar.imgAvatar, 1.0);
	
	FIRStorageMetadata *meta = [[FIRStorageMetadata alloc] init];
	meta.contentType = @"image/jpg";
	
	[[FirebaseRef storageForAvatar:self.userID] putData:imgData metadata:meta];
	
	// save user info
	NSDictionary *user = @{kUserRole: @(self.userRole),
						   kUserFirstName: self.strFirstName,
						   kUserLastName: self.strLastName,
						   kUserEmail: self.strEmail,
						   kUserPhone: self.strPhone,
						   kUserAboutMe: self.strAboutMe,
						   kUserAboutDog: self.strAboutDog,
						   kUserCategory: self.strCategory};
	NSDictionary *dict = @{self.userID: user};
	
	[[FirebaseRef allUsers] updateChildValues:dict withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
		completion(error);
	}];
}

@end
