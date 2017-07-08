//
//  PinterestLayout.m
//  ShowFlicrImage
//
//  Created by Jullia Sharaeva on 28.05.17.
//  Copyright © 2017 Julia Sharaeva. All rights reserved.
//

#import "PinterestLayout.h"
@interface PinterestLayout()

@property (nonatomic, weak) id <SPFPinterestLayoutDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *sectionItemAttributes;
@property (nonatomic, strong) NSMutableArray *allItemAttributes;
@property (nonatomic, strong) NSMutableArray *unionRects;
@property(nonatomic, strong) NSMutableDictionary *rateDict;
@property (nonatomic) int lastRow;
@end

@implementation PinterestLayout
static const NSInteger unionSize = 20;
- (NSMutableArray *)unionRects {
    if (!_unionRects) {
        _unionRects = [NSMutableArray array];
    }
    return _unionRects;
}

- (NSMutableArray *)allItemAttributes {
    if (!_allItemAttributes) {
        _allItemAttributes = [NSMutableArray array];
    }
    return _allItemAttributes;
}

- (NSMutableArray *)sectionItemAttributes {
    if (!_sectionItemAttributes) {
        _sectionItemAttributes = [NSMutableArray array];
    }
    return _sectionItemAttributes;
}

- (id <SPFPinterestLayoutDelegate> )delegate {
    return (id <SPFPinterestLayoutDelegate> )self.collectionView.delegate;
}

#pragma mark - Init
- (void)commonInit {
    _columnCount = 3;
}

