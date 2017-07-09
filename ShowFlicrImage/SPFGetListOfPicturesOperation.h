//
//  SPFGetListOfPicturesOperation.h
//  ShowFlicrImage
//
//  Created by Jullia Sharaeva on 29.05.17.
//  Copyright © 2017 Julia Sharaeva. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SPFPicture;

typedef void(^successBlock) (NSArray *, NSError *);

@interface SPFGetListOfPicturesOperation : NSOperation<NSURLSessionDataDelegate>
- (instancetype) initWithSearch:(NSString*)text
                        andPage:(long)page
                       andBlock:(successBlock)successBlock;
@end
