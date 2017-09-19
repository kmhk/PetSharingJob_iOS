//
//  OwnerPersonalInfoVC.m
//  Petsharing
//
//  Created by LandToSky on 7/27/17.
//  Copyright © 2017 LandToSky. All rights reserved.
//


#import "OwnerPersonalInfoVC.h"
#import "iCarousel.h"
#import "SZTextView.h" //https://github.com/glaszig/SZTextView  UITextView Placeholder
#import "DogUser.h"

@interface OwnerPersonalInfoVC ()<UIScrollViewDelegate, UITextFieldDelegate,UITextViewDelegate,iCarouselDataSource, iCarouselDelegate>
{
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIView *containerView;
    IBOutlet UIImageView *avatarIv;
    IBOutlet UITextField *firstNameTxt, *lastNameTxt;
    IBOutlet UITextField *emailTxt;
    IBOutlet UITextField *pswdTxt, *confirmPswdTxt;
    IBOutlet UITextField *phoneNumTxt;
    IBOutlet SZTextView *aboutMeTxtView;
    IBOutlet SZTextView *aboutDogTxtView;
    
    IBOutlet UIView *avatarSelectView;
    UIView *avatarBackTransparentView;
    IBOutlet iCarousel *mCarousel;
    NSMutableArray *items;
}

@end

@implementation OwnerPersonalInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    
}


- (void)initData
{
    items = [NSMutableArray array];
    for (int i = 0; i < 13; i++)
    {
        [items addObject:@(i)];
    }
}


- (void)initUI
{
    scrollView.delegate = self;
    [scrollView setContentSize:containerView.frame.size];
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
    
    aboutMeTxtView.delegate =
    aboutDogTxtView.delegate = self;
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}


#pragma mark - Button Action
-(IBAction)onContinue:(id)sender
{
	if (!firstNameTxt.text.length || !lastNameTxt.text.length ||
		!emailTxt.text.length ||
		!pswdTxt.text.length || ![pswdTxt.text isEqualToString:confirmPswdTxt.text] ||
		!phoneNumTxt.text.length ||
		!aboutDogTxtView.text.length ||
		!aboutDogTxtView.text.length) {
		
		UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Please input all field correctly" preferredStyle:UIAlertControllerStyleAlert];
		[alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
		[self presentViewController:alert animated:YES completion:nil];
		return;
		return;
	}
	
	UIImage *img = (avatarIv.image != nil? avatarIv.image: [UIImage imageNamed:@"user-placeholder"]);
	gCurUser = [DogUser user:@""
						role:DogUserRoleOwner
					  avatar:[DogAvatar avatar:@"" image:img ]
				   firstName:firstNameTxt.text
					lastName:lastNameTxt.text
					   email:emailTxt.text
					password:pswdTxt.text
					   phone:phoneNumTxt.text
					 aboutMe:aboutMeTxtView.text
					aboutDog:aboutDogTxtView.text
					category:@""];
	
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	[gCurUser signUp:^(NSError *error) {
		[MBProgressHUD hideHUDForView:self.view animated:YES];
		
		if (error) {
			UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
			[alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
			[self presentViewController:alert animated:YES completion:nil];
			return;
		}
		
		[self performSegueWithIdentifier:@"OwnerTermsVCSegue" sender:nil];
	}];
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


#pragma mark - TextView Delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if(self.isLoadingUserBase) return NO;
    float offset = 0;
    if (textView == aboutMeTxtView) {
        offset = 220;
    } else if (textView == aboutDogTxtView) {
        offset = 290;
    }
    [scrollView setContentOffset:CGPointMake(0, offset) animated:YES];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if(self.isLoadingUserBase) return NO;
    
    if ([text isEqualToString:@"\n"]) {
        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        return [textView resignFirstResponder];
    }
    
    // Limit line of UITextView is 2
    NSString *newText = [textView.text stringByReplacingCharactersInRange:range withString:text];
    CGFloat textWidth = CGRectGetWidth(UIEdgeInsetsInsetRect(textView.frame, textView.textContainerInset));
    textWidth -= 2.0 * textView.textContainer.lineFragmentPadding;
    
    CGSize boundingRect = [self sizeOfString:newText constrainedToWidth:textWidth font:textView.font];
    NSInteger numberOfLines = boundingRect.height / textView.font.lineHeight;
    
    return numberOfLines <= 3;
}

-(CGSize)sizeOfString:(NSString *)string constrainedToWidth:(double)width font:(UIFont *)font
{
    return  [string boundingRectWithSize:CGSizeMake(width, DBL_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil].size;
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
    NSString *imageName = [NSString stringWithFormat:@"dog%lu",index];
    
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
    [avatarIv setImage:[UIImage imageNamed:[NSString stringWithFormat:@"dog%lu",index]]];
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
    [avatarIv setImage:[UIImage imageNamed:[NSString stringWithFormat:@"dog%lu",mCarousel.currentItemIndex]]];
    [avatarSelectView setHidden:YES];
    [avatarBackTransparentView removeFromSuperview];
    avatarBackTransparentView = nil;
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


@end
