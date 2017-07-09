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
@property (nonatomic, strong) NSMutableArray <SPFPictureModel *> *pictures;
@property (nonatomic, strong) NSMutableArray <NSString *> *deletedPictures;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UINavigationBar *navBar;
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

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self removePicturesFromStorage];
    
    
}
- (void) removePicturesFromStorage{
    [self.storageService removePicturesFromFavorite:self.deletedPictures];
    [self editing];
}
- (void) startAsyncFetch{
    [self.storageService getFavoritePicturesWithCompletionBlock:^(NSArray *result){
        self.pictures = [result mutableCopy];
        [self.tableView reloadData];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pictures = [NSMutableArray new];
    self.deletedPictures = [NSMutableArray new];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.navBar];
    [self initConstraints];
}

- (UINavigationBar *)navBar{
    if (!_navBar){
        _navBar = [UINavigationBar new];
        _navBar.backgroundColor = UIColor.lightGrayColor;
        _navBar.items = [self configureNavBarItems];
    }
    return _navBar;

}

- (NSArray<UINavigationItem*>*) configureNavBarItems{
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                              target:self
                                                                              action:@selector(editing)];
    UINavigationItem *navItem = [UINavigationItem new];
    navItem.rightBarButtonItem = editItem;
    return @[navItem];
}

- (UITableView *) tableView{
    if (!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.allowsSelectionDuringEditing=NO;
        
       [_tableView registerClass:[SPFFavoriteCell class] forCellReuseIdentifier:NSStringFromClass([SPFFavoriteCell class])];
    }
    return _tableView;
}

- (void) initConstraints{
    [self.navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.height.equalTo(@50);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.navBar.mas_bottom);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
    }];
}

- (SPFFavoriteCell *)configureCell:(SPFFavoriteCell *) cell WithPicture:(SPFPictureModel *)picture{
    
    cell.textDescription.text = picture.desc;
    NSString *path = [self.storageService getPathForSavingImage:picture.idImg];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    UIImage *cropImage = [image imageByCroppingImage];
    cell.imgView.image = cropImage;
    return cell;
}

- (void) editing{
    [self.tableView setEditing:!self.tableView.editing animated:YES];
}


#pragma - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.pictures.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SPFFavoriteCell *cell = [[SPFFavoriteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([SPFFavoriteCell class])];
    
    SPFPictureModel *pictureModel = self.pictures[indexPath.row];
    cell = [self configureCell:(SPFFavoriteCell *)cell WithPicture:pictureModel];
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete){
        [tableView beginUpdates];
        [self.deletedPictures addObject:self.pictures[indexPath.row].idImg];
        [self.pictures removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
        
        [tableView endUpdates];
    }
}

#pragma - UITableViewDelegate
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return rowHeight;
}
@end
