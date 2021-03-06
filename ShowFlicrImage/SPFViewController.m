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

@property (nonatomic, strong) NSArray *cellSizes;
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
    
    _searchObject = [[NSMutableDictionary alloc] initWithObjects:@[@1, @""] forKeys:@[@"page", @"textForSearch"]];
    loadingNewPage = NO;
    
    _operation = [SPFPendingOperations new];
    
    _layout = [[PinterestLayout alloc] init];
    
    
    [self.view addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.navigationItem.titleView = [self searchBar];
    self.navigationItem.rightBarButtonItem = [self settingsButton];
}

- (UIBarButtonItem *)settingsButton{
    UIImage *buttonImage = [UIImage imageNamed:@"icSettings"];
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithImage:buttonImage
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:nil];
    return settingsButton;
}
- (UISearchBar *)searchBar{
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.delegate = self;
    searchBar.placeholder = @"Поиск";
    [searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"rectangle121"] forState:UIControlStateNormal];
    return searchBar;
}

- (UICollectionView *)collectionView{
    if (!_collectionView){
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:_layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[SPFCustomCell class]
            forCellWithReuseIdentifier:NSStringFromClass([SPFCustomCell class])];
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.records.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SPFCustomCell *cell = (SPFCustomCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SPFCustomCell class]) forIndexPath:indexPath];
    
    SPFPicture *photo = self.records[indexPath.item];
    //UIActivityIndicatorView *indicator;

    if (!(self.operation.downloadsInProgress[indexPath])){
        [photo correctPictureState];
        
        if (photo.imageState == Downloaded){
            UIImage *tmpImg = [photo.imgURL getImageFromCache];
            tmpImg = [tmpImg imageByCroppingImage];
            cell.imgView.image = tmpImg;
            cell.clipsToBounds = YES;
        }
        if (photo.imageState == New){
            cell.imgView.image =nil;
        }
    }
    
    if (photo.imageState ==  Failed){
        [cell.spinner stopAnimating];
    } else if (photo.imageState == New){
        [cell.spinner startAnimating];
    } else if (photo.imageState == Downloaded){
        [cell.spinner stopAnimating];
    }
    
    if (!(self.collectionView.isDragging || self.collectionView.isDecelerating)) {
        [self startOPerationsForPhotoRecord:photo byIndex:indexPath];
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
    if (self.operation.downloadsInProgress[indexPass]){
        return;
    }
    
    SPFDownloadingPictureOperation *downloader = [[SPFDownloadingPictureOperation alloc] initWithUrl:pic.imgURL andComplition:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            pic.imageState = Downloaded;
            [self.operation.downloadsInProgress removeObjectForKey:indexPass];
            [self.collectionView reloadItemsAtIndexPaths:@[indexPass]];
        });
    }];
    
    self.operation.downloadsInProgress[indexPass] = downloader;
    [self.operation.downloadQueue addOperation:downloader];
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

- (void) startGetListOfPictures:(NSString*)searchText andPage:(long)page{
    
    SPFGetListOfPicturesOperation *downloader = [[SPFGetListOfPicturesOperation alloc] initWithSearch:searchText andPage:page andBlock:^(NSArray *data, NSError *error) {
        if (page == 1){
            self.records = data;
        } else {
            NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithArray:self.records];
            [tmpArray addObjectsFromArray:data];
            self.records = [tmpArray copy];
            tmpArray = nil;
            loadingNewPage = NO;
        }
        [self.collectionView reloadData];
    }];
    
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


- (void) scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (!loadingNewPage){
        CGPoint offset = scrollView.contentOffset;
        CGRect bounds = scrollView.bounds;
        CGSize size = scrollView.contentSize;
        UIEdgeInsets inset = scrollView.contentInset;
        float y = offset.y + bounds.size.height - inset.bottom;
        float h = size.height;
        
        float reload_distance = 40;
        if(y > h + reload_distance) {
            loadingNewPage = YES;
            long currentPage = [_searchObject[@"page"] integerValue];
            [_searchObject setValue:@(currentPage + 1) forKey:@"page"];
            [self startGetListOfPictures:self.searchText andPage:currentPage+1];
        }
    }
}

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"scrollViewWillBeginDragging");
    for (NSIndexPath *indexPath in _operation.downloadsInProgress){
        SPFDownloadingPictureOperation *operation = (SPFDownloadingPictureOperation*)_operation.downloadsInProgress[indexPath];
        operation.queuePriority = NSOperationQueuePriorityVeryLow;
    }
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"scrollViewDidEndDecelerating");
    NSArray *visCells = [self.collectionView indexPathsForVisibleItems];
    [self.collectionView reloadItemsAtIndexPaths:visCells];
}

@end
