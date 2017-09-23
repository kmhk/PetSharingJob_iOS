//
//  SitterViewModel.m
//  Petsharing
//
//  Created by user on 9/20/17.
//  Copyright © 2017 LandToSky. All rights reserved.
//

#import "SitterViewModel.h"
#import "DogJob.h"
#import "DogUser.h"


@implementation SitterViewModel

- (id)init {
	self = [super init];
	if (self) {
		self.postedJobs = nil;
		self.hiredJobs = nil;
		self.finishedJobs = nil;
		self.allJobs = nil;
	}
	
	return self;
}


// MARK: - public methods

- (void)applyJobTo:(DogJob *)job completion:(CompletionCallback)completion {
	[job addApplyUser:[DogUser curUser].userID completion:^(NSError *error) {
		completion(error);
	}];
};


- (void)loadAllJobs:(CompletionCallback)completion {
	[[FirebaseRef allJobs] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
		NSDictionary *dict = (NSDictionary *)snapshot.value;
		if (!dict) {
			completion(nil);
			return;
		}
		
		if (self.allJobs) {
			[self.allJobs removeAllObjects];
		}
		
		NSArray *arrayKeys = [dict allKeys];
		for (NSString *str in arrayKeys) {
			NSDictionary *dictJob = (NSDictionary *)dict[str];
			DogJob *job = [[DogJob alloc] initWithDict:dictJob jobID:str];
			if (!job.hiredUsers || job.hiredUsers.count <= 0) {
				[self addJobToList:job];
			}
		}
		
		completion(nil);
	}];
}

- (void)loadAllMyJobs:(CompletionCallback)completion {
	[[DogUser curUser] watchingUser:^(NSError *error) {
		if (error) {
			completion(error);
			return;
		}
	
		int jobCount = ([DogUser curUser].postedJobIDs == nil? 0: [DogUser curUser].postedJobIDs.count) +
		([DogUser curUser].hiredJobIDs == nil? 0: [DogUser curUser].hiredJobIDs.count) +
		([DogUser curUser].finishedJobIDs == nil? 0: [DogUser curUser].finishedJobIDs.count);
		__block int loadedJobIndex = 0;
		
		if (self.postedJobs) {
			[self.postedJobs removeAllObjects];
		}
		if (self.hiredJobs) {
			[self.hiredJobs removeAllObjects];
		}
		if (self.finishedJobs) {
			[self.finishedJobs removeAllObjects];
		}
		
		if (!jobCount) {
			completion(nil);
			return;
		}
		
		if ([DogUser curUser].postedJobIDs) {
			for (NSString *jobID in [DogUser curUser].postedJobIDs) {
				[DogJob fetchJob:jobID completion:^(DogJob *job) {
					loadedJobIndex = loadedJobIndex + 1;
					
					if (!job) {
						NSDictionary *dictError = @{NSLocalizedDescriptionKey: @"Job db is broken."};
						completion([NSError errorWithDomain:@"No Database" code:200 userInfo:dictError]);
						return;
					}
					
					[self addPostedJob:job];
					
					if (loadedJobIndex >= jobCount) {
						completion(nil);
					}
				}];
			}
		}
		
		if ([DogUser curUser].hiredJobIDs) {
			for (NSString *jobID in [DogUser curUser].hiredJobIDs) {
				[DogJob fetchJob:jobID completion:^(DogJob *job) {
					loadedJobIndex = loadedJobIndex + 1;
					
					if (!job) {
						NSDictionary *dictError = @{NSLocalizedDescriptionKey: @"Job db is broken."};
						completion([NSError errorWithDomain:@"No Database" code:200 userInfo:dictError]);
						return;
					}
					
					[self addHiredJob:job];
					
					if (loadedJobIndex >= jobCount) {
						completion(nil);
					}
				}];
			}
		}
		
		if ([DogUser curUser].finishedJobIDs) {
			for (NSString *jobID in [DogUser curUser].finishedJobIDs) {
				[DogJob fetchJob:jobID completion:^(DogJob *job) {
					loadedJobIndex = loadedJobIndex + 1;
					
					if (!job) {
						NSDictionary *dictError = @{NSLocalizedDescriptionKey: @"Job db is broken."};
						completion([NSError errorWithDomain:@"No Database" code:200 userInfo:dictError]);
						return;
					}
					
					[self addFinishedJobs:job];
					
					if (loadedJobIndex >= jobCount) {
						completion(nil);
					}
				}];
			}
		}
	}];
}


- (void)loadAllChat:(CompletionCallback)completion {
	if (!self.allChats) {
		self.allChats = [[NSMutableArray alloc] init];
	}
	
	[[[FirebaseRef allChatHistory] queryEndingAtValue:[DogUser curUser].userID] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
		NSDictionary *dict = (NSDictionary *)snapshot.value;
		if ([dict isEqual:[NSNull null]]) {
			completion(nil);
			return;
		}
		
		[self.allChats removeAllObjects];
		
		for (NSString *jobID in dict.allKeys) {
			NSDictionary *chatNode = dict[jobID];
			NSString *chatNodeID = chatNode.allKeys.firstObject;
			[self.allChats addObject:@{@"jobID": jobID,
									   @"chatNodeID": chatNodeID}];
		}
		
		completion(nil);
	}];
}


// MARK: - private methods

- (void)addPostedJob:(DogJob *)job {
	if (!self.postedJobs) {
		self.postedJobs = [[NSMutableArray alloc] init];
	}
	
	[self.postedJobs addObject:job];
}

- (void)addHiredJob:(DogJob *)job {
	if (!self.hiredJobs) {
		self.hiredJobs = [[NSMutableArray alloc] init];
	}
	
	[self.hiredJobs addObject:job];
}

- (void)addFinishedJobs:(DogJob *)job {
	if (!self.finishedJobs) {
		self.finishedJobs = [[NSMutableArray alloc] init];
	}
	
	[self.finishedJobs addObject:job];
}

- (void)addJobToList:(DogJob *)job {
	if (!self.allJobs) {
		self.allJobs = [[NSMutableArray alloc] init];
	}
	
	[self.allJobs addObject:job];
}


@end
