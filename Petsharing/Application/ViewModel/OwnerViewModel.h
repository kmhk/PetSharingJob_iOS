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

@end
