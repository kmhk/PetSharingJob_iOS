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

@interface LiveJobVC () <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView *mainTV;
    
}


@end

@implementation LiveJobVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
}

- (void)initData
{
    
}

- (void)initUI
{
    
}

#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
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
    
    if (indexPath.row  < 2) {
        [cell.jobStatusLbl setText:@"Hired"];
    } else {
        [cell.jobStatusLbl setText:@"Posted"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row  < 2) {
        EndJobVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"EndJobVC"];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        LiveJobDetailVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LiveJobDetailVC"];
        [self.navigationController pushViewController:vc animated:YES];

    }

   
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
