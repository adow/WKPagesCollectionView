//
//  WKPagesCollectionViewFlowLayout.m
//  WKPagesScrollView
//
//  Created by 秦 道平 on 13-11-15.
//  Copyright (c) 2013年 秦 道平. All rights reserved.
//

#import "WKPagesCollectionViewFlowLayout.h"
#import "WKPagesCollectionView.h"

#define RotateDegree -60.0f

@interface WKPagesCollectionViewFlowLayout()

@property (nonatomic,strong) NSMutableArray *deleteIndexPaths;
@property (nonatomic,strong) NSMutableArray *insertIndexPaths;

@end

@implementation WKPagesCollectionViewFlowLayout

#pragma mark - UICollectionViewLayout (UISubclassingHooks)

- (CGSize)collectionViewContentSize
{
    NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:0];
    CGFloat contentHeight = numberOfItems*self.pageHeight + self.self.minimumLineSpacing*(numberOfItems - 1);
    contentHeight = fmaxf(contentHeight, self.collectionView.frame.size.height);
    
    return CGSizeMake(self.collectionView.frame.size.width,contentHeight);
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds
{
    return YES;
}

#pragma mark - UICollectionViewLayout (UIUpdateSupportHooks)

- (void)prepareLayout
{
    [super prepareLayout];

    self.minimumLineSpacing = -1*(self.itemSize.height-WKPagesCollectionViewPageSpacing);
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)path
{
    UICollectionViewLayoutAttributes* attributes = [super layoutAttributesForItemAtIndexPath:path];
    [self makeRotateTransformForAttributes:attributes];

    return attributes;
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *layoutAttributes = [super layoutAttributesForElementsInRect:rect];
    for (UICollectionViewLayoutAttributes *attributes in layoutAttributes) {
        [self makeRotateTransformForAttributes:attributes];
    }
 
    return layoutAttributes;
}

- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems
{
    [super prepareForCollectionViewUpdates:updateItems];
    self.deleteIndexPaths = [NSMutableArray array];
    self.insertIndexPaths = [NSMutableArray array];
    for (UICollectionViewUpdateItem *updateItem in updateItems) {
        if (updateItem.updateAction == UICollectionUpdateActionDelete){
            [self.deleteIndexPaths addObject:updateItem.indexPathBeforeUpdate];
        }
        if (updateItem.updateAction == UICollectionUpdateActionInsert){
            [self.insertIndexPaths addObject:updateItem.indexPathAfterUpdate];
        }
    }
}

- (void)finalizeCollectionViewUpdates
{
    [super finalizeCollectionViewUpdates];
    self.deleteIndexPaths = nil;
    self.insertIndexPaths = nil;
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes *attributes = [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];

    if ([self.insertIndexPaths containsObject:itemIndexPath]){
        if (!attributes)
            attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
        CATransform3D rotateTransform=WKFlipCATransform3DPerspectSimpleWithRotate(-90.0f);
        attributes.transform3D=rotateTransform;
    }

    return attributes;
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes *attributes = [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
    
    if ([self.deleteIndexPaths containsObject:itemIndexPath]){
        if (!attributes){
            attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
        }
        CATransform3D moveTransform = CATransform3DMakeTranslation(-self.itemSize.width, 0.0, 0.0);
        attributes.transform3D = CATransform3DConcat(attributes.transform3D, moveTransform);
    }
    
    return attributes;
}

#pragma mark -

- (CGFloat)pageHeight
{
    return self.itemSize.height;
}

#pragma mark - 

// As attribute set up a new perspective
- (void)makeRotateTransformForAttributes:(UICollectionViewLayoutAttributes *)attributes
{
    attributes.zIndex = attributes.indexPath.row; //To set the zIndex，Otherwise, there will be NO blocking order
    CGFloat distance = attributes.frame.origin.y - self.collectionView.contentOffset.y;
    CGFloat normalizedDistance = distance / self.collectionView.frame.size.height;
    normalizedDistance = fmaxf(normalizedDistance, 0.0);
    CGFloat rotate = RotateDegree+ 20.0*normalizedDistance;

    // Angle and angle will cross a small cell, even if you set zIndex is useless here to set the angle of the bottom of the cell is growing
    CATransform3D rotateTransform = WKFlipCATransform3DPerspectSimpleWithRotate(rotate);
    attributes.transform3D = rotateTransform;
}

@end