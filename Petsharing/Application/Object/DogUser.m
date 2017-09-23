//
//  DogUser.m
//  Petsharing
//
//  Created by user on 9/18/17.
//  Copyright © 2017 LandToSky. All rights reserved.
//

#import "DogUser.h"


DogUser *gSharedUser = nil;

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
		self.fRate = 0.0;
	}
	
	return self;
}


- (void)setWithDict:(NSDictionary *)dict userID:(NSString *)userID {
	self.userID = userID;
	self.userRole = [dict[kUserRole] integerValue];
	self.strFirstName = dict[kUserFirstName];
	self.strLastName = dict[kUserLastName];
	self.strEmail = dict[kUserEmail];
	self.strPhone = dict[kUserPhone];
	self.strAboutMe = dict[kUserAboutMe];
	self.strAboutDog = dict[kUserAboutDog];
	self.strCategory = dict[kUserCategory];
	self.fRate = (dict[kUserRate] != nil)? [dict[kUserRate] floatValue]: 0.0;
	self.postedJobIDs = (dict[kPostedJob] != nil)? [NSMutableArray arrayWithArray:dict[kPostedJob]]: [[NSMutableArray alloc] init];
	self.hiredJobIDs = (dict[kHiredJob] != nil)? [NSMutableArray arrayWithArray:dict[kHiredJob]]: [[NSMutableArray alloc] init];
	self.finishedJobIDs = (dict[kFinishedJob] != nil)? [NSMutableArray arrayWithArray:dict[kFinishedJob]]: [[NSMutableArray alloc] init];
};


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
		category:(NSString *)category {
	
	self.userID = userID;
	self.userRole = role;
	self.dogAvatar = avatar;
	self.strFirstName = first;
	self.strLastName = last;
	self.strEmail = email;
	self.strPhone = phone;
	self.strPassword = password;
	self.strAboutMe = aboutMe;
	self.strAboutDog = aboutDog;
	self.strCategory = category;
}

- (void)loadUser:(CompletionCallback)completion {
	[[[FirebaseRef allUsers] child:self.userID] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
		NSDictionary *dict = (NSDictionary *)snapshot.value;
		if (!dict) {
			completion(nil);
			return;
		}
		
		[self setWithDict:dict userID:self.userID];
		completion(nil);
	}];
}

- (void)watchingUser:(CompletionCallback)completion {
	[[[FirebaseRef allUsers] child:self.userID] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
		NSDictionary *dict = (NSDictionary *)snapshot.value;
		if (!dict) {
			completion(nil);
			return;
		}
		
		[self setWithDict:dict userID:self.userID];
		completion(nil);
	}];
}

- (void)removeJob:(NSString *)jobID completion:(CompletionCallback)completion {
	if (self.postedJobIDs) {
		[self.postedJobIDs removeObject:jobID];
		
		NSDictionary *dict = @{kPostedJob: self.postedJobIDs};
		[[[FirebaseRef allUsers] child:self.userID] updateChildValues:dict withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
			if (error) {
				completion(error);
				return;
			}
			
			[[FirebaseRef allJobs] updateChildValues:@{jobID: @[]} withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
				completion(error);
			}];
		}];
		
	} else {
		completion(nil);
	}
}


// MARK: - creation methods

+ (void)fetchUser:(NSString *)userID completion:(FetchUserCallback)completion {
	[[[FirebaseRef allUsers] child:userID] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
		NSDictionary *dict = (NSDictionary *)snapshot.value;
		if ([dict isEqual:[NSNull null]]) {
			completion(nil);
			return;
		}
		
		DogUser *user = [[DogUser alloc] init];
		[user setWithDict:dict userID:userID];
		
		completion(user);
	}];
}


+ (DogUser *)curUser {
	if (gSharedUser == nil) {
		gSharedUser = [[DogUser alloc] init];
	}
	
	return gSharedUser;
}


+ (NSArray *)dogSitterCategories {
	return @[@"Dog Walking",@"Hour",@"All Day",@"Week",@"Sharing",@"Older Dog", @"Other"];
}


// MARK: - firebase interacting methods

- (void)signUp:(CompletionCallback)completion {
	[[FIRAuth auth] createUserWithEmail:self.strEmail password:self.strPassword completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
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


- (void)login:(NSString *)email password:(NSString *)password completion:(CompletionCallback)completion {
	[[FIRAuth auth] signInWithEmail:email password:password completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
		if (error) {
			completion(error);
			return;
		}
		
		self.userID = user.uid;
		[[[FirebaseRef allUsers] child:self.userID] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
			NSDictionary *dict = (NSDictionary *)snapshot.value;
			if (!dict) {
				NSDictionary *dictError = @{NSLocalizedDescriptionKey: @"No existing dog user in db."};
				
				completion([NSError errorWithDomain:@"No Database" code:200 userInfo:dictError]);
				return;
			}
			
			[self setWithDict:dict userID:user.uid];
			
			completion(nil);
		}];
	}];
}


- (void)logout {
	[[FIRAuth auth] signOut:nil];
}


- (void)save:(CompletionCallback)completion {
	// store avatar image first
	NSData *imgData = UIImageJPEGRepresentation(self.dogAvatar, 1.0);
	
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
						   kUserCategory: self.strCategory,
						   kUserRate: @(self.fRate),
						   kPostedJob: (self.postedJobIDs == nil? @[]: self.postedJobIDs),
						   kHiredJob: (self.hiredJobIDs == nil? @[]: self.hiredJobIDs),
						   kFinishedJob: (self.finishedJobIDs == nil? @[]: self.finishedJobIDs)};
	NSDictionary *dict = @{self.userID: user};
	
//	NSLog(@"saving user data to db: %@", user);
	[[FirebaseRef allUsers] updateChildValues:dict withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
		completion(error);
	}];
}


- (void)addPostedJobID:(NSString *)jobID completion:(CompletionCallback)completion {
	if (!self.postedJobIDs) {
		self.postedJobIDs = [[NSMutableArray alloc] init];
	}
	
	[self.postedJobIDs addObject:jobID];
	
	NSDictionary *dict = @{kPostedJob: self.postedJobIDs};
	
	[[[FirebaseRef allUsers] child:self.userID] updateChildValues:dict withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
		completion(error);
	}];
}


- (void)addHiredJobID:(NSString *)jobID completion:(CompletionCallback)completion {
	if (!self.postedJobIDs) {
		NSDictionary *dictError = @{NSLocalizedDescriptionKey: @"broken db."};
		
		completion([NSError errorWithDomain:@"No Database" code:200 userInfo:dictError]);
		return;
	}
	
	[self.postedJobIDs removeObject:jobID];
	
	if (!self.hiredJobIDs) {
		self.hiredJobIDs = [[NSMutableArray alloc] init];
	}
	
	if ([self.hiredJobIDs indexOfObject:jobID] == NSNotFound) {
		[self.hiredJobIDs addObject:jobID];
	}
	
	NSDictionary *dict = @{kPostedJob: self.postedJobIDs,
						   kHiredJob: self.hiredJobIDs};
	[[[FirebaseRef allUsers] child:self.userID] updateChildValues:dict withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
		completion(error);
	}];
}

@end
