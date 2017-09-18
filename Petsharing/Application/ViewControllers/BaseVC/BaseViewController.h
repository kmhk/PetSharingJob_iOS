//
//  BaseViewController.h
//  Doo
//
//  Created by Jose on 12/19/15.
//  Copyright © 2015 simon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

- (IBAction)onBack:(id)sender;
- (IBAction)onMenuShow:(id)sender;

@property(nonatomic, assign) BOOL isLoadingBase;
@end
