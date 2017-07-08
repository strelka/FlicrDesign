//
//  SPFGetDetailInfo.m
//  ShowFlicrImage
//
//  Created by Jullia Sharaeva on 31.05.17.
//  Copyright © 2017 Julia Sharaeva. All rights reserved.
//

#import "SPFGetDetailInfo.h"
@class SPFPicture;
@interface SPFGetDetailInfo()
@property (nonatomic, strong) SPFPicture* picture;
@property (nonatomic, strong) NSOperationQueue *queue;
@end
@implementation SPFGetDetailInfo
- (instancetype) initWithPicture:(SPFPicture*) pic{
    self = [super init];
    if (self){
        _picture = pic;
        _queue = [[NSOperationQueue alloc] init];
        _queue.maxConcurrentOperationCount = 3;
        _queue.name = @"Detail info";
    }
    return self;



}



@end
