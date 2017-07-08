//
//  SPFFiltrationImageOperation.m
//  ShowPictureFromFlickr
//
//  Created by Jullia Sharaeva on 20.05.17.
//  Copyright © 2017 Julia Sharaeva. All rights reserved.
//

#import "SPFFiltrationPictureOperation.h"
#import "SPFPicture.h"

@implementation SPFFiltrationPictureOperation
- (instancetype) initWithSPFPicture:(SPFPicture*)pic{
    self = [super init];
    if (self){
        _photoRecord = pic;
    }
    return self;
}


- (void) main{
    if (self.isCancelled) return;
    
    if (_photoRecord.imageState != Downloaded){
        return;
    }
    
    //UIImage *filteredImage = [self applyFilterForImage:[_photoRecord getImageFromCacheByUrl]];
//    if (filteredImage) {
//        self.photoRecord.imageState = Filtered;
//        //[_photoRecord cachingFiltererPicture:filteredImage];
//    }
}

- (UIImage *)applyFilterForImage:(UIImage*)image{
    CIImage *ciiImage = [[CIImage alloc] initWithImage:image];
    if (self.isCancelled) return nil;
    CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone"
                                  keysAndValues:kCIInputImageKey, ciiImage, @"inputIntensity", @0.8, nil];
    CIImage *outputImage = [filter outputImage];
    if (self.isCancelled) return nil;
    UIImage *newImage = [UIImage imageWithCIImage:outputImage];
    return newImage;
}
@end
