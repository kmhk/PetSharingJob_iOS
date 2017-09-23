//
//  OwnerViewModel.m
//  Petsharing
//
//  Created by user on 9/20/17.
//  Copyright © 2017 LandToSky. All rights reserved.
//

#import "OwnerViewModel.h"
#import "DogJob.h"
#import "DogUser.h"


@implementation OwnerViewModel

- (id)init {
	self = [super init];
	if (self) {
		self.postedJobs = nil;
		self.hiredJobs = nil;
		self.finishedJobs = nil;
	}
	
	return self;
}

- (void)postNewJob:(NSString *)title
	   description:(NSString *)description
		  category:(NSString *)category
		 performed:(NSString *)performed
			 price:(float)price
		   address:(NSString *)address
		  location:(CLLocationCoordinate2D)location
		 startDate:(NSDate *)startDate
		   endDate:(NSDate *)endDate
		completion:(CompletionCallback)completion {
	
	NSDate *createdDate = [NSDate date]; // it is getting UTC time
	
	DogJob *job = [[DogJob alloc] initWithTitle:title
									description:description
									   category:category
									  performed:performed
										  price:price
									  startDate:startDate
										endDate:endDate
									createdDate:createdDate
										address:address
									   location:location];
	[job save:^(NSError *error) {
		if (!error) {
			[self addPostedJob:job];
		}
		
		completion(error);
	}];
}

- (void)hireSitter:(DogUser *)sitter job:(DogJob *)job completion:(CompletionCallback)completion {
	[job hireSitter:sitter.userID completion:^(NSError *error) {
		if (error) {
			completion(error);
			return;
		}
		
		[[DogUser curUser] addHiredJobID:job.jobID completion:^(NSError *error) {
			if (error) {
				completion(error);
				return;
			}
			
			[sitter addHiredJobID:job.jobID completion:^(NSError *error) {
				if (error) {
					completion(error);
					return;
				}
				
				completion(nil);
			}];
		}];
	}];
}


- (void)loadAllChat:(CompletionCallback)completion {
	if (!self.allChats) {
		self.allChats = [[NSMutableArray alloc] init];
	}
	
	NSString *key = [NSString stringWithFormat:@"%@+", [DogUser curUser].userID];
	
	[[[FirebaseRef allChatHistory] queryEndingAtValue:key] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
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


- (void)loadAllChat:(NSString *)jobID completion:(CompletionCallback)completion {
	if (!self.allChats) {
		self.allChats = [[NSMutableArray alloc] init];
	}
	[self.allChats removeAllObjects];
	
	NSString *key = [NSString stringWithFormat:@"%@+", [DogUser curUser].userID];
	
	FIRDatabaseReference *ref;
	ref = [[FirebaseRef allChatHistory] child:jobID];
	
	[[ref queryEndingAtValue:key] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
		NSDictionary *dict = (NSDictionary *)snapshot.value;
		if ([dict isEqual:[NSNull null]]) {
			completion(nil);
			return;
		}
		
		for (NSString *chatNodeID in dict.allKeys) {
			[self.allChats addObject:@{@"jobID": jobID,
									   @"chatNodeID": chatNodeID}];
		}
		
		completion(nil);
	}];
}


// private methods

- (void)loadAllMyJobs:(CompletionCallback)completion {
	int jobCount = ([DogUser curUser].postedJobIDs == nil? 0: [DogUser curUser].postedJobIDs.count) +
					([DogUser curUser].hiredJobIDs == nil? 0: [DogUser curUser].hiredJobIDs.count) +
					([DogUser curUser].finishedJobIDs == nil? 0: [DogUser curUser].finishedJobIDs.count);
	__block int loadedJobIndex = 0;
	
	if (!jobCount) {
		completion(nil);
		return;
	}
	
	if (self.postedJobs) {
		[self.postedJobs removeAllObjects];
	}
	if (self.hiredJobs) {
		[self.hiredJobs removeAllObjects];
	}
	if (self.finishedJobs) {
		[self.finishedJobs removeAllObjects];
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
}

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

@end
