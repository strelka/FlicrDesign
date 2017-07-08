//
//  PinterestLayout.h
//  ShowFlicrImage
//
//  Created by Jullia Sharaeva on 28.05.17.
//  Copyright © 2017 Julia Sharaeva. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PinterestLayout;

@protocol SPFPinterestLayoutDelegate <UICollectionViewDelegate>
@required
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;


@optional
- (BOOL) isLargeItemInIndexPath:(NSIndexPath*)index;

@end

@interface PinterestLayout : UICollectionViewLayout
@property (nonatomic, assign) NSInteger columnCount;
@end
