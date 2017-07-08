//
//  SPFDetailView.h
//  ShowFlicrImage
//
//  Created by Jullia Sharaeva on 31.05.17.
//  Copyright © 2017 Julia Sharaeva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIFont.h>

@interface SPFDetailView : UIView
@property(nonatomic, strong) UITableView *commentTableView;
@property(nonatomic, strong) UILabel *descLabel;
@property(nonatomic, strong) UILabel  *likeLabel;
@property(nonatomic, strong) UILabel  *commentLabel;

@end
