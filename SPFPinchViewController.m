//
//  SPFPinchViewController.m
//  ShowFlicrImage
//
//  Created by Jullia Sharaeva on 04.06.17.
//  Copyright © 2017 Julia Sharaeva. All rights reserved.
//

#import "SPFPinchViewController.h"
#import <Masonry/Masonry.h>

@interface SPFPinchViewController ()
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIImage *img;

@end

@implementation SPFPinchViewController

- (instancetype) initWithImage:(UIImage *)img{
    self = [super init];
    if (self){
        _img = img;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imgView = [[UIImageView alloc] init];
    _imgView.image = _img;
    _imgView.contentMode = UIViewContentModeScaleAspectFill;
    _imgView.clipsToBounds = YES;
    
    _imgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissModalController)];
    [_imgView addGestureRecognizer:singleTap];
    
    [self.view addSubview:_imgView];
    [self initConstrains];
}

- (void) initConstrains{
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top).with.offset(65);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-250);
    }];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissModalController{
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
