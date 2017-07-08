//
//  SFIGetDataFromFlicr.h
//  ShowFlicrImage
//
//  Created by Jullia Sharaeva on 28.05.17.
//  Copyright © 2017 Julia Sharaeva. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFIGetDataFromFlicr : NSObject
- (void) getPicturesListByName:(NSString*)name WithComplitionBlock:(void(^)(NSArray* data)) block;
@end
