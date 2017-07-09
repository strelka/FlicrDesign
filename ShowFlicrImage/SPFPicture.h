//
//  SPFPicture.h
//  ShowPictureFromFlickr
//
//  Created by Jullia Sharaeva on 20.05.17.
//  Copyright © 2017 Julia Sharaeva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class SPFUser;

typedef NS_ENUM(NSInteger, spfImageState){
    New = 1,
    Downloaded = 2,
    Failed = 4
};

@interface SPFPicture : NSObject

@property (nonatomic, strong) NSString *idImg;
@property (nonatomic, strong) NSURL *imgURL;
@property (nonatomic, strong) SPFUser *owner;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *locality;
@property (nonatomic, assign) int countLikes;
@property (nonatomic, assign) long countViews;
@property (nonatomic, assign) int countComments;


@property (nonatomic) spfImageState imageState;

- (instancetype) initWithJSONData:(NSDictionary *)json;
- (void) correctPictureState;
@end
