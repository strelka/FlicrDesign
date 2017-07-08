//
//  NSColor+SPFColors.m
//  ShowFlicrImage
//
//  Created by Jullia Sharaeva on 02.06.17.
//  Copyright © 2017 Julia Sharaeva. All rights reserved.
//

#import "UIColor+SPFColors.h"

@implementation UIColor (SPFColors)
+ (UIColor*) SPFBackgroundColor{
    return [[UIColor alloc] initWithRed:250.0f/255.0f green:250.0f/255.0f blue:250.0f/255.0f alpha:0.9];
}

+ (UIColor*)SPFFontColor{
    return [[UIColor alloc] initWithRed:170/255.0f green:170/255.0f blue:170/255.0f alpha:1];
}

@end
