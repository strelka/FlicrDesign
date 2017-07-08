//
//  PendingOperations.h
//  ShowPictureFromFlickr
//
//  Created by Jullia Sharaeva on 20.05.17.
//  Copyright © 2017 Julia Sharaeva. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPFPendingOperations : NSObject
@property (strong, nonatomic) NSMutableDictionary<NSIndexPath*,NSOperation*> *downloadsInProgress;
@property (strong, nonatomic) NSMutableDictionary<NSIndexPath*,NSOperation*> * filtrationInProgress;
@property (strong, nonatomic) NSOperationQueue *getListImageQueue;
@property (strong, nonatomic) NSOperationQueue *downloadQueue;
@property (strong, nonatomic) NSOperationQueue *detailInfoQueue;
@end
