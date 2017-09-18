//
//  MessageListVC.m
//  Petsharing
//
//  Created by LandToSky on 8/26/17.
//  Copyright © 2017 LandToSky. All rights reserved.
//

#import "OwnerMessageListVC.h"
#import "MessagesTVCell.h"
#import "StartJobVC.h"


@interface OwnerMessageListVC ()<UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView *mainTV;
}
@end

@implementation OwnerMessageListVC

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
    return 15;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessagesTVCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"MessagesTVCell"];
    if (cell == nil) {
        cell = (MessagesTVCell*) [[MessagesTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MessagesTVCell"];
    }
    
    if (indexPath.row % 2 == 0) {
        [cell setBackgroundColor:appController.appRowBlueColor];
    } else {
        [cell setBackgroundColor:appController.appRowGreyColor];
    }
    
    [cell.chatBtn addTarget:self action:@selector(onChat:) forControlEvents:UIControlEventTouchUpInside];
    [cell.phoneCallBtn addTarget:self action:@selector(onPhoneCall:) forControlEvents:UIControlEventTouchUpInside];
    [cell.hireBtn addTarget:self action:@selector(onHire:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)onChat:(UIButton*)sender
{
    DemoMessagesViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DemoMessagesViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onPhoneCall:(UIButton*) sender
{
    [commonUtils phoneCalling:@""];
}

- (void)onHire:(UIButton*)sender
{
    StartJobVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"StartJobVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    LiveJobDetailVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LiveJobDetailVC"];
    //    [self.navigationController pushViewController:vc animated:YES];
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
