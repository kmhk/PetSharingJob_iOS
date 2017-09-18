//
//  CALayer+UIColor.m
//  Petsharing
//
//  Created by LandToSky on 7/30/17.
//  Copyright © 2017 LandToSky. All rights reserved.
//

#import "CALayer+UIColor.h"

@implementation CALayer(UIColor)

- (void)setBorderUIColor:(UIColor*)color {
    self.borderColor = color.CGColor;
}

- (UIColor*)borderUIColor {
    return [UIColor colorWithCGColor:self.borderColor];
}

@end
