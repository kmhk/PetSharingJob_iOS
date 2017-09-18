//
//  SitterPersonalInfoVC.m
//  Petsharing
//
//  Created by LandToSky on 7/25/17.
//  Copyright © 2017 LandToSky. All rights reserved.
//

#import "SitterPersonalInfoVC.h"
#import "SBPickerSelector.h"  //https://github.com/Busta117/SBPickerSelector
#import "iCarousel.h"

@interface SitterPersonalInfoVC ()<SBPickerSelectorDelegate, UIScrollViewDelegate, UITextFieldDelegate,iCarouselDataSource, iCarouselDelegate>

{
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIImageView *avatarIv;
    IBOutlet UITextField *firstNameTxt, *lastNameTxt;
    IBOutlet UITextField *emailTxt;
    IBOutlet UITextField *pswdTxt, *confirmPswdTxt;
    IBOutlet UITextField *phoneNumTxt;
    IBOutlet UITextField *taskTxt;
    
    
    IBOutlet UIView *avatarSelectView;
    UIView *avatarBackTransparentView;
    IBOutlet iCarousel *mCarousel;
    NSMutableArray *items;
    
}

@end

@implementation SitterPersonalInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];

}

- (void)initData
{
    items = [NSMutableArray array];
    for (int i = 0; i < 8; i++)
    {
        [items addObject:@(i)];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)initUI
{
    scrollView.delegate = self;
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTappedScreen)]];

    firstNameTxt.delegate = lastNameTxt.delegate = emailTxt.delegate = pswdTxt.delegate
    = confirmPswdTxt.delegate = phoneNumTxt.delegate = self;
    

    [avatarSelectView setHidden:YES];
    mCarousel.dataSource = self;
    mCarousel.delegate = self;
    mCarousel.type = iCarouselTypeCustom;
    mCarousel.pagingEnabled = YES;
    mCarousel.scrollToItemBoundary = NO;
    [mCarousel setAlpha:0.0f];
}


#pragma mark - Button Action
-(IBAction)onContinue:(id)sender
{
    [self performSegueWithIdentifier:@"SitterTermsVCSegue" sender:nil];
}





#pragma mark - TextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (self.isLoadingUserBase) return NO;
    
    float offset = 0;
    if (textField == pswdTxt) {
        offset = 30;
    } else if (textField == confirmPswdTxt) {
        offset = 60;
    } else if (textField == phoneNumTxt) {
        offset = 90;
    }
    [scrollView setContentOffset:CGPointMake(0, offset) animated:YES];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.isLoadingUserBase) return NO;
    
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    return [textField resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *replacedString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if ((textField == pswdTxt || textField == confirmPswdTxt) && replacedString.length > 10) {
        return NO;
    }
    /*else if (textField == txtFieldPhoneNumber) {
     if([replacedString length] < 10)
     return YES;
     else {
     [AppController shakeAnimation:txtFieldPhoneNumber];
     return NO;
     }
     }*/ else if (textField == firstNameTxt && replacedString.length > 20) {
         return NO;
     } else if (textField == lastNameTxt && replacedString.length > 20) {
         return NO;
     } else if (textField == phoneNumTxt){
         int length = (int)[self getLength:textField.text];
         if(length == 10)
         {
             if(range.length == 0)
                 return NO;
         }
         if(length == 3)
         {
             NSString *num = [self formatNumber:textField.text];
             textField.text = [NSString stringWithFormat:@"(%@) ",num];
             
             if(range.length > 0)
                 textField.text = [NSString stringWithFormat:@"%@",[num substringToIndex:3]];
         }
         else if(length == 6)
         {
             NSString *num = [self formatNumber:textField.text];
             textField.text = [NSString stringWithFormat:@"(%@) %@-",[num  substringToIndex:3],[num substringFromIndex:3]];
             
             if(range.length > 0)
                 textField.text = [NSString stringWithFormat:@"(%@) %@",[num substringToIndex:3],[num substringFromIndex:3]];
         }
         return YES;
     }
     else {
         textField.text = replacedString;
     }
    return NO;
}


#pragma mark - Avatar Choose
- (IBAction)onChooseAvatar:(id)sender
{
    [avatarSelectView setHidden:NO];
    [mCarousel setAlpha:1.0f];
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    avatarBackTransparentView = [[UIView alloc] initWithFrame:window.bounds];
    [avatarBackTransparentView setBackgroundColor:appController.appOverlayerColor];
    [self.view insertSubview:avatarBackTransparentView belowSubview:avatarSelectView];
}


