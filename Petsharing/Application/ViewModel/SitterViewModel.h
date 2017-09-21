//
//  SitterViewModel.h
//  Petsharing
//
//  Created by user on 9/20/17.
//  Copyright © 2017 LandToSky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SitterViewModel : NSObject

@property (nonatomic) NSMutableArray *postedJobs;
@property (nonatomic) NSMutableArray *hiredJobs;
@property (nonatomic) NSMutableArray *finishedJobs;

@property (nonatomic) NSMutableArray *allJobs;


// public methods

- (void)loadAllJobs:(CompletionCallback)completion;
- (void)loadAllMyJobs:(CompletionCallback)completion;

- (void)applyJobTo:(DogJob *)job completion:(CompletionCallback)completion;

@end
