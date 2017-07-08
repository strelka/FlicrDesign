//
//  SPFTopNavigationView.h
//  ShowFlicrImage
//
//  Created by Jullia Sharaeva on 01.06.17.
//  Copyright © 2017 Julia Sharaeva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPFTopNavigationView : UIView
- (void) setAuthor:(NSString*)author AndLocation:(NSString*)location;
- (void) setAvatarImage:(UIImage*)image;
@end