- (NSInteger)numberOfItemsInCarousel:(__unused iCarousel *)carousel
{
    return (NSInteger)[items count];
}

- (UIView *)carousel:(__unused iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UIImageView *imageView = nil;
    NSString *imageName = [NSString stringWithFormat:@"avatar%lu",index];
    
    if (view == nil){
        CGFloat length = 90;
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, length, length)];
        [view setBackgroundColor:[UIColor clearColor]];
        if (index != 0) [view setAlpha:backAlpha];
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5.0f, 5.0f, length, length)];
        imageView.image = [UIImage imageNamed:imageName];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.clipsToBounds = YES;
        [imageView setTag:1];
        
        [view addSubview:imageView];
        [view setTag:0];
    }
    else{
        imageView = (UIImageView *)[view viewWithTag:1];
//        [view setAlpha:backAlpha];
    }
    imageView.image = [UIImage imageNamed:imageName];
    
    return view;
}


- (CGFloat)carousel:(__unused iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return YES;
        }
            
        case iCarouselOptionShowBackfaces:
        {
            return NO;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * 1.0f;
        }
        case iCarouselOptionVisibleItems:
        {
            return 5;
        }
        default:
        {
            return value;
        }
            
    }
}

- (void)carousel:(__unused iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    [avatarIv setImage:[UIImage imageNamed:[NSString stringWithFormat:@"avatar%lu",index]]];
    [avatarSelectView setHidden:YES];
    [avatarBackTransparentView removeFromSuperview];
    avatarBackTransparentView = nil;
}

- (void)carouselCurrentItemIndexDidChange:(__unused iCarousel *)carousel1
{
    [mCarousel.currentItemView setAlpha:1.0f];
    [[mCarousel itemViewAtIndex:mCarousel.previousItemIndex] setAlpha:backAlpha];
    NSLog(@"Changed Item Index ==>%lu", mCarousel.currentItemIndex);
}



- (CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //set up base transform
    CGFloat spacing = 90 ;
    CGFloat scale =0.0f;
    scale = 1.0f - fabs(offset)/10*2;
    CATransform3D scaleTrans = CATransform3DScale(transform, scale, scale, 1);
    CATransform3D moveTrans = CATransform3DTranslate(transform, offset*spacing, 0, 0);
    return  CATransform3DConcat(scaleTrans, moveTrans);
}

- (IBAction)onAvatarCancel:(id)sender{
    [avatarSelectView setHidden:YES];
    [avatarBackTransparentView removeFromSuperview];
    avatarBackTransparentView = nil;
}

- (IBAction)onAvatarSelect:(id)sender{
    [avatarIv setImage:[UIImage imageNamed:[NSString stringWithFormat:@"avatar%lu",mCarousel.currentItemIndex]]];
    [avatarSelectView setHidden:YES];
    [avatarBackTransparentView removeFromSuperview];
    avatarBackTransparentView = nil;
}


#pragma mark - Task Select
- (IBAction)onTaskSelect:(id)sender
{
    [self.view endEditing:YES];
    [scrollView setContentOffset:CGPointMake(0,60) animated:YES];
    
    
    SBPickerSelector *picker = [SBPickerSelector picker];
    
    picker.pickerData = [@[@"Dog Walking",@"Hour",@"All Day",@"Week",@"Sharing",@"Older Dog", @"Other"] mutableCopy]; //picker content
    picker.delegate = self;
    picker.pickerType = SBPickerSelectorTypeText;
    picker.doneButtonTitle = @"Done";
    picker.cancelButtonTitle = @"Cancel";
    

    [picker showPickerFromView:self.view inViewController:self];
}

-(void) pickerSelector:(SBPickerSelector *)selector selectedValue:(NSString *)value index:(NSInteger)idx{
    [taskTxt setText:value];
    [self onTappedScreen];
}


-(void) pickerSelector:(SBPickerSelector *)selector cancelPicker:(BOOL)cancel{
    NSLog(@"press cancel");
    [self onTappedScreen];
}



#pragma mark - Others
- (NSString *)formatNumber:(NSString* )mobileNumber
{
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    int length = (int)[mobileNumber length];
    if(length > 10)
    {
        mobileNumber = [mobileNumber substringFromIndex: length-10];
    }
    return mobileNumber;
}

- (int)getLength:(NSString *)mobileNumber
{
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    int length = (int)[mobileNumber length];
    return length;
}

- (void)onTappedScreen {
    [self.view endEditing:YES];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
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
