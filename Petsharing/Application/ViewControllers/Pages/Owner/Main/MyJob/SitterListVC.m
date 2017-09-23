//
//  SitterListVC.m
//  Petsharing
//
//  Created by LandToSky on 8/25/17.
//  Copyright © 2017 LandToSky. All rights reserved.
//

#import "SitterListVC.h"
#import "MessagesTVCell.h"
#import "StartJobVC.h"
#import "DogUser.h"
#import "DogJob.h"


@interface SitterListVC ()<UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView *mainTV;
	IBOutlet UILabel *lblJobTitle;
	
	NSMutableArray *users;
}
@end

@implementation SitterListVC

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
	lblJobTitle.text = self.curJob.jobTitle;
	
	if (!self.arrayUsers) {
		return;
	}
	
	if (!users) {
		users = [[NSMutableArray alloc] init];
	}
	[users removeAllObjects];
	
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	
	NSInteger count = self.arrayUsers.count;
	__block NSInteger loadedIndex = 0;
	
	for (NSString *string in self.arrayUsers) {
		[DogUser fetchUser:string completion:^(DogUser *user) {
			loadedIndex ++;
			
			if (!user) {
				[commonUtils showAlert:@"Warning!" withMessage:@"Broken db"];
			}
			
			[users addObject:user];
			
			if (loadedIndex >= count) {
				[MBProgressHUD hideHUDForView:self.view animated:YES];
				[mainTV reloadData];
			}
		}];
	}
}

- (void)initUI
{
    
}

#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return users.count;
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
	
	[cell.chatBtn setTag:indexPath.row];
    [cell.chatBtn addTarget:self action:@selector(onChat:) forControlEvents:UIControlEventTouchUpInside];
	
	[cell.phoneCallBtn setTag:indexPath.row];
    [cell.phoneCallBtn addTarget:self action:@selector(onPhoneCall:) forControlEvents:UIControlEventTouchUpInside];
	
	[cell.hireBtn setTag:indexPath.row];
    [cell.hireBtn addTarget:self action:@selector(onHire:) forControlEvents:UIControlEventTouchUpInside];
	
	[cell setDogUser:users[indexPath.row]];
	
    return cell;
}


- (void)onChat:(UIButton*)sender
{
	DogUser *user = users[[sender tag]];
	
    DemoMessagesViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DemoMessagesViewController"];
	vc.jobID = self.curJob.jobID;
	vc.myID = [DogUser curUser].userID;
	vc.opID = user.userID;
	
	[self.navigationController pushViewController:vc animated:YES];
}

- (void)onPhoneCall:(UIButton*) sender
{
	DogUser *user = users[[sender tag]];
    [commonUtils phoneCalling:user.strPhone];
}

- (void)onHire:(UIButton*)sender
{
	DogUser *user = users[[sender tag]];
	
    StartJobVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"StartJobVC"];
	vc.curJob = self.curJob;
	vc.choosenSitter = user;
	
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
