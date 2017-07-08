//
//  SPFGetPictureOperation.m
//  ShowPictureFromFlickr
//
//  Created by Jullia Sharaeva on 20.05.17.
//  Copyright © 2017 Julia Sharaeva. All rights reserved.
//

#import "SPFDownloadingPictureOperation.h"
#import "NSURL+Caching.h"

@interface SPFDownloadingPictureOperation()
@property(nonatomic, copy) void(^successBlock)();
@property(nonatomic, strong) NSURL *url;
@end
@implementation SPFDownloadingPictureOperation

- (instancetype) initWithUrl:(NSURL*)url andComplition:(void(^)()) block{
    self = [super init];
    if (self){
        _successBlock = block;
        _url = url;
    }
    return self;
}

- (void) main{
    if (![_url getImageFromCache]){
        [self startTaskGetImageFromURL:_url];
    } else {
        self.successBlock();
    }
}

- (void) startTaskGetImageFromURL:(NSURL*)url{
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *downloadSession = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
    NSURLSessionDownloadTask *task = [downloadSession downloadTaskWithURL:url];
    [task resume];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    if (self.isCancelled) return;
    NSData *imageData = [NSData dataWithContentsOfURL:location];
    [_url cachingImage:[[UIImage alloc] initWithData:imageData]];
    self.successBlock();
}

@end
