//
//  FindJobListVC.m
//  Petsharing
//
//  Created by LandToSky on 8/22/17.
//  Copyright © 2017 LandToSky. All rights reserved.
//

#import "FindJobListVC.h"
#import "JobListTVCell.h"
#import "FindJobDetailVC.h"
#import "SitterTbVC.h"
#import "DogUser.h"
#import "DogJob.h"
#import "AppDelegate.h"


typedef enum {
	ArrangedTypeTime = 0,
	ArrangedTypePrice,
	ArrangedTypeDistance
} ArrangedType;

@interface FindJobListVC ()<UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView *mainTV;
	
	ArrangedType typeArrange;
}

@end

@implementation FindJobListVC

- (void)viewDidLoad {
    [super viewDidLoad];
	
	typeArrange = ArrangedTypeTime;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[self initData];
	[self initUI];
}

- (void)initData
{
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	
	[sitterViewModel loadAllJobs:^(NSError *error) {
		[MBProgressHUD hideHUDForView:self.view animated:YES];
		
		if (error) {
			[commonUtils showAlert:@"Warning!" withMessage:error.localizedDescription];
			
			return;
		}
		
		[self arrangeJobs];
	}];
}

- (void)initUI
{
    
}

- (IBAction)segmentSortChanged:(UISegmentedControl *)sender {
	typeArrange = sender.selectedSegmentIndex;
	[self initData];
}

- (void)arrangeJobs {
	if (typeArrange == ArrangedTypeTime) { // arrange by time
		[sitterViewModel.allJobs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
			return [((DogJob *)obj2).jobCreatedDate compare:((DogJob *)obj1).jobCreatedDate];
		}];
		
	} else if (typeArrange == ArrangedTypePrice) { // arrange by price
		[sitterViewModel.allJobs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
			return (((DogJob *)obj1).jobPrice < ((DogJob *)obj2).jobPrice);
		}];
		
	} else { //arranged by distance
		[sitterViewModel.allJobs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
			CLLocation *loc1 = [[CLLocation alloc] initWithLatitude:((DogJob *)obj1).jobLocation.latitude longitude:((DogJob *)obj1).jobLocation.longitude];
			CLLocationDistance distance1 = [[AppDelegate sharedAppDelegate].currentLocation distanceFromLocation:loc1];
			
			CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:((DogJob *)obj2).jobLocation.latitude longitude:((DogJob *)obj2).jobLocation.longitude];
			CLLocationDistance distance2 = [[AppDelegate sharedAppDelegate].currentLocation distanceFromLocation:loc2];
			
			return (distance1 < distance2);
		}];
	}
	
	[mainTV reloadData];
}


#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (sitterViewModel.allJobs == nil)? 0: sitterViewModel.allJobs.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JobListTVCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"JobListTVCell"];
    if (cell == nil) {
        cell = (JobListTVCell*) [[JobListTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"JobListTVCell"];
    }
    
    if (indexPath.row % 2 == 0) {
        [cell setBackgroundColor:[UIColor colorWithHex:@"#d8e9f0" alpha:1.0f]];
    } else {
        [cell setBackgroundColor:[UIColor colorWithHex:@"#f1f1f1" alpha:1.0f]];
    }
	
	[cell setJob:sitterViewModel.allJobs[indexPath.row] arrangedType:typeArrange];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FindJobDetailVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FindJobDetailVC"];
	vc.job = sitterViewModel.allJobs[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
