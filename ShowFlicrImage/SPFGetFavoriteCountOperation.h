//
//  SPFGetFavoriteCountOperation.h
//  ShowFlicrImage
//
//  Created by Jullia Sharaeva on 29.05.17.
//  Copyright © 2017 Julia Sharaeva. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SPFPicture;

@interface SPFGetFavoriteCountOperation : NSOperation
-(instancetype) initWithPicture:(SPFPicture*)pic AndComplitionBlok:(void(^)()) block;
@end
