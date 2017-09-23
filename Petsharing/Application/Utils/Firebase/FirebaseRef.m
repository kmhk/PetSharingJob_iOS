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

+ (FIRDatabaseReference *)allJobs {
	return [[[FIRDatabase database] reference] child:@"Jobs"];
}

+ (FIRDatabaseReference *)allChats {
	return [[[FIRDatabase database] reference] child:@"ChatChannel"];
}

+ (FIRDatabaseReference *)allChatHistory {
	return [[[FIRDatabase database] reference] child:@"ChatHistory"];
}

+ (FIRStorageReference *)storage {
	return [[FIRStorage storage] referenceForURL:@"gs://petsharing-b6a1d.appspot.com"];
}

+ (FIRStorageReference *)storageForChat {
	return [[FirebaseRef storage] child:@"Chat"];
}

+ (FIRStorageReference *)storageForAvatar:(NSString *)userID {
	NSString *name = [NSString stringWithFormat:@"%@.jpg", userID];
	return [[[FirebaseRef storage] child:@"avatar"] child:name];
}

@end
