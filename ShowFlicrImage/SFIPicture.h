//
//  SFIPicture.h
//  ShowFlicrImage
//
//  Created by Jullia Sharaeva on 28.05.17.
//  Copyright © 2017 Julia Sharaeva. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFIPicture : NSObject
@property (nonatomic, strong) NSURL *url;
@property (nonatomic) int *countOfFav;
@end
