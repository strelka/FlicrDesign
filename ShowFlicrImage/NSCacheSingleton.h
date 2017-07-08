//
//  NSCacheSingleton.h
//  ShowPictureFromFlickr
//
//  Created by Jullia Sharaeva on 23.05.17.
//  Copyright © 2017 Julia Sharaeva. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSCacheSingleton : NSObject
@property (nonatomic, strong) NSCache* imageCache;
+ (NSCacheSingleton *) sharedCache;

@end
