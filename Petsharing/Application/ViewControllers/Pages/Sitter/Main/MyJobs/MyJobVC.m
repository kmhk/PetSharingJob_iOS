//
//  MyJobVC.m
//  Petsharing
//
//  Created by LandToSky on 8/21/17.
//  Copyright © 2017 LandToSky. All rights reserved.
//

#import "MyJobVC.h"
#import "JobListTVCell.h"
#import "MyJobDetailVC.h"
#import "SitterTbVC.h"


@interface MyJobVC () <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView *mainTV;
	
	IBOutlet UILabel *lblJobCount;
	
	BOOL bFirstTime;
}

@end

@implementation MyJobVC

- (void)viewDidLoad {
    [super viewDidLoad];
	
	bFirstTime = YES;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	if (bFirstTime) {
		[self initUI];
		[self initData];
	}
	
	bFirstTime = NO;
}

- (void)initData
{
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	
	[sitterViewModel loadAllMyJobs:^(NSError *error) {
		[MBProgressHUD hideHUDForView:self.view animated:YES];
		
		if (error) {
			[commonUtils showAlert:@"Warning!" withMessage:error.localizedDescription];
			
			return;
		}
		
		[mainTV reloadData];
		lblJobCount.text = [NSString stringWithFormat:@"%lu ongoing jobs",
							((sitterViewModel.hiredJobs == nil)? 0: sitterViewModel.hiredJobs.count) + ((sitterViewModel.postedJobs == nil)? 0: sitterViewModel.postedJobs.count)];
	}];
}

- (void)initUI
{
    
}

#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (sitterViewModel.hiredJobs == nil)? 0: sitterViewModel.hiredJobs.count;;
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
	
	[cell setJob:sitterViewModel.hiredJobs[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//	[self performSegueWithIdentifier:@"segueJobEnd" sender:indexPath];
    MyJobDetailVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MyJobDetailVC"];
	vc.curJob = sitterViewModel.hiredJobs[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
	if ([segue.identifier isEqualToString:@"segueJobDetail"]) {
//		MyJobDetailVC *vc = (MyJobDetailVC *)segue.destinationViewController;
		
//		vc.job = ownerViewModel.hiredJobs[[sender row]];
	}
}

@end
