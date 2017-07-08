//
//  SPFGetListOfPicturesOperation.h
//  ShowFlicrImage
//
//  Created by Jullia Sharaeva on 29.05.17.
//  Copyright © 2017 Julia Sharaeva. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SPFPicture;

@interface SPFGetListOfPicturesOperation : NSOperation<NSURLSessionDataDelegate>
@property(nonatomic, strong) NSMutableArray<SPFPicture*> *pictures;
- (instancetype) initWithSearch:(NSString*)text andPage:(int)page;
@end
