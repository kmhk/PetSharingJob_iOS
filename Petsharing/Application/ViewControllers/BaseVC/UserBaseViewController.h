//
//  UserBaseViewController.h
//  Doo
//
//  Created by Jose on 2/25/16.
//  Copyright © 2016 simon. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UserBaseViewController : UIViewController

@property (nonatomic, assign) BOOL isLoadingUserBase;
- (IBAction)onBack:(id)sender;
- (void)navToMainView;
@end
