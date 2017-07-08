//
//  SPFCustomCell.m
//  ShowPictureFromFlickr
//
//  Created by Jullia Sharaeva on 20.05.17.
//  Copyright © 2017 Julia Sharaeva. All rights reserved.
//

#import "SPFCustomCell.h"

NSString *const SPFCellIdentifier = @"SPFCellIdentifier";

@implementation SPFCustomCell

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    return _imageView;
}

- (UIActivityIndicatorView *) spinner{
    if (!_spinner){
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_spinner startAnimating];
    }
    return _spinner;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.spinner];
        _spinner.center = self.contentView.center;
    }
    return self;
}

-(void)prepareForReuse {
    [super prepareForReuse];
    self.imageView.image = nil; //and etc.
    [_spinner startAnimating];
}

@end
