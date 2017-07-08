//
//  SPFGetListOfPicturesOperation.m
//  ShowFlicrImage
//
//  Created by Jullia Sharaeva on 29.05.17.
//  Copyright © 2017 Julia Sharaeva. All rights reserved.
//

#import "SPFGetListOfPicturesOperation.h"
#import "SPFPicture.h"
@interface SPFGetListOfPicturesOperation()
@property(nonatomic, strong) NSString* text4Search;
@property(nonatomic) int page;
@property(nonatomic, strong) NSURL* url;
@end

@implementation SPFGetListOfPicturesOperation
- (instancetype) initWithSearch:(NSString*)text andPage:(int)page{
    self = [super init];
    if (self){
        _page = page;
        _text4Search = text;
    }
    return self;
}

- (void) main {
    if (self.isCancelled) return;
    _url = [self createURL];
    [[self createDataTask] resume];
    if (self.isCancelled) return;
}

- (NSURLSessionDataTask*) createDataTask{
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];    
    NSURLSessionDataTask *task = [session dataTaskWithURL:_url];
    return task;
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
   didReceiveData:(NSData *)data {
    
    SPFPicture*(^createPicture)(NSDictionary *json);
    createPicture = ^SPFPicture*(NSDictionary* json){
        
        NSString *rec = [[NSString alloc] initWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@.jpg",   json[@"farm"],
            json[@"server"],
            json[@"id"],
            json[@"secret"]];
        NSString *url = [rec stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        SPFPicture *record = [[SPFPicture alloc] initWithUrl:[[NSURL alloc]initWithString:url]];
        record.idImg = json[@"id"];
        return record;
    };
    NSMutableData *downloadedData = [[NSMutableData alloc] init];
    [downloadedData appendData:data];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:downloadedData options:0 error:nil];
    NSDictionary *jsonRecords = json[@"photos"][@"photo"];
    
    if (jsonRecords){
        for (NSDictionary* recordItem in jsonRecords){
            [_pictures addObject:createPicture(recordItem)];
        }
        self.completionBlock();
    }
}

- (NSURL*) createURL{
    NSString *urlstr = @"https://api.flickr.com/services/rest/?";
    urlstr = [urlstr stringByAppendingString:@"method=flickr.photos.search&"];
    urlstr = [urlstr stringByAppendingFormat:@"text=%@&", _text4Search];
    urlstr = [urlstr stringByAppendingFormat:@"page=%d&", _page];
    urlstr = [urlstr stringByAppendingString:@"per_page=20&"];
    urlstr = [urlstr stringByAppendingString:@"api_key=c55f5a419863413f77af53764f86bd66&"];
    urlstr = [urlstr stringByAppendingString:@"format=json&"];
    urlstr = [urlstr stringByAppendingString:@"sort=interestingness-desc&"];
    urlstr = [urlstr stringByAppendingString:@"nojsoncallback=1"];
    NSURL *url = [NSURL URLWithString:urlstr];
    
    return url;
}

@end
