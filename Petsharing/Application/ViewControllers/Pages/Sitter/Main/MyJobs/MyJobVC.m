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

@interface MyJobVC () <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView *mainTV;
    
}

@end

@implementation MyJobVC

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
        [cell setBackgroundColor:appController.appRowBlueColor];
    } else {
        [cell setBackgroundColor:appController.appRowGreyColor];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyJobDetailVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MyJobDetailVC"];
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
