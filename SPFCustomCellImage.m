//
//  SPFCustomCellImage.m
//  ShowFlicrImage
//
//  Created by Jullia Sharaeva on 31.05.17.
//  Copyright © 2017 Julia Sharaeva. All rights reserved.
//

#import "SPFCustomCellImage.h"

@implementation SPFCustomCellImage


- (instancetype) init{
    self = [super initWithFrame:CGRectMake(0, 0, 375, 667)];
    if (self){
        [self.contentView addSubview:self.imageView];
    }
    return self;
    
}

- (UIImageView *)imageView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        _imgView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    return _imgView;
}

@end
