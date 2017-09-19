//
//  FirebaseRef.m
//  Petsharing
//
//  Created by user on 9/18/17.
//  Copyright © 2017 LandToSky. All rights reserved.
//

#import "FirebaseRef.h"


@implementation FirebaseRef

+ (FIRDatabaseReference *)allUsers {
	return [[[FIRDatabase database] reference] child:@"Users"];
}

+ (FIRStorageReference *)storage {
	return [[FIRStorage storage] referenceForURL:@"gs://petsharing-b6a1d.appspot.com"];
}

+ (FIRStorageReference *)storageForAvatar:(NSString *)userID {
	NSString *name = [NSString stringWithFormat:@"%@.jpg", userID];
	return [[[FirebaseRef storage] child:@"avatar"] child:name];
}


+ (void)signup:(NSString *)email password:(NSString *)password completion:(FIRAuthResultCallback)completion {
	[[FIRAuth auth] createUserWithEmail:email password:password completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
		completion(user, error);
	}];
}

@end
