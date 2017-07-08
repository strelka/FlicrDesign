//
//  NSURL+Caching.m
//  ShowFlicrImage
//
//  Created by Jullia Sharaeva on 02.06.17.
//  Copyright © 2017 Julia Sharaeva. All rights reserved.
//
#import "NSCacheSingleton.h"
#import "NSURL+Caching.h"

@implementation NSURL (Caching)

- (void) cachingImage:(UIImage*)image{
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@", self];
    [[NSCacheSingleton sharedCache].imageCache setObject:image forKey:urlString];
    NSLog(@"caching %@", self);
}

- (UIImage*) getImageFromCache{
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@", self];
    return [[NSCacheSingleton sharedCache].imageCache objectForKey:urlString];
}

@end
