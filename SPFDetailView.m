//
//  SPFDetailView.m
//  ShowFlicrImage
//
//  Created by Jullia Sharaeva on 31.05.17.
//  Copyright © 2017 Julia Sharaeva. All rights reserved.
//

#import "SPFDetailView.h"
#import <Masonry/Masonry.h>
#import "UIColor+SPFColors.h"

@interface SPFDetailView()
@property(nonatomic, strong) UIView *descView;
@property(nonatomic, strong) UIView *likeView;

@end

@implementation SPFDetailView
{
    UIButton *likeBtn;
    UIImageView  *commentImgView;
    
}

- (instancetype) init{
    self = [super init];
    self.backgroundColor = [UIColor SPFBackgroundColor];
    if (self){
        [self addSubview:self.descView];
        
        [_descView addSubview:self.descLabel];
        
        [self addSubview:self.likeView];
        
        [_likeView addSubview:likeBtn];
        [_likeView addSubview:self.likeLabel];
        [_likeView addSubview:self.commentImgView];
        [_likeView addSubview:self.commentLabel];
        [self addSubview:self.commentTableView];
        
        [self initConstraints];
    }
    return self;
}

- (UIView*) descView{
    if (!_descView){
        _descView = [[UIView alloc] init];
    }
    return _descView;
}

- (UIView*)likeView{
    if (!_likeView){
        _likeView = [[UIView alloc] init];
        UIImage *imgForLikeBtn = [[UIImage imageNamed:@"btnLikeSuggestion"] imageWithRenderingMode:UIImageRenderingModeAutomatic];
        
        likeBtn = [[UIButton alloc] init];
        [likeBtn setImage:imgForLikeBtn forState:UIControlStateNormal];
        
    }
    return _likeView;
}

- (UIImageView*) commentImgView{
    if (!commentImgView){
        commentImgView = [[UIImageView alloc] init];
        UIImage *commentImg = [[UIImage imageNamed:@"fill984"] imageWithRenderingMode:UIImageRenderingModeAutomatic];
        commentImgView.image = commentImg;
    }
    return commentImgView;
}

- (UILabel*)likeLabel{
    if (!_likeLabel){
        _likeLabel = [[UILabel alloc] init];
        _likeLabel.font = [UIFont systemFontOfSize:14];
        _likeLabel.textColor = [UIColor SPFFontColor];
        _likeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _likeLabel;
}

- (UILabel*)commentLabel{
    if (!_commentLabel){
        _commentLabel = [[UILabel alloc] init];
        _commentLabel.font = [UIFont systemFontOfSize:14];
        _commentLabel.textColor = [UIColor SPFFontColor];
        _commentLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _commentLabel;
}


- (UILabel*)descLabel{
    if (!_descLabel){
        _descLabel = [[UILabel alloc] init];
        _descLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _descLabel.font = [UIFont systemFontOfSize:14];
        _descLabel.textColor = [UIColor SPFFontColor];
        _descLabel.numberOfLines = 0;
        [_descLabel sizeToFit];
        _descLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _descLabel;
}

- (UITableView*)commentTableView{
    if (!_commentTableView){
        _commentTableView = [[UITableView alloc] init];
        _commentTableView.rowHeight = 60;
        _commentTableView.backgroundView.backgroundColor = [UIColor clearColor];
        _commentTableView.backgroundColor = [UIColor clearColor];
    }
    return _commentTableView;
}


- (void)initConstraints{
    [_descView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@62);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
    }];
    
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@40);
        make.left.equalTo(_descView.mas_left).with.offset(16);
        make.right.equalTo(_descView.mas_right).with.offset(-16);
        make.top.equalTo(_descView.mas_top).with.offset(10);
        make.bottom.equalTo(_descView.mas_bottom).with.offset(-12);
    }];
    
    [_likeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@62);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.descView.mas_bottom);
    }];
    
    [likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(16);
        make.right.equalTo(self.mas_right).with.offset(-343.1);
        make.centerY.equalTo(_likeView.mas_centerY);
    }];
    
    [_likeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(39);
        make.centerY.equalTo(_likeView.mas_centerY);
        make.height.equalTo(@17);
        make.width.equalTo(@67);
    }];
    
    [commentImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(122.3);
        make.centerY.equalTo(_likeView.mas_centerY);
        make.height.equalTo(@15);
        make.width.equalTo(@18);
    }];
    
    [_commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(146.3);
        make.centerY.equalTo(_likeView.mas_centerY);
        make.height.equalTo(@17);
        make.width.equalTo(@119);
    }];
    
    [_commentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_likeView.mas_bottom);
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
    }];
    
}
@end
