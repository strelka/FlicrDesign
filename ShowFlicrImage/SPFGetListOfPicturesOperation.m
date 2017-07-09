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
@property(nonatomic, strong) NSURL* url;
@property(nonatomic, copy) successBlock successBlock;
@property(nonatomic, assign) long page;
@property(nonatomic, strong) NSArray<SPFPicture*> *pictures;
@end

@implementation SPFGetListOfPicturesOperation

- (instancetype) initWithSearch:(NSString*)text
                        andPage:(long)page
                  andBlock:(successBlock)successBlock{
    self = [super init];
    if (self){
        _page = page;
        _text4Search = [text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        _successBlock = successBlock;
    }
    return self;
}

- (void) main {
    if (self.isCancelled) return;
    [[self createDataTask] resume];
    if (self.isCancelled) return;
}

- (NSURLSessionDataTask*) createDataTask{
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];    
    NSURLSessionDataTask *task = [session dataTaskWithURL:self.url];
    return task;
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
   didReceiveData:(NSData *)data {
    
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    NSDictionary *jsonItems = json[@"photos"][@"photo"];
    NSMutableArray *tmpPictures = [NSMutableArray new];
    
    if (jsonItems){
        for (NSDictionary* jsonItem in jsonItems){
            SPFPicture *picture = [[SPFPicture alloc] initWithJSONData:jsonItem];
            [tmpPictures addObject:picture];
        }
    }
    self.pictures = [[NSArray alloc] initWithArray:tmpPictures];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.successBlock(self.pictures, error);
    });
}

- (NSURL*) url{
    if (!_url){
        NSString *urlstr = @"https://api.flickr.com/services/rest/?";
        urlstr = [urlstr stringByAppendingString:@"method=flickr.photos.search&"];
        urlstr = [urlstr stringByAppendingFormat:@"text=%@&", self.text4Search];
        urlstr = [urlstr stringByAppendingFormat:@"page=%ld&", self.page];
        urlstr = [urlstr stringByAppendingString:@"per_page=5&"];
        urlstr = [urlstr stringByAppendingString:@"api_key=c55f5a419863413f77af53764f86bd66&"];
        urlstr = [urlstr stringByAppendingString:@"format=json&"];
        urlstr = [urlstr stringByAppendingString:@"sort=interestingness-desc&"];
        urlstr = [urlstr stringByAppendingString:@"nojsoncallback=1"];
        _url = [NSURL URLWithString:urlstr];
    }
    return _url;
}

@end
