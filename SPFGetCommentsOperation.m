//
//  SPFGetCommentsOperation.m
//  ShowFlicrImage
//
//  Created by Jullia Sharaeva on 02.06.17.
//  Copyright © 2017 Julia Sharaeva. All rights reserved.
//

#import "SPFGetCommentsOperation.h"
#import "SPFComment.h"
#import "SPFUser.h"

@interface SPFGetCommentsOperation()
@property (nonatomic, strong) NSString *imgId;
@property (nonatomic, copy) void(^successBlock)(NSArray<SPFComment*>* results);
@end;


@implementation SPFGetCommentsOperation
- (instancetype) initCommentForImageId:(NSString*)imgId AndComplition:(void(^)(NSArray<SPFComment*>* results)) block{
    self = [super init];
    if (self){
        _imgId = imgId;
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
    
    SPFComment*(^createComment)(NSDictionary *json);
    createComment = ^SPFComment*(NSDictionary* json){
        SPFUser *user = [[SPFUser alloc] init];
        SPFComment *record = [[SPFComment alloc] init];
        
        NSString *rec = [[NSString alloc] initWithFormat:@"http://farm%@.staticflickr.com/%@/buddyicons/%@.jpg",
                         json[@"iconfarm"],
                         json[@"iconserver"],
                         json[@"author"]];
        
        NSString *url = [rec stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        user.userName = json[@"authorname"];
        user.avatarImgUrl = [[NSURL alloc] initWithString:url];
        
        record.content = json[@"_content"];
        record.author = user;
        return record;
    };

    NSMutableArray<SPFComment*> *results = [[NSMutableArray alloc] init];
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
    NSURLSessionDataTask *task = [session dataTaskWithURL:[self createURL] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            NSDictionary *commentRecords = json[@"comments"][@"comment"];
            if (commentRecords){
                for (NSDictionary* commentItem in commentRecords){
                    [results addObject:createComment(commentItem)];
                }
            }
        }
        _successBlock(results);
    }];
    
    return task;
}


- (NSURL*) createURL{
    NSString *urlstr = @"https://api.flickr.com/services/rest/?";
    urlstr = [urlstr stringByAppendingString:@"method=flickr.photos.comments.getList&"];
    urlstr = [urlstr stringByAppendingFormat:@"photo_id=%@&", _imgId];
    urlstr = [urlstr stringByAppendingString:@"api_key=c55f5a419863413f77af53764f86bd66&"];
    urlstr = [urlstr stringByAppendingString:@"format=json&"];
    urlstr = [urlstr stringByAppendingString:@"nojsoncallback=1"];
    NSURL *url = [NSURL URLWithString:urlstr];
    
    return url;
}



@end
