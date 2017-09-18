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

@interface FindJobListVC ()<UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView *mainTV;
    
}

@end

@implementation FindJobListVC

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
    return 10;
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
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FindJobDetailVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FindJobDetailVC"];
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
