//
//  SPFGetFavoriteCountOperation.m
//  ShowFlicrImage
//
//  Created by Jullia Sharaeva on 29.05.17.
//  Copyright © 2017 Julia Sharaeva. All rights reserved.
//

#import "SPFGetFavoriteCountOperation.h"
#import "SPFPicture.h"
@interface SPFGetFavoriteCountOperation()
@property(nonatomic, strong) SPFPicture *picture;
@property(nonatomic, strong) NSURL *url;

@property(nonatomic, strong) void(^successBlock)();

@end

@implementation SPFGetFavoriteCountOperation

-(instancetype) initWithPicture:(SPFPicture*)pic AndComplitionBlok:(void(^)()) block{
    self = [super init];
    if (self){
        _picture = pic;
        _successBlock = block;
    }
    return self;

}

- (void) main{
    
    if (self.isCancelled) return;
    _url = [self createURL];
    [[self createDataTask] resume];
    if (self.isCancelled) return;
}

- (NSURLSessionDataTask*) createDataTask{
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
    NSURLSessionDataTask *task = [session dataTaskWithURL:_url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            NSDictionary *photoRecord = json[@"photo"];
            _picture.countLikes = [photoRecord[@"total"] intValue];
            
            NSLog(@"%@", _picture.idImg);
            NSLog(@"%d", _picture.countLikes);
         }
        _successBlock();
    }];
    
    return task;
}

- (NSURL*) createURL{
    NSString *urlstr = @"https://api.flickr.com/services/rest/?";
    urlstr = [urlstr stringByAppendingString:@"method=flickr.photos.getFavorites&"];
    urlstr = [urlstr stringByAppendingFormat:@"page=%d&", 1];
    urlstr = [urlstr stringByAppendingString:@"per_page=1&"];
    urlstr = [urlstr stringByAppendingFormat:@"photo_id=%@&",_picture.idImg];
    urlstr = [urlstr stringByAppendingString:@"api_key=c55f5a419863413f77af53764f86bd66&"];
    urlstr = [urlstr stringByAppendingString:@"format=json&"];
    urlstr = [urlstr stringByAppendingString:@"nojsoncallback=1"];
    NSURL *url = [NSURL URLWithString:urlstr];
    return url;
}


@end
