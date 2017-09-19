//
//  FirebaseRef.h
//  Petsharing
//
//  Created by user on 9/18/17.
//  Copyright © 2017 LandToSky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Firebase/Firebase.h>



@interface FirebaseRef : NSObject

+ (FIRDatabaseReference *)allUsers;
+ (FIRStorageReference *)storage;
+ (FIRStorageReference *)storageForAvatar:(NSString *)userID;

+ (void)signup:(NSString *)email password:(NSString *)password completion:(FIRAuthResultCallback)completion;

@end
