//
//  SPFGetCommentsOperation.h
//  ShowFlicrImage
//
//  Created by Jullia Sharaeva on 02.06.17.
//  Copyright © 2017 Julia Sharaeva. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SPFComment;

@interface SPFGetCommentsOperation : NSOperation
- (instancetype) initCommentForImageId:(NSString*) imgId AndComplition:(void(^)(NSArray<SPFComment*>* results)) block;
@end
