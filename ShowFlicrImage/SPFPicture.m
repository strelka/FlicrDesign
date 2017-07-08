//
//  SPFPicture.m
//  ShowPictureFromFlickr
//
//  Created by Jullia Sharaeva on 20.05.17.
//  Copyright © 2017 Julia Sharaeva. All rights reserved.
//

#import "SPFPicture.h"
#import "NSURL+Caching.h"

@implementation SPFPicture

- (instancetype) initWithUrl:(NSURL*)url{
    self = [super init];
    if (self){
        _imgURL = url;
        _imageState = New;
        _countLikes = 0;
    }
    return self;
}

- (void) correctPictureState{
    if (self.imageState == Downloaded){
        if (nil == [_imgURL getImageFromCache]){
            self.imageState = New;
        }
    }
}

@end
