//
//  JobListTVCell.h
//  Petsharing
//
//  Created by LandToSky on 8/21/17.
//  Copyright © 2017 LandToSky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JobListTVCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *jobOwnerPhotoIv;
@property (strong, nonatomic) IBOutlet UILabel *jobTitleLbl;
@property (strong, nonatomic) IBOutlet UILabel *jobStatusLbl;

@property (strong, nonatomic) IBOutlet UIImageView *markLocation;

- (void)setJob:(DogJob *)job;
- (void)setJob:(DogJob *)job arrangedType:(NSInteger)type;
- (void)setJobID:(NSString *)jobID;

@end
