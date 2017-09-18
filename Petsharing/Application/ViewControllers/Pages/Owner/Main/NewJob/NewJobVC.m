//
//  NewTaskVC.m
//  Petsharing
//
//  Created by LandToSky on 8/23/17.
//  Copyright © 2017 LandToSky. All rights reserved.
//

#import "NewJobVC.h"
#import "SBPickerSelector.h"  //https://github.com/Busta117/SBPickerSelector
#import "GoogleAutoCompleteViewController.h"


@interface NewJobVC () <UIScrollViewDelegate, UITextFieldDelegate, UITextViewDelegate,SBPickerSelectorDelegate, GoogleAutoCompleteViewDelegate>
{
    IBOutlet UIScrollView *mScrollView;
    IBOutlet UIView *contentView;
    IBOutlet UITextField *jobTitleTxt;
    IBOutlet UITextView *jobDescTxtView;
    IBOutlet UILabel *jobCategoryLbl;
    IBOutletCollection(UIButton) NSArray *jobLocationBtns;
    IBOutlet UILabel *jobAddressLbl;
    IBOutlet UILabel *jobStartTimeLbl;
    IBOutlet UILabel *jobEndTimeLbl;
    
    NSInteger start_endDateTimeBtnIndex; // 0: Start time, 1: End time
}

@end

@implementation NewJobVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
}

- (void)initData
{
    start_endDateTimeBtnIndex = 0;
}

- (void) initUI
{
    mScrollView.delegate = self;
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTappedScreen)]];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

#pragma mark - Button Action
-(IBAction)onPostJob:(id)sender
{
 
}

- (IBAction)onWhereBtns:(UIButton*)sender
{
    [commonUtils multileButtonActions:sender inButtons:jobLocationBtns];
    
}

#pragma mark - TextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.isLoadingBase) return NO;
    if (textField == jobTitleTxt) {
        [mScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.isLoadingBase) return NO;
    [mScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    return [textField resignFirstResponder];
}

#pragma mark - TextView Delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (self.isLoadingBase) return NO;
    if (textView == jobDescTxtView) {
        [mScrollView setContentOffset:CGPointMake(0, 0)];
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if(self.isLoadingBase) return NO;
    
    if ([text isEqualToString:@"\n"]) {
        [mScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        return [textView resignFirstResponder];
    }
    
    // Limit line of UITextView is 2
//    NSString *newText = [textView.text stringByReplacingCharactersInRange:range withString:text];
//    CGFloat textWidth = CGRectGetWidth(UIEdgeInsetsInsetRect(textView.frame, textView.textContainerInset));
//    textWidth -= 2.0 * textView.textContainer.lineFragmentPadding;
//    
//    CGSize boundingRect = [self sizeOfString:newText constrainedToWidth:textWidth font:textView.font];
//    NSInteger numberOfLines = boundingRect.height / textView.font.lineHeight;
//    
//    return numberOfLines <= 3;
    return YES;
}

//-(CGSize)sizeOfString:(NSString *)string constrainedToWidth:(double)width font:(UIFont *)font
//{
//    return  [string boundingRectWithSize:CGSizeMake(width, DBL_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil].size;
//}

#pragma mark - Settings - Add Location
- (IBAction) onAddress:(UIButton *)sender {
    
    
    //if([commonUtils getUserDefault:@"currentLatitude"] != nil && [commonUtils getUserDefault:@"currentLongitude"] != nil) {
    GoogleAutoCompleteViewController *pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GoogleAutoCompleteViewController"];
    pageViewController.GoogleAutoCompleteViewDelegate = self;    
    [self presentViewController:pageViewController animated:YES completion:nil];
    
    //    } else {
    //        [commonUtils showVAlertSimple:@"Failed" body:@"Please allow your location settings enabled" duration:1.2];
    //    }
    
}

#pragma mark - GoogleAutoComplete Delegate
-(void) GoogleAutoCompleteViewControllerDismissedWithAddress:(NSString *)address AndPlacemark:(CLPlacemark *)placeMark ForTextObj:(NSInteger *)textObjTag {
}

- (void)GoogleAutoCompleteViewControllerDismissedWithAddress:(NSString *)address AndLocation:(CLLocation *)location ForTextObj:(NSInteger *)textObjTag{
    
    NSString *addLocationAddress = @"";
//    addLocationAddress = [commonUtils removeCharactersFromString:address withFormat:@[@"&"]];
    addLocationAddress = [address stringByReplacingOccurrencesOfString:@"&" withString:@"and"];
    
    NSLog(@"Address => %@", addLocationAddress);
    NSLog(@"Latitude => %f", location.coordinate.latitude);
    NSLog(@"Longitude => %f", location.coordinate.longitude);
    [jobAddressLbl setText:addLocationAddress];
    
    
    if([addLocationAddress isEqualToString:@""]) {
         [commonUtils showVAlertSimple:@"Warning" body:@"Please try again with different address to add" duration:1.3f];
    } else {
        
   }
}




#pragma mark - Category Select
- (IBAction)onCategory:(id)sender
{
    [self.view endEditing:YES];
    [mScrollView setContentOffset:CGPointMake(0,0) animated:YES];
    
    SBPickerSelector *picker = [SBPickerSelector picker];
    
    picker.pickerData = [@[@"Dog Walking",@"Hour",@"All Day",@"Week",@"Sharing",@"Older Dog", @"Other"] mutableCopy]; //picker content
    picker.delegate = self;
    picker.pickerType = SBPickerSelectorTypeText;
//    picker.doneButtonTitle = @"Done";
//    picker.cancelButtonTitle = @"Cancel";
    [picker showPickerFromView:self.view inViewController:self];
}

-(void) pickerSelector:(SBPickerSelector *)selector selectedValue:(NSString *)value index:(NSInteger)idx
{
    [jobCategoryLbl setText:value];
    [self onTappedScreen];
}


-(void) pickerSelector:(SBPickerSelector *)selector cancelPicker:(BOOL)cancel{
    NSLog(@"press cancel");
    [self onTappedScreen];
}

#pragma mark - Start/End Time  Select
- (IBAction)onStartDateTime:(UIButton*)sender
{
    [self.view endEditing:YES];
    if (sender.tag == 0) {
        [mScrollView setContentOffset:CGPointMake(0,120) animated:YES];
        start_endDateTimeBtnIndex = 0;
    } else if (sender.tag == 1) {
        [mScrollView setContentOffset:CGPointMake(0,180) animated:YES];
        start_endDateTimeBtnIndex = 1;
    }
    
    SBPickerSelector *picker = [SBPickerSelector picker];
    picker.pickerType = SBPickerSelectorTypeDate;
    picker.datePickerType = SBPickerSelectorDateTypeDefault;
    picker.delegate = self;
    [picker showPickerFromView:self.view inViewController:self];
}

- (void) pickerSelector:(SBPickerSelector *)selector dateSelected:(NSDate *)date
{
    if (start_endDateTimeBtnIndex == 0) {
        [jobStartTimeLbl setText:[commonUtils convertDateToString:date]];
    } else {
        [jobEndTimeLbl setText:[commonUtils convertDateToString:date]];
    }
    [self onTappedScreen];
}


- (void)onTappedScreen {
    [self.view endEditing:YES];
    [mScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}
@end
