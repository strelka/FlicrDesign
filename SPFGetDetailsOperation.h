//
//  SPFGetDetailsOperation.h
//  ShowFlicrImage
//
//  Created by Jullia Sharaeva on 02.06.17.
//  Copyright © 2017 Julia Sharaeva. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SPFPicture;

@interface SPFGetDetailsOperation : NSOperation

- (instancetype) initDetailsForImage:(SPFPicture*)picture AndComplition:(void(^)()) block;

@end
