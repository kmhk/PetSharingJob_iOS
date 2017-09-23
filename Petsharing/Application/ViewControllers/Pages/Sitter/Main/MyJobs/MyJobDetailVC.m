//
//  MyJobDetailVC.m
//  Petsharing
//
//  Created by LandToSky on 8/21/17.
//  Copyright © 2017 LandToSky. All rights reserved.
//

#import "MyJobDetailVC.h"
#import "DogUser.h"
#import "DogJob.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface MyJobDetailVC ()
{
	IBOutlet UIScrollView *scrollView;
	IBOutlet UIView *containerView;
	
    IBOutlet UILabel *jobDescLbl;
    NSInteger ReadMoretag;
	
	IBOutlet UIImageView *imgViewAvatarOwner;
	IBOutlet UILabel *lblJobTitle;
	IBOutlet UILabel *lblJobPrice;
	IBOutlet UILabel *lblJobAddress;
	IBOutlet UILabel *lblJobStartDate;
	IBOutlet UILabel *lblJobEndDate;
	
	DogUser *jobOwner;
}

@end

@implementation MyJobDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self addReadMoreStringToUILabel:jobDescLbl];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[self initUI];
	[self initData];
}

- (void)initUI {
	scrollView.contentSize = containerView.frame.size;
}

- (void)initData {
	if (!self.curJob) {
		return;
	}
	
	lblJobTitle.text = self.curJob.jobTitle;
	lblJobAddress.text = self.curJob.jobAddress;
	jobDescLbl.text = self.curJob.jobDescription;
	lblJobPrice.text = [NSString stringWithFormat:@"%.0f USD", self.curJob.jobPrice];
	lblJobStartDate.text = [commonUtils convertDateToString:self.curJob.jobStartDate];
	lblJobEndDate.text = [commonUtils convertDateToString:self.curJob.jobEndDate];
	
	[[FirebaseRef storageForAvatar:self.curJob.jobOwnerID] downloadURLWithCompletion:^(NSURL * _Nullable URL, NSError * _Nullable error) {
		if (error) {
			[commonUtils showAlert:@"Warning!" withMessage:error.localizedDescription];
			return;
		}
		
		[imgViewAvatarOwner sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"avatar5"]];
	}];
//	lblOwnerName.text = [NSString stringWithFormat:@"%@ %@", [DogUser curUser].strFirstName, [DogUser curUser].strLastName];

	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	[DogUser fetchUser:self.curJob.jobOwnerID completion:^(DogUser *user) {
		[MBProgressHUD hideHUDForView:self.view animated:NO];
		jobOwner = user;
	}];
}


- (IBAction)onChat:(UIButton*)sender
{
    DemoMessagesViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DemoMessagesViewController"];
	vc.jobID = self.curJob.jobID;
	vc.myID = [DogUser curUser].userID;
	vc.opID = self.curJob.jobOwnerID;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onPhoneCall:(UIButton*) sender
{
    [commonUtils phoneCalling:jobOwner.strPhone];
}
/*

- (void)addReadMoreStringToUILabel:(UILabel*)label
{
    NSString *readMoreText = @" ...More";
    NSInteger lengthForString = label.text.length;
    if (lengthForString >= 30)
    {
        NSInteger lengthForVisibleString = [self fitString:label.text intoLabel:label];
        NSMutableString *mutableString = [[NSMutableString alloc] initWithString:label.text];
        NSString *trimmedString = [mutableString stringByReplacingCharactersInRange:NSMakeRange(lengthForVisibleString, (label.text.length - lengthForVisibleString)) withString:@""];
        NSInteger readMoreLength = readMoreText.length;
        NSString *trimmedForReadMore = [trimmedString stringByReplacingCharactersInRange:NSMakeRange((trimmedString.length - readMoreLength), readMoreLength) withString:@""];
        NSMutableAttributedString *answerAttributed = [[NSMutableAttributedString alloc] initWithString:trimmedForReadMore attributes:@{
                                                                                                                                        NSFontAttributeName : label.font
                                                                                                                                        }];
        
        NSMutableAttributedString *readMoreAttributed = [[NSMutableAttributedString alloc] initWithString:readMoreText attributes:@{
                                                                                                                                    NSFontAttributeName : [UIFont boldSystemFontOfSize:10.0f],
                                                                                                                                    NSForegroundColorAttributeName : [UIColor redColor]
                                                                                                                                    }];
        
        [answerAttributed appendAttributedString:readMoreAttributed];
        label.attributedText = answerAttributed;
        
        UITapGestureRecognizer *readMoreGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(readMoreDidClickedGesture)];
        [label addGestureRecognizer:readMoreGesture];
        
        label.userInteractionEnabled = YES;
    }
    else {
        
        NSLog(@"No need for 'Read More'...");
        
    }
}

- (void)readMoreDidClickedGesture
{
    NSLog(@"clicked more button");
    jobDescLbl.numberOfLines = 0;
    [jobDescLbl sizeToFit];
}


- (NSUInteger)fitString:(NSString *)string intoLabel:(UILabel *)label
{
    UIFont *font           = label.font;
    NSLineBreakMode mode   = label.lineBreakMode;
    
    CGFloat labelWidth     = label.frame.size.width;
    CGFloat labelHeight    = label.frame.size.height;
    CGSize  sizeConstraint = CGSizeMake(labelWidth, CGFLOAT_MAX);
    
    if (SYSTEM_VERSION_GREATER_THAN(@"7.0"))
    {
        NSDictionary *attributes = @{ NSFontAttributeName : font };
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:string attributes:attributes];
        CGRect boundingRect = [attributedText boundingRectWithSize:sizeConstraint options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        {
            if (boundingRect.size.height > labelHeight)
            {
                NSUInteger index = 0;
                NSUInteger prev;
                NSCharacterSet *characterSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
                
                do
                {
                    prev = index;
                    if (mode == NSLineBreakByCharWrapping)
                        index++;
                    else
                        index = [string rangeOfCharacterFromSet:characterSet options:0 range:NSMakeRange(index + 1, [string length] - index - 1)].location;
                }
                
                while (index != NSNotFound && index < [string length] && [[string substringToIndex:index] boundingRectWithSize:sizeConstraint options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.height <= labelHeight);
                
                return prev;
            }
        }
    }
    else
    {
        if ([string sizeWithFont:font constrainedToSize:sizeConstraint lineBreakMode:mode].height > labelHeight)
        {
            NSUInteger index = 0;
            NSUInteger prev;
            NSCharacterSet *characterSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
            
            do
            {
                prev = index;
                if (mode == NSLineBreakByCharWrapping)
                    index++;
                else
                    index = [string rangeOfCharacterFromSet:characterSet options:0 range:NSMakeRange(index + 1, [string length] - index - 1)].location;
            }
            
            while (index != NSNotFound && index < [string length] && [[string substringToIndex:index] sizeWithFont:font constrainedToSize:sizeConstraint lineBreakMode:mode].height <= labelHeight);
            
            return prev;
        }
    }
    
    return [string length];
}
 */
@end
