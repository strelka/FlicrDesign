//
//  SPFDispetcherOperation.h
//  ShowFlicrImage
//
//  Created by Jullia Sharaeva on 30.05.17.
//  Copyright © 2017 Julia Sharaeva. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SPFPicture;

@interface SPFDispetcherOperation : NSOperation
- (instancetype) initWithPictures:(NSArray<SPFPicture*>*)array;

@end
