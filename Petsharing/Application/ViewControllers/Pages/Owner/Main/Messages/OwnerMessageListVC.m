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
#import "OwnerTbVC.h"
#import "DogUser.h"
#import "DogJob.h"


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
	[ownerViewModel loadAllChat:^(NSError *error) {
		[mainTV reloadData];
	}];
}

- (void)initUI
{
    
}

#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ownerViewModel.allChats.count;
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
	
	NSDictionary *dict = ownerViewModel.allChats[indexPath.row];
	NSString *opUserID = [[dict[@"chatNodeID"] componentsSeparatedByString:@"+"] lastObject];
	[cell setJobID:dict[@"jobID"] opUserID:opUserID];
	
	[cell.chatBtn setTag:indexPath.row];
    [cell.chatBtn addTarget:self action:@selector(onChat:) forControlEvents:UIControlEventTouchUpInside];
	
	[cell.phoneCallBtn setTag:indexPath.row];
    [cell.phoneCallBtn addTarget:self action:@selector(onPhoneCall:) forControlEvents:UIControlEventTouchUpInside];
	
	[cell.hireBtn setTag:indexPath.row];
    [cell.hireBtn addTarget:self action:@selector(onHire:) forControlEvents:UIControlEventTouchUpInside];
	
    return cell;
}

- (void)onChat:(UIButton*)sender
{
	MessagesTVCell *cell = [mainTV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
	
    DemoMessagesViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DemoMessagesViewController"];
	vc.jobID = cell.curJob.jobID;
	vc.myID = [DogUser curUser].userID;
	vc.opID = cell.opUser.userID;
	
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onPhoneCall:(UIButton*) sender
{
	MessagesTVCell *cell = [mainTV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
							
    [commonUtils phoneCalling:cell.opUser.strPhone];
}

- (void)onHire:(UIButton*)sender
{
	MessagesTVCell *cell = [mainTV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
	
    StartJobVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"StartJobVC"];
	vc.curJob = cell.curJob;
	vc.choosenSitter = cell.opUser;
	
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
