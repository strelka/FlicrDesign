//
//  SPFViewController.m
//  ShowPictureFromFlickr
//
//  Created by Jullia Sharaeva on 20.05.17.
//  Copyright © 2017 Julia Sharaeva. All rights reserved.
//

#import <Masonry/Masonry.h>


#import "SPFPicture.h"
#import "SPFViewController.h"
#import "SPFPendingOperations.h"
#import "SPFDownloadingPictureOperation.h"
#import "SPFGetListOfPicturesOperation.h"

#import "SPFCustomCell.h"
#import "SPFDetailViewController.h"

#import "PinterestLayout.h"
#import "NSURL+Caching.h"
#import "UIImage+CroppingImage.h"
#import "SPFCoreDataService.h"

#define CELL_INENTIFIER = @"cell"

@interface SPFViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate, SPFPinterestLayoutDelegate>

@property (nonatomic, strong) NSMutableDictionary *searchObject;
@property (nonatomic, strong) NSArray<SPFPicture*> *records;
@property (nonatomic, strong) SPFPendingOperations *operation;
@property (nonatomic, strong) id service;
@property (nonatomic, strong) UICollectionView* collectionView;

@property (nonatomic, strong) PinterestLayout *layout;
@property (nonatomic) CGSize size;


@property (nonatomic, strong) NSArray *cellSizes;
@property (nonatomic, strong) NSArray *colors;

@property (nonatomic, strong) NSString *searchText;
@property (nonatomic, strong) SPFCoreDataService *storageService;
@end

@implementation SPFViewController
{
    BOOL loadingNewPage;
}

- (instancetype) initWithStorageService:(SPFCoreDataService *) service{
    self = [super init];
    if (self){
        _storageService = service;
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Лента"
                                                        image:[[UIImage imageNamed:@"icFeed"] imageWithRenderingMode:UIImageRenderingModeAutomatic]
                                                selectedImage:[[UIImage imageNamed:@"icFeed"] imageWithRenderingMode: UIImageRenderingModeAutomatic]];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _size = self.view.bounds.size;
    _searchObject = [[NSMutableDictionary alloc] initWithObjects:@[@1, @""] forKeys:@[@"page", @"textForSearch"]];
    loadingNewPage = NO;
    
    _operation = [SPFPendingOperations new];
    
    _layout = [[PinterestLayout alloc] init];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:_layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    [_collectionView registerClass:[SPFCustomCell class]
        forCellWithReuseIdentifier:@"SPFCellIdentifier"];
    
    [self.view addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.delegate = self;
    searchBar.placeholder = @"Поиск";
    [searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"rectangle121"] forState:UIControlStateNormal];
    
    UIButton *settings = [[UIButton alloc] init];
    [settings setImage:[UIImage imageNamed:@"icSettings"] forState:UIControlStateNormal];
    
    self.navigationItem.titleView = searchBar;
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icSettings"] style:UIBarButtonItemStyleDone target:self action:nil];
    self.navigationItem.rightBarButtonItem = rightBtn;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return [_records count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SPFCustomCell *cell = (SPFCustomCell *)[collectionView dequeueReusableCellWithReuseIdentifier: @"SPFCellIdentifier" forIndexPath:indexPath];
    SPFPicture *photo = _records[indexPath.item];
    
    if (!(_operation.downloadsInProgress[indexPath])){
        [photo correctPictureState];
    }
    
    if (photo.imageState == New){
        [self startOPerationsForPhotoRecord:photo byIndex:indexPath];
        
    } else {
        UIImage *tmpImg = [photo.imgURL getImageFromCache];
        tmpImg = [tmpImg imageByCroppingImage];
        
        UIGraphicsBeginImageContext(CGSizeMake( cell.frame.size.width, cell.frame.size.height));
        [tmpImg drawInRect: CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
        UIImage *small = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        UIImageView *cellImageView = [[UIImageView alloc] initWithImage:small];
        cell.backgroundColor = [UIColor whiteColor];
        cell.clipsToBounds = YES;
        [cell.contentView addSubview:cellImageView];
    }
    return cell;
}

- (BOOL) isLargeItemInIndexPath:(NSIndexPath*)index{

    if (index.item % 4 == 0){
        return YES;
    }
    else return NO;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size;
    double width_step = self.collectionView.bounds.size.width/3;
    
    if ([self isLargeItemInIndexPath:indexPath]){
        size = CGSizeMake(width_step*2, width_step*2);
    } else{
        size = CGSizeMake(width_step, width_step);
    }
    return size;
}

- (void) startOPerationsForPhotoRecord:(SPFPicture*)pic byIndex:(NSIndexPath*)indexPass{
    switch (pic.imageState) {
        case New:
            [self startDownLoadForPhoto:pic byIndex:indexPass];
            break;
        default:
            NSLog(@"do nothing");
            break;
    }
}

- (void) startDownLoadForPhoto:(SPFPicture*)pic byIndex:(NSIndexPath*)indexPass{
    
    if (_operation.downloadsInProgress[indexPass]){
        return;
    }
    
    SPFDownloadingPictureOperation *downloader = [[SPFDownloadingPictureOperation alloc] initWithUrl:pic.imgURL andComplition:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            pic.imageState = Downloaded;
            [self.operation.downloadsInProgress removeObjectForKey:indexPass];
            [self.collectionView reloadItemsAtIndexPaths:@[indexPass]];
        });
    }];
    
    _operation.downloadsInProgress[indexPass] = downloader;
    [_operation.downloadQueue addOperation:downloader];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    NSLog(@"searchBarSearchButtonClicked");
    NSString *newText = searchBar.text;
    
    if(![self.searchText isEqualToString:newText]){
        self.searchText = [[NSString alloc] initWithString:newText];
        [self.view endEditing:YES];
        newText = [newText stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        [self startGetListOfPictures:newText andPage:1];
    }
}

- (void) startGetListOfPictures:(NSString*)searchText andPage:(int)page{
    NSLog(@"startGetList %@", searchText);
    
    SPFGetListOfPicturesOperation *downloader = [[SPFGetListOfPicturesOperation alloc] initWithSearch:searchText andPage:1];
    
    downloader.pictures = [[NSMutableArray alloc] init];
    
    downloader.completionBlock = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            _records = downloader.pictures;
            [_collectionView reloadData];
            });

    };
    
    [_operation.downloadQueue addOperation:downloader];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [_collectionView deselectItemAtIndexPath:indexPath animated:YES];

    SPFDetailViewController *dv = [[SPFDetailViewController alloc] initWithPicture:_records[indexPath.item] AndStorageService:self.storageService];
    dv.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:dv animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
