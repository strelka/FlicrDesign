//
//  SecondViewController.m
//  ShowFlicrImage
//
//  Created by Jullia Sharaeva on 27.05.17.
//  Copyright © 2017 Julia Sharaeva. All rights reserved.
//

#import "SecondViewController.h"
#import "SPFPictureModel.h"
#import "SPFCoreDataService.h"
#import "SPFFavoriteCell.h"
#import "UIImage+CroppingImage.h"
#import <Masonry/Masonry.h>

const CGFloat rowHeight = 100;

@interface SecondViewController()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) SPFCoreDataService *storageService;
@property (nonatomic, strong) NSArray <SPFPictureModel *> *pictures;
@property (nonatomic, strong) UITableView *tableView;
@end
@implementation SecondViewController

- (instancetype) initWithStorageService:(SPFCoreDataService *) service{
    self = [super init];
    if (self){
        _storageService = service;
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Избранное"
                                                        image:[[UIImage imageNamed:@"icLikes"] imageWithRenderingMode:UIImageRenderingModeAutomatic]
                                                selectedImage:[[UIImage imageNamed:@"icLikes"] imageWithRenderingMode:UIImageRenderingModeAutomatic]];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self startAsyncFetch];
}

- (void) startAsyncFetch{
    [self.storageService getFavoritePicturesWithCompletionBlock:^(NSArray *result){
        [self setPictures:result];
        [self.tableView reloadData];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pictures = [NSArray new];
    [self.view addSubview:self.tableView];
    [self initConstraints];
}

- (UITableView *) tableView{
    if (!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
       [_tableView registerClass:[SPFFavoriteCell class] forCellReuseIdentifier:NSStringFromClass([SPFFavoriteCell class])];
    }
    return _tableView;
}

- (void) initConstraints{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.pictures.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = (SPFFavoriteCell *)[self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SPFFavoriteCell class]) forIndexPath:indexPath];
    
    if (cell == nil){
        cell = [[SPFFavoriteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([SPFFavoriteCell class])];
    }
    
    SPFPictureModel *pictureModel = self.pictures[indexPath.row];
    cell = [self configureCell:(SPFFavoriteCell *)cell WithPicture:pictureModel];
    return cell;
}

- (SPFFavoriteCell *)configureCell:(SPFFavoriteCell *) cell WithPicture:(SPFPictureModel *)picture{
    
    cell.textDescription.text = picture.desc;
    NSString *path = [self.storageService getPathForSavingImage:picture.idImg];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    UIImage *cropImage = [image imageByCroppingImage];
    cell.imgView.image = cropImage;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return rowHeight;
}


@end
