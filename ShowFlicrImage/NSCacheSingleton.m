//
//  NSCacheSingleton.m
//  ShowPictureFromFlickr
//
//  Created by Jullia Sharaeva on 23.05.17.
//  Copyright © 2017 Julia Sharaeva. All rights reserved.
//

#import "NSCacheSingleton.h"
#import <UIKit/UIKit.h>

@implementation NSCacheSingleton
+ (instancetype) sharedCache{
    static NSCacheSingleton *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[NSCacheSingleton alloc] init];
    });
    return sharedInstance;
}

- (id) init{
    self = [super init];
    if (self){
        _imageCache = [[NSCache alloc] init];
    }
    return self;
}

@end
