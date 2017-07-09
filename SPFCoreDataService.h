//
//  SPFCoreDataService.h
//  ShowFlicrImage
//
//  Created by Jullia Sharaeva on 06.07.17.
//  Copyright © 2017 Julia Sharaeva. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreData;
@class SPFPicture;
@class SPFPictureModel;

typedef void(^block) (NSArray *);
@interface SPFCoreDataService : NSObject
- (void)getFavoritePicturesWithCompletionBlock:(block) block;
- (void)setPictureToFavorite:(SPFPicture *) picture;
- (NSString *)getPathForSavingImage:(NSString *)imgId;
- (void)removePicturesFromFavorite:(NSArray<NSString *> *)picturesId;
@end
