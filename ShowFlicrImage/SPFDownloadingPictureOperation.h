//
//  SPFGetPictureOperation.h
//  ShowPictureFromFlickr
//
//  Created by Jullia Sharaeva on 20.05.17.
//  Copyright © 2017 Julia Sharaeva. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface SPFDownloadingPictureOperation : NSOperation<NSURLSessionDelegate>

- (instancetype) initWithUrl:(NSURL*)url andComplition:(void(^)()) block;
@end
