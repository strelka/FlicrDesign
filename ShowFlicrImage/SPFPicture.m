//
//  SPFPicture.m
//  ShowPictureFromFlickr
//
//  Created by Jullia Sharaeva on 20.05.17.
//  Copyright © 2017 Julia Sharaeva. All rights reserved.
//

#import "SPFPicture.h"
#import "NSURL+Caching.h"

static NSString *const urlTemplate = @"https://farm%@.staticflickr.com/%@/%@_%@.jpg";
@implementation SPFPicture

- (instancetype) initWithJSONData:(NSDictionary *)json{
    self = [super init];
    if (self){
        _idImg = json[@"id"];
        _imgURL = [self generateURL:json];
        _imageState = New;
        _countLikes = 0;
    }
    return self;
}


- (NSURL *)generateURL:(NSDictionary *)json{
    NSString *urlString = [[NSString alloc] initWithFormat: urlTemplate, json[@"farm"], json[@"server"], json[@"id"], json[@"secret"]];
    
    NSString *normalUrlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    return [[NSURL alloc] initWithString:normalUrlString];
}

- (void) correctPictureState{
    if (self.imageState == Downloaded){
        if (nil == [_imgURL getImageFromCache]){
            self.imageState = New;
        }
    }
}

@end
