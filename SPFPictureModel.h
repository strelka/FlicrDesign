//
//  SPFPictureModel.h
//  ShowFlicrImage
//
//  Created by Jullia Sharaeva on 06.07.17.
//  Copyright © 2017 Julia Sharaeva. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface SPFPictureModel : NSManagedObject
@property (nonatomic, strong) NSString *imgURL;
@property (nonatomic, strong) NSString *idImg;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *locality;
@property (nonatomic, strong) NSNumber *countLikes;
@property (nonatomic, strong) NSNumber *countViews;
@property (nonatomic, strong) NSNumber *countComments;
@property (nonatomic, strong) NSNumber *saveTimeInterval;
@end
