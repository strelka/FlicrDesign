//  SPFTopNavigationView.m
//  ShowFlicrImage
//
//  Created by Jullia Sharaeva on 01.06.17.
//  Copyright © 2017 Julia Sharaeva. All rights reserved.
//

#import "SPFTopNavigationView.h"
#import "UIColor+SPFColors.h"
#import <Masonry/Masonry.h>

@implementation SPFTopNavigationView{
    UIImageView *avatarImg;
    UILabel *authorLabel;
    UILabel *geoLabel;
    UIImageView *geoImg;
}
- (instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self addSubview:self.avatarImg];
        [self addSubview:self.authorLabel];
        [self addSubview:self.geoLabel];
        [self addSubview:self.geoImg];
        [self initConstraints];
    }
    return self;
}

- (UIImageView *) avatarImg{
    if (!avatarImg){
        avatarImg = [[UIImageView alloc] init];
    }
    return avatarImg;
}

- (UILabel*) authorLabel{
    if (!authorLabel){
        authorLabel = [[UILabel alloc] init];
        authorLabel.font = [UIFont systemFontOfSize:14];
        authorLabel.textColor = [UIColor blackColor];
        authorLabel.textAlignment = NSTextAlignmentLeft;
    }
    return authorLabel;
}

- (UILabel*) geoLabel{
    if (!geoLabel){
        geoLabel = [[UILabel alloc] init];
        geoLabel.font = [UIFont systemFontOfSize:13];
        geoLabel.textColor = [UIColor SPFFontColor];
        geoLabel.textAlignment = NSTextAlignmentLeft;
    }
    return geoLabel;
}

- (UIImageView*) geoImg{
    if (!geoImg){
        geoImg = [[UIImageView alloc] init];
        geoImg.image = [UIImage imageNamed:@"fill2800"];
    }
    return geoImg;
}

- (void) initConstraints{
    
    [avatarImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@32);
        make.width.equalTo(@32);
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.mas_top);
    }];
    
    [authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@16);
        make.left.equalTo(avatarImg.mas_right).with.offset(16);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
    }];
    
    [geoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@8);
        make.width.equalTo(@8);
        make.left.equalTo(avatarImg.mas_right).with.offset(16);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    [geoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@15);
        make.right.equalTo(self.mas_right);
        make.left.equalTo(geoImg.mas_right).with.offset(4);
        make.bottom.equalTo(self.mas_bottom);
    }];

}
- (void) setAuthor:(NSString*)author AndLocation:(NSString*)location{
    authorLabel.text = author;
    geoLabel.text = location;
}

- (void) setAvatarImage:(UIImage*)image{
    avatarImg.image  = image;
    avatarImg.layer.cornerRadius = 16;
    avatarImg.clipsToBounds = YES;
}

@end
