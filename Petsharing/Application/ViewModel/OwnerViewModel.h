//
//  OwnerViewModel.h
//  Petsharing
//
//  Created by user on 9/20/17.
//  Copyright © 2017 LandToSky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OwnerViewModel : NSObject

@property (nonatomic) NSMutableArray *postedJobs;
@property (nonatomic) NSMutableArray *hiredJobs;
@property (nonatomic) NSMutableArray *finishedJobs;

@property (nonatomic) NSMutableArray *allChats;


- (void)postNewJob:(NSString *)title
	   description:(NSString *)description
		  category:(NSString *)category
		 performed:(NSString *)performed
			 price:(float)price
		   address:(NSString *)address
		  location:(CLLocationCoordinate2D)location
		 startDate:(NSDate *)startDate
		   endDate:(NSDate *)endDate
		completion:(CompletionCallback)completion;

- (void)loadAllMyJobs:(CompletionCallback)completion;
- (void)hireSitter:(DogUser *)sitter job:(DogJob *)job completion:(CompletionCallback)completion;

- (void)loadAllChat:(CompletionCallback)completion;
- (void)loadAllChat:(NSString *)jobID completion:(CompletionCallback)completion;

@end