- (id)init {
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

#pragma mark - Methods to Override
- (void)prepareLayout {
    [super prepareLayout];
    
    [self.unionRects removeAllObjects];
    [self.allItemAttributes removeAllObjects];
    [self.sectionItemAttributes removeAllObjects];
    
    NSInteger numberOfSections = [self.collectionView numberOfSections];
    if (numberOfSections == 0) {
        return;
    }
    
    // Initialize variables
    NSInteger idx = 0;
    
    UICollectionViewLayoutAttributes *attributes;
    
    for (NSInteger section = 0; section < numberOfSections; ++section) {
        CGFloat width_step = self.collectionView.bounds.size.width/3;
        
        _rateDict = [[NSMutableDictionary alloc] init];
        BOOL isLarge;
        
        [_rateDict setValue:@0 forKey:@"0"];
        
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        NSMutableArray *itemAttributes = [NSMutableArray arrayWithCapacity:itemCount];
        NSMutableArray<NSValue *> *singlePointArray = [[NSMutableArray alloc] init];
        
        int maxRow = 0;
        for (idx = 0; idx < itemCount; idx++) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:section];
            
            isLarge = [self.delegate isLargeItemInIndexPath:indexPath];
            
            CGSize itemSize = [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
            NSMutableDictionary *newrate = [[NSMutableDictionary alloc] init];
            double x = 0.0;
            double y = 0.0;
            int koff;
            
            koff = (isLarge)?2:1;
            if (isLarge){
                for (NSString *item in _rateDict){
                    int tmpKey = [item intValue];
                    int tmpVal = [_rateDict[item] intValue];
                    
                    
                    y = tmpKey * width_step;
                    x = tmpVal * width_step;
                    
                    if (tmpVal == 0){
                        [singlePointArray addObject:[NSValue valueWithCGPoint:CGPointMake(2*width_step, tmpKey*width_step)]];
                        [singlePointArray addObject:[NSValue valueWithCGPoint:CGPointMake(2*width_step, (tmpKey+1)*width_step)]];
                    }
                    else if (tmpVal == 1){
                        [singlePointArray addObject:[NSValue valueWithCGPoint:CGPointMake(0, (tmpKey+1)*width_step)]];
                    }
                    [newrate setObject:@0 forKey:[[NSString alloc]initWithFormat:@"%d", tmpKey + 2]];
                    maxRow = tmpKey + 2;
                }
            }
            else {
                if ([singlePointArray count] == 0){
                    for (NSString *item in _rateDict){
                        int tmpKey = [item intValue];
                        int tmpVal = [_rateDict[item] intValue];
                        
                        y = tmpKey * width_step;
                        x = tmpVal * width_step;
                        
                        if (tmpVal == 0){
                            [newrate setObject:@1 forKey:[[NSString alloc]initWithFormat:@"%d", (tmpKey)]];
                            maxRow = tmpKey;
                        } else {
                            [singlePointArray addObject:[NSValue valueWithCGPoint:CGPointMake(2*width_step, tmpKey*width_step)]];
                            [newrate setObject:@0 forKey:[[NSString alloc]initWithFormat:@"%d", (tmpKey + 1)]];
                            maxRow = tmpKey + 1;
                        }
                    }
                } else {
                    x = singlePointArray[0].CGPointValue.x;
                    y = singlePointArray[0].CGPointValue.y;
                    [singlePointArray removeObjectAtIndex:0];
                    [newrate setDictionary:_rateDict];
                }
            }
            
            _rateDict = nil;
            _rateDict = [[NSMutableDictionary alloc] initWithDictionary:newrate];
            newrate = nil;
            
            CGRect rect = CGRectMake(x, y, itemSize.width, itemSize.height);
            attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            attributes.frame = rect;
            [itemAttributes addObject:attributes];
            [self.allItemAttributes addObject:attributes];
        }
        [self.sectionItemAttributes addObject:itemAttributes];
        _lastRow = maxRow;
        
        
        // Build union rects
        idx = 0;
        NSInteger itemCounts = [self.allItemAttributes count];
        while (idx < itemCounts) {
            CGRect unionRect = ((UICollectionViewLayoutAttributes *)self.allItemAttributes[idx]).frame;
            NSInteger rectEndIndex = MIN(idx + unionSize, itemCounts);
            
            for (NSInteger i = idx + 1; i < rectEndIndex; i++) {
                unionRect = CGRectUnion(unionRect, ((UICollectionViewLayoutAttributes *)self.allItemAttributes[i]).frame);
            }
            
            idx = rectEndIndex;
            
            [self.unionRects addObject:[NSValue valueWithCGRect:unionRect]];
        }
    }
}
- (CGSize)collectionViewContentSize {
    NSInteger numberOfSections = [self.collectionView numberOfSections];
    if (numberOfSections == 0) {
        return CGSizeZero;
    }
    CGSize contentSize = self.collectionView.bounds.size;
    contentSize.height = _lastRow * (contentSize.width/3);
    return contentSize;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)path {
    if (path.section >= [self.sectionItemAttributes count]) {
        return nil;
    }
    if (path.item >= [self.sectionItemAttributes[path.section] count]) {
        return nil;
    }
    return (self.sectionItemAttributes[path.section])[path.item];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSInteger i;
    NSInteger begin = 0, end = self.unionRects.count;
    NSMutableDictionary *cellAttrDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *supplAttrDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *decorAttrDict = [NSMutableDictionary dictionary];
    
    for (i = 0; i < self.unionRects.count; i++) {
        if (CGRectIntersectsRect(rect, [self.unionRects[i] CGRectValue])) {
            begin = i * unionSize;
            break;
        }
    }
    for (i = self.unionRects.count - 1; i >= 0; i--) {
        if (CGRectIntersectsRect(rect, [self.unionRects[i] CGRectValue])) {
            end = MIN((i + 1) * unionSize, self.allItemAttributes.count);
            break;
        }
    }
    for (i = begin; i < end; i++) {
        UICollectionViewLayoutAttributes *attr = self.allItemAttributes[i];
        if (CGRectIntersectsRect(rect, attr.frame)) {
            switch (attr.representedElementCategory) {
                case UICollectionElementCategorySupplementaryView:
                    supplAttrDict[attr.indexPath] = attr;
                    break;
                case UICollectionElementCategoryDecorationView:
                    decorAttrDict[attr.indexPath] = attr;
                    break;
                case UICollectionElementCategoryCell:
                    cellAttrDict[attr.indexPath] = attr;
                    break;
            }
        }
    }
    
    NSArray *result = [cellAttrDict.allValues arrayByAddingObjectsFromArray:supplAttrDict.allValues];
    result = [result arrayByAddingObjectsFromArray:decorAttrDict.allValues];
    return result;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    CGRect oldBounds = self.collectionView.bounds;
    if (CGRectGetWidth(newBounds) != CGRectGetWidth(oldBounds)) {
        return YES;
    }
    return NO;
}
@end
