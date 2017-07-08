//
//  PendingOperations.m
//  ShowPictureFromFlickr
//
//  Created by Jullia Sharaeva on 20.05.17.
//  Copyright © 2017 Julia Sharaeva. All rights reserved.
//

#import "SPFPendingOperations.h"

@implementation SPFPendingOperations

- (NSOperationQueue *)downloadQueue{
    self.downloadQueue = [[NSOperationQueue alloc] init];
    _downloadQueue.name = @"Download queue";
    _downloadQueue.maxConcurrentOperationCount = 3;
    return _downloadQueue;
}

- (NSOperationQueue *)getListQueue{
    self.getListImageQueue = [[NSOperationQueue alloc] init];
    _getListImageQueue.name = @"Image List Queue";
    _getListImageQueue.maxConcurrentOperationCount = 3;
    return _getListImageQueue;
}

- (NSOperationQueue *)getDetailInformationQueue{
    self.detailInfoQueue = [[NSOperationQueue alloc] init];
    _detailInfoQueue.name = @"Image Detail Information Queue";
    _detailInfoQueue.maxConcurrentOperationCount = 3;
    return _detailInfoQueue;
}

@end
