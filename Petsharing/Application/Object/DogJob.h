//
//  DogJob.h
//  Petsharing
//
//  Created by user on 9/19/17.
//  Copyright © 2017 LandToSky. All rights reserved.
//

#import <Foundation/Foundation.h>


#define kJobOwner			@"owner"
#define kJobTitl			@"title"
#define kJobDescription		@"description"
#define kJobCategory		@"category"
#define kJobPerformed		@"performed"
#define kJobAddress			@"address"
#define kJobLatitude		@"lat"
#define kJobLongitude		@"lng"
#define kJobCreated			@"createdtime"
#define kJobStart			@"startime"
#define kJobEnd				@"endtime"
#define kJobPrice			@"price"


@interface DogJob : NSObject

@property (nonatomic) NSString *jobID;
@property (nonatomic) NSString *jobOwnerID;
@property (nonatomic) NSString *jobTitle;
@property (nonatomic) NSString *jobDescription;
@property (nonatomic) NSString *jobCategory;
@property (nonatomic) NSString *jobPerformed;
@property (nonatomic) float	jobPrice;

@property (nonatomic) NSDate *jobStartDate;
@property (nonatomic) NSDate *jobEndDate;
@property (nonatomic) NSDate *jobCreatedDate;

@property (nonatomic) NSString *jobAddress;
@property (nonatomic) CLLocationCoordinate2D jobLocation;


// MARK: - static methods

+ (void)fetchJob:(NSString *)jobID completion:(FetchJobCallback)completion;


// MARK: - public methods

- (id)initWithDict:(NSDictionary *)dict jobID:(NSString *)jobID;

- (id)initWithTitle:(NSString *)title
		description:(NSString *)description
		   category:(NSString *)category
		  performed:(NSString *)performed
			  price:(float)price
		  startDate:(NSDate *)startDate
			endDate:(NSDate *)endDate
		createdDate:(NSDate *)createdDate
			address:(NSString *)address
		   location:(CLLocationCoordinate2D)location;

- (void)save:(CompletionCallback)completion;

@end
