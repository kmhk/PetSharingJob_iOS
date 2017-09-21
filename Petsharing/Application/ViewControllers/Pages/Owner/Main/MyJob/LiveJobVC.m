//
//  LiveTaskVC.m
//  Petsharing
//
//  Created by LandToSky on 8/23/17.
//  Copyright © 2017 LandToSky. All rights reserved.
//

#import "LiveJobVC.h"
#import "JobListTVCell.h"
#import "LiveJobDetailVC.h"
#import "EndJobVC.h"
#import "OwnerTbVC.h"

@interface LiveJobVC () <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView *mainTV;
    
	IBOutlet UILabel *lblJobCount;
}


@end

@implementation LiveJobVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	lblJobCount.text = [NSString stringWithFormat:@"%lu live tasks",
						((ownerViewModel.hiredJobs == nil)? 0: ownerViewModel.hiredJobs.count) + ((ownerViewModel.postedJobs == nil)? 0: ownerViewModel.postedJobs.count)];
	
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	[ownerViewModel loadAllMyJobs:^(NSError *error) {
		[MBProgressHUD hideHUDForView:self.view animated:YES];
		[mainTV reloadData];
	}];
}

- (void)initData
{
	
}

- (void)initUI
{
    
}

- (void)reloadJobs {
	[mainTV reloadData];
}


#pragma mark - TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 2;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (section == HIREDJOBSECTION) {
		return @"hired";
		
	} else {
		return @"posted";
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (section == HIREDJOBSECTION) {
		return (ownerViewModel.hiredJobs == nil)? 0: ownerViewModel.hiredJobs.count;
		
	} else {
		return (ownerViewModel.postedJobs == nil)? 0: ownerViewModel.postedJobs.count;
	}
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JobListTVCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"JobListTVCell"];
    if (cell == nil) {
        cell = (JobListTVCell*) [[JobListTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"JobListTVCell"];
    }
    
    if (indexPath.row % 2 == 0) {
        [cell setBackgroundColor:appController.appRowBlueColor];
    } else {
        [cell setBackgroundColor:appController.appRowGreyColor];
    }
    
	if (indexPath.section == HIREDJOBSECTION) {
		[cell setJob:ownerViewModel.hiredJobs[indexPath.row]];
		[cell.jobStatusLbl setText:@"Hired"];
		
	} else {
		[cell setJob:ownerViewModel.postedJobs[indexPath.row]];
		[cell.jobStatusLbl setText:@"Posted"];
	}
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == HIREDJOBSECTION) {
		[self performSegueWithIdentifier:@"segueJobEnd" sender:indexPath];
	} else {
		[self performSegueWithIdentifier:@"segueJobDetail" sender:indexPath];
	}
	
//	if (indexPath.row  < 2) {
//		EndJobVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"EndJobVC"];
//		[self.navigationController pushViewController:vc animated:YES];
//	} else {
//		LiveJobDetailVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LiveJobDetailVC"];
//		[self.navigationController pushViewController:vc animated:YES];
//		
//	}
}

#pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
	if ([segue.identifier isEqualToString:@"segueJobDetail"]) {
		LiveJobDetailVC *vc = (LiveJobDetailVC *)segue.destinationViewController;
		
		vc.job = ownerViewModel.postedJobs[[sender row]];
		
	} else if ([segue.identifier isEqualToString:@"segueJobEnd"]) {
		EndJobVC *vc = (EndJobVC *)segue.destinationViewController;
		vc.curJob = ownerViewModel.hiredJobs[[sender row]];
	}
}


@end
