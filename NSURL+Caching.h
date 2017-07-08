//
//  NSURL+Caching.h
//  ShowFlicrImage
//
//  Created by Jullia Sharaeva on 02.06.17.
//  Copyright © 2017 Julia Sharaeva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSURL (Caching)
- (void) cachingImage:(UIImage*)image;
- (UIImage*) getImageFromCache;
@end
