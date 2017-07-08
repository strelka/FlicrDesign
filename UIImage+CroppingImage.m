//
//  UIImage+CroppingImage.m
//  ShowFlicrImage
//
//  Created by Jullia Sharaeva on 05.06.17.
//  Copyright © 2017 Julia Sharaeva. All rights reserved.
//

#import "UIImage+CroppingImage.h"

@implementation UIImage (CroppingImage)

- (UIImage *)imageByCroppingImage{
    double refWidth = CGImageGetWidth(self.CGImage);
    double refHeight = CGImageGetHeight(self.CGImage);
    
    double sqrSide = fmin(refWidth, refHeight);
    
    double x = (refWidth - sqrSide) / 2.0;
    double y = (refHeight - sqrSide) / 2.0;
    
    CGRect cropSqrt = CGRectMake(x, y, sqrSide, sqrSide);
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], cropSqrt);
    
    UIImage *cropped = [UIImage imageWithCGImage:imageRef scale:0.0 orientation:UIImageOrientationUp];
    
    return cropped;
}


@end
