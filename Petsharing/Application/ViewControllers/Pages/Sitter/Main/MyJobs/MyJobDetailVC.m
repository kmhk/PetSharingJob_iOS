//
//  MyJobDetailVC.m
//  Petsharing
//
//  Created by LandToSky on 8/21/17.
//  Copyright © 2017 LandToSky. All rights reserved.
//

#import "MyJobDetailVC.h"

@interface MyJobDetailVC ()
{
    IBOutlet UILabel *jobDescLbl;
    NSInteger ReadMoretag;
}

@end

@implementation MyJobDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self addReadMoreStringToUILabel:jobDescLbl];
}


- (IBAction)onChat:(UIButton*)sender
{
    DemoMessagesViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DemoMessagesViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onPhoneCall:(UIButton*) sender
{
    [commonUtils phoneCalling:@""];
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
