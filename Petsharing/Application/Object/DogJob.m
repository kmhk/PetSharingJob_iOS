//
//  DogJob.m
//  Petsharing
//
//  Created by user on 9/19/17.
//  Copyright © 2017 LandToSky. All rights reserved.
//

#import "DogJob.h"
#import "DogUser.h"

@implementation DogJob

+ (void)fetchJob:(NSString *)jobID completion:(FetchJobCallback)completion {
	[[[FirebaseRef allJobs] child:jobID] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
		NSDictionary *dict = (NSDictionary *)snapshot.value;
		if ([dict isEqual:[NSNull null]]) {
			completion(nil);
			return;
		}
		
		DogJob *job = [[DogJob alloc] initWithDict:dict jobID:jobID];
		
		completion(job);
	}];
}


- (id)initWithDict:(NSDictionary *)dict jobID:(NSString *)jobID {
	self = [super init];
	if (self && dict) {
		self.jobID = jobID;
		self.jobOwnerID = dict[kJobOwner];
		self.jobTitle = dict[kJobTitl];
		self.jobDescription = dict[kJobDescription];
		self.jobCategory = dict[kJobCategory];
		self.jobPerformed = dict[kJobPerformed];
		self.jobPrice = [dict[kJobPrice] floatValue];
		self.jobAddress = dict[kJobAddress];
		self.jobLocation = CLLocationCoordinate2DMake([dict[kJobLatitude] doubleValue], [dict[kJobLongitude] doubleValue]);
		self.jobStartDate = [NSDate dateWithTimeIntervalSince1970:[dict[kJobStart] doubleValue]];
		self.jobEndDate = [NSDate dateWithTimeIntervalSince1970:[dict[kJobEnd] doubleValue]];
		self.jobCreatedDate = [NSDate dateWithTimeIntervalSince1970:[dict[kJobCreated] doubleValue]];
		self.appliedUsers = (dict[kJobApplyUsers] != nil)? [NSMutableArray arrayWithArray:dict[kJobApplyUsers]]: [[NSMutableArray alloc] init];
		self.hiredUsers = (dict[kHiredJob] != nil)? [NSMutableArray arrayWithArray:dict[kHiredJob]]: [[NSMutableArray alloc] init];
		self.isCompleted = (dict[kJobCompleted] != nil)? [dict[kJobCompleted] boolValue]: NO;
		self.jobFinishedDate = (dict[kJobFinished] != nil)? [NSDate dateWithTimeIntervalSince1970:[dict[kJobFinished] doubleValue]]: [NSDate dateWithTimeIntervalSince1970:0];
	}
	
	return self;
}

- (id)initWithTitle:(NSString *)title
		description:(NSString *)description
		   category:(NSString *)category
		  performed:(NSString *)performed
			  price:(float)price
		  startDate:(NSDate *)startDate
			endDate:(NSDate *)endDate
		createdDate:(NSDate *)createdDate
			address:(NSString *)address
		   location:(CLLocationCoordinate2D)location {
	
	self = [super init];
	if (self) {
		self.jobOwnerID = [DogUser curUser].userID;
		self.jobTitle = title;
		self.jobDescription = description;
		self.jobCategory = category;
		self.jobPerformed = performed;
		self.jobPrice = price;
		self.jobStartDate = startDate;
		self.jobEndDate = endDate;
		self.jobCreatedDate = createdDate;
		self.jobAddress = address;
		self.jobLocation = location;
		
		NSDateFormatter *format = [[NSDateFormatter alloc] init];
		[format setDateFormat:@"yyyyMMddHHmmss"];
		
		self.jobID = [NSString stringWithFormat:@"%@%@", [DogUser curUser].userID, [format stringFromDate:createdDate]];
	}
	
	return self;
}


- (void)save:(CompletionCallback)completion {
	NSTimeInterval created = [self.jobCreatedDate timeIntervalSince1970];
	NSTimeInterval start = [self.jobStartDate timeIntervalSince1970];
	NSTimeInterval end = [self.jobEndDate timeIntervalSince1970];
	NSTimeInterval finished = [self.jobFinishedDate timeIntervalSince1970];
	
	NSDictionary *job = @{kJobOwner: self.jobOwnerID,
						  kJobTitl: self.jobTitle,
						  kJobDescription: self.jobDescription,
						  kJobCategory: self.jobCategory,
						  kJobPerformed: self.jobPerformed,
						  kJobAddress: self.jobAddress,
						  kJobLatitude: @(self.jobLocation.latitude),
						  kJobLongitude: @(self.jobLocation.longitude),
						  kJobCreated: @(created),
						  kJobStart: @(start),
						  kJobEnd: @(end),
						  kJobPrice: @(self.jobPrice),
						  kJobApplyUsers: (self.appliedUsers == nil? @[]: self.appliedUsers),
						  kJobHiredUsers: (self.hiredUsers == nil? @[]: self.hiredUsers),
						  kJobCompleted: @(self.isCompleted),
						  kJobFinished: @(finished)
						  };
	NSDictionary *dict = @{self.jobID: job};
	
	[[FirebaseRef allJobs] updateChildValues:dict withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
		if (error) {
			completion(error);
			return;
		}
		
		[[DogUser curUser] addPostedJobID:self.jobID completion:^(NSError *error) {
			completion(error);
		}];
	}];
}


- (void)addApplyUser:(NSString *)userID completion:(CompletionCallback)completion {
	if (!self.appliedUsers) {
		self.appliedUsers = [[NSMutableArray alloc] init];
	}
	
	if ([self.appliedUsers indexOfObject:userID] == NSNotFound) {
		[self.appliedUsers addObject:userID];
	}
	
	NSDictionary *dict = @{kJobApplyUsers: self.appliedUsers};
	
	[[[FirebaseRef allJobs] child:self.jobID] updateChildValues:dict withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
		if (error) {
			[self.appliedUsers removeObject:userID];
			completion(error);
			return;
		}
		
		completion(nil);
	}];
}


- (void)hireSitter:(NSString *)sitterID completion:(CompletionCallback)completion {
	if (!self.hiredUsers) {
		self.hiredUsers = [[NSMutableArray alloc] init];
	}
	
	if ([self.hiredUsers indexOfObject:sitterID] == NSNotFound) {
		[self.hiredUsers addObject:sitterID];
	}
	
	NSDictionary *dict = @{kHiredJob: self.hiredUsers};
	[[[FirebaseRef allJobs] child:self.jobID] updateChildValues:dict withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
		completion(error);
	}];
}


- (void)finishJob:(CompletionCallback)completion
{
	self.jobFinishedDate = [NSDate date];
	NSTimeInterval finished = [self.jobFinishedDate timeIntervalSince1970];
	
	NSDictionary *dict = @{kJobCompleted: @(YES),
						   kJobFinished: @(finished)};
	[[[FirebaseRef allJobs] child:self.jobID] updateChildValues:dict withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
		completion(error);
	}];
}

@end
