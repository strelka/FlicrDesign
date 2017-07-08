//
//  SPFCommentCell.m
//  ShowFlicrImage
//
//  Created by Jullia Sharaeva on 02.06.17.
//  Copyright © 2017 Julia Sharaeva. All rights reserved.
//

#import "SPFCommentCell.h"
#import "UIColor+SPFColors.h"
#import <Masonry/Masonry.h>

//NSString *const SPFCellIdentifier = @"SPFCellCommentIdentifier";

@implementation SPFCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        [self addSubview:self.imgView];
        [self addSubview:self.authorLabel];
        [self addSubview:self.commentLabel];
        [self initConstraints];
    }
    return self;
}

- (void) initConstraints{
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(16);
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(@38);
        make.width.equalTo(@38);
    }];
    
    [_authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imgView.mas_right).with.offset(19);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@17);
        make.bottom.equalTo(self.mas_centerY);
    }];
    
    [_commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imgView.mas_right).with.offset(19);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@16);
        make.top.equalTo(self.mas_centerY);
    }];
}
- (UIImageView *) imgView{
    if (!_imgView){
        _imgView = [[UIImageView alloc] init];
        //_imgView.contentMode = UIViewContentModeScaleAspectFill;
        //_imgView.backgroundColor = [UIColor blueColor];
    }
    return _imgView;
}

- (UILabel*) authorLabel{
    if (!_authorLabel){
        _authorLabel = [[UILabel alloc] init];
        _authorLabel.font = [UIFont systemFontOfSize:14];
        _authorLabel.textColor = [UIColor blackColor];
        _authorLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _authorLabel;
}

- (UILabel*) commentLabel{
    if (!_commentLabel){
        _commentLabel = [[UILabel alloc] init];
        _commentLabel.font = [UIFont systemFontOfSize:13];
        _commentLabel.textColor = [UIColor SPFFontColor];
        _authorLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _commentLabel;
}

//- (void) setImageToImageView:(UIImage*)image{
//    _imgView.image = image;
//    _imgView.layer.cornerRadius = 19;
//    _imgView.layer.masksToBounds = YES;
//    
//
//}





@end
