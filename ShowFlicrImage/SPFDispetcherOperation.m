//
//  SPFDispetcherOperation.m
//  ShowFlicrImage
//
//  Created by Jullia Sharaeva on 30.05.17.
//  Copyright © 2017 Julia Sharaeva. All rights reserved.
//

#import "SPFDispetcherOperation.h"
#import "SPFGetFavoriteCountOperation.h"

@class SPFPicture;
@interface SPFDispetcherOperation()
@property(nonatomic, strong) NSArray<SPFPicture*> *pictures;
@end
@implementation SPFDispetcherOperation
{
    dispatch_semaphore_t sem;
}
- (instancetype) initWithPictures:(NSArray<SPFPicture*>*)array{
    self = [super init];
    if (self){
        _pictures = array;
        
    }
    return self;
}

- (void) main {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    //queue.maxConcurrentOperationCount = 1;
    
    sem = dispatch_semaphore_create(0);
    
    for (SPFPicture *item in _pictures){
        SPFGetFavoriteCountOperation *op = [[SPFGetFavoriteCountOperation alloc] initWithPicture:item AndComplitionBlok:^{
            dispatch_semaphore_signal(sem);
        }];
        [queue addOperation:op];
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);

    }
}

@end
