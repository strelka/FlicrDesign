//
//  SPFGetDetailsOperation.m
//  ShowFlicrImage
//
//  Created by Jullia Sharaeva on 02.06.17.
//  Copyright © 2017 Julia Sharaeva. All rights reserved.
//

#import "SPFGetDetailsOperation.h"
#import "SPFPicture.h"
#import "SPFUser.h"

@interface SPFGetDetailsOperation()
@property (nonatomic, strong) SPFPicture *picture;
@property (nonatomic, copy) void(^successBlock)();

//@property (nonatomic) dispatch_semaphore_t sem;
@end;

@implementation SPFGetDetailsOperation
- (instancetype) initDetailsForImage:(SPFPicture*)picture AndComplition:(void(^)()) block{
    self = [super init];
    if (self){
        _picture = picture;
        _successBlock = block;
    }
    return self;
}

- (void) main{
    if (self.isCancelled) return;
    [[self createDataTask] resume];
    if (self.isCancelled) return;
}

- (NSURLSessionDataTask*) createDataTask{
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
    NSURLSessionDataTask *task = [session dataTaskWithURL:[self createURL] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            NSDictionary *detailRecord = json[@"photo"];
            if (detailRecord){
                [self parseOwner:detailRecord[@"owner"]];
                [self parseDetails:detailRecord];
            }
        }
        _successBlock();
    }];
    
    return task;
}

- (void) parseOwner:(NSDictionary*)json{
    NSString *rec = [[NSString alloc] initWithFormat:@"http://farm%@.staticflickr.com/%@/buddyicons/%@.jpg",
                     json[@"iconfarm"],
                     json[@"iconserver"],
                     json[@"nsid"]];
    
    NSString *url = [rec stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    SPFUser *author = [[SPFUser alloc] init];
    
    author.avatarImgUrl = [[NSURL alloc] initWithString:url];
    author.userName = json[@"username"];
    author.userLocation = json[@"location"];
    
    _picture.owner = author;

}

- (void) parseDetails:(NSDictionary*) json{
    _picture.desc = json[@"description"][@"_content"];
    _picture.countViews = [json[@"views"] intValue];
    _picture.countComments = [json[@"comments"][@"_content"] intValue];
}

- (NSURL*) createURL{
    NSString *urlstr = @"https://api.flickr.com/services/rest/?";
    urlstr = [urlstr stringByAppendingString:@"method=flickr.photos.getInfo&"];
    urlstr = [urlstr stringByAppendingFormat:@"photo_id=%@&", _picture.idImg];
    urlstr = [urlstr stringByAppendingString:@"api_key=c55f5a419863413f77af53764f86bd66&"];
    urlstr = [urlstr stringByAppendingString:@"format=json&"];
    urlstr = [urlstr stringByAppendingString:@"nojsoncallback=1"];
    NSURL *url = [NSURL URLWithString:urlstr];
    
    return url;
}

@end
