//
//  SPFImgOwner.h
//  ShowFlicrImage
//
//  Created by Jullia Sharaeva on 02.06.17.
//  Copyright © 2017 Julia Sharaeva. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPFUser : NSObject
@property(nonatomic, strong) NSString *userName;
@property(nonatomic, strong) NSURL *avatarImgUrl;
@property(nonatomic, strong) NSString *userLocation;
@end
