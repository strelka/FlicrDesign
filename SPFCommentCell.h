//
//  SPFCommentCell.h
//  ShowFlicrImage
//
//  Created by Jullia Sharaeva on 02.06.17.
//  Copyright © 2017 Julia Sharaeva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPFCommentCell : UITableViewCell
@property(nonatomic, strong) UIImageView *imgView;
@property(nonatomic, strong) UILabel *authorLabel;
@property(nonatomic, strong) UILabel *commentLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end
