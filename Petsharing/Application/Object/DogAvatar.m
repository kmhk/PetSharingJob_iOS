//
//  DogAvatar.m
//  Petsharing
//
//  Created by user on 9/18/17.
//  Copyright © 2017 LandToSky. All rights reserved.
//

#import "DogAvatar.h"

@implementation DogAvatar

- (id)init {
	self = [super init];
	
	if (self) {
		self.userID = @"";
		self.imgAvatar = nil;
	}
	
	return self;
}


+ (DogAvatar *)avatar:(NSString *)userID image:(UIImage *)image {
	DogAvatar *avatar = [[DogAvatar alloc] init];
	avatar.userID = userID;
	avatar.imgAvatar = image;
	
	return avatar;
}

- (void)getImage:(FetchImageCallback)completion {
	if (self.imgAvatar) {
		completion(self.imgAvatar);
		return;
	}
	
	if (!self.userID.length) {
		return;
	}
}

@end
