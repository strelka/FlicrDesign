//
//  SPFFavoriteCell.m
//  ShowFlicrImage
//
//  Created by Jullia Sharaeva on 08.07.17.
//  Copyright © 2017 Julia Sharaeva. All rights reserved.
//

#import "SPFFavoriteCell.h"
#import <Masonry/Masonry.h>

@implementation SPFFavoriteCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        [self addSubview:self.textDescription];
        [self addSubview:self.imgView];
        
        [self initConstraints];
    }
    return self;
}

- (UILabel*)textDescription{
    if (!_textDescription){
        _textDescription = [UILabel new];
        _textDescription.font = [UIFont systemFontOfSize:14];
        _textDescription.numberOfLines = 3;
        _textDescription.textAlignment = NSTextAlignmentLeft;
    }
    return _textDescription;
}

- (UIImageView *)imgView{
    if (!_imgView){
        _imgView = [UIImageView new];
        //_imgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imgView;

}

- (void) initConstraints{
   [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.equalTo(self.mas_left);
       make.top.equalTo(self.mas_top);
       make.bottom.equalTo(self.mas_bottom);
       make.width.equalTo(self.mas_height);
   }];

    [self.textDescription mas_makeConstraints:^(MASConstraintMaker *make) {
       make.right.equalTo(self.mas_right);
       make.left.equalTo(self.imgView.mas_right).with.offset(10);
       make.top.equalTo(self.mas_top);
       make.bottom.equalTo(self.mas_bottom);
   }];
}

- (void) prepareForReuse{
    self.imgView.image = nil;
}
@end
