//
//  PastJobVC.m
//  Petsharing
//
//  Created by LandToSky on 8/22/17.
//  Copyright © 2017 LandToSky. All rights reserved.
//

#import "PastJobVC.h"
#import "JobListTVCell.h"
#import "PastJobDetailVC.h"
#import "DogUser.h"


@interface PastJobVC ()<UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView *mainTV;
	IBOutlet UILabel *lblStatus;
    
}

@end

@implementation PastJobVC

- (void)viewDidLoad {
    [super viewDidLoad];
	
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[self initData];
	[self initUI];
}

- (void)initData
{
    [[DogUser curUser] loadUser:^(NSError *error) {
		[mainTV reloadData];
	}];
}

- (void)initUI
{
	lblStatus.text = [NSString stringWithFormat:@"%lu complete jobs", (unsigned long)([DogUser curUser].finishedJobIDs == nil? 0: [DogUser curUser].finishedJobIDs.count)];
}

#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return ([DogUser curUser].finishedJobIDs == nil? 0: [DogUser curUser].finishedJobIDs.count);
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
	
	[cell setJobID:[DogUser curUser].finishedJobIDs[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PastJobDetailVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PastJobDetailVC"];
	vc.jobID = [DogUser curUser].finishedJobIDs[indexPath.row];
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
