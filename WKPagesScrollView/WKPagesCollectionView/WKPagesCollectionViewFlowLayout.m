//
//  WKPagesCollectionViewFlowLayout.m
//  WKPagesScrollView
//
//  Created by 秦 道平 on 13-11-15.
//  Copyright (c) 2013年 秦 道平. All rights reserved.
//


#import "WKPagesCollectionViewFlowLayout.h"
#define RotateDegree -60.0f
@interface WKPagesCollectionViewFlowLayout()
@property (nonatomic,retain) NSMutableArray* deleteIndexPaths;
@property (nonatomic,retain) NSMutableArray* insertIndexPaths;
@end
@implementation WKPagesCollectionViewFlowLayout{
    
}
-(id)init{
    self=[super init];
    if (self){
        
    }
    return self;
}
-(void)prepareLayout
{
    [super prepareLayout];
    self.itemSize=CGSizeMake(self.collectionView.frame.size.width,self.pageHeight);
    self.minimumLineSpacing=-1*(self.itemSize.height-160.0f);
    self.scrollDirection=UICollectionViewScrollDirectionVertical;
}
-(CGFloat)pageHeight{
    return [UIScreen mainScreen].bounds.size.height;
}
-(CGSize)collectionViewContentSize{
    CGFloat contentHeight=160.0f*([self.collectionView numberOfItemsInSection:0]-1)+self.pageHeight;
    contentHeight=fmaxf(contentHeight, self.collectionView.frame.size.height);
    return CGSizeMake(self.collectionView.frame.size.width,contentHeight);
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds
{
    return YES;
}
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)path
{
    NSLog(@"layoutAttributesForItemAtIndexPath:%d",path.row);
    UICollectionViewLayoutAttributes* attributes=[super layoutAttributesForItemAtIndexPath:path];
    [self makeRotateTransformForAttributes:attributes];
    return attributes;
}
-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSLog(@"layoutAttributesForElementsInRect:%@",NSStringFromCGRect(rect));
    NSArray* array = [super layoutAttributesForElementsInRect:rect];
    for (UICollectionViewLayoutAttributes* attributes in array) {
        [self makeRotateTransformForAttributes:attributes];
    }
    return array;
}
#pragma mark Collection Update
-(void)prepareForCollectionViewUpdates:(NSArray *)updateItems{
    NSLog(@"prepareForCollectionViewUpdates");
    [super prepareForCollectionViewUpdates:updateItems];
    self.deleteIndexPaths=[NSMutableArray array];
    self.insertIndexPaths=[NSMutableArray array];
    for (UICollectionViewUpdateItem* updateItem in updateItems) {
        if (updateItem.updateAction==UICollectionUpdateActionDelete){
            [self.deleteIndexPaths addObject:updateItem.indexPathBeforeUpdate];
        }
        if (updateItem.updateAction==UICollectionUpdateActionInsert){
            [self.insertIndexPaths addObject:updateItem.indexPathAfterUpdate];
        }
    }
}
-(void)finalizeCollectionViewUpdates{
    NSLog(@"finalizeCollectionViewUpdates");
    [super finalizeCollectionViewUpdates];
    self.deleteIndexPaths=nil;
    self.insertIndexPaths=nil;
}
-(UICollectionViewLayoutAttributes*)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath{
    UICollectionViewLayoutAttributes* attributes=[super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
    NSLog(@"initialLayoutAttributesForAppearingItemAtIndexPath:%d",itemIndexPath.row);
    if ([self.insertIndexPaths containsObject:itemIndexPath]){
        if (!attributes)
            attributes=[self layoutAttributesForItemAtIndexPath:itemIndexPath];
        CATransform3D rotateTransform=WKFlipCATransform3DPerspectSimpleWithRotate(-90.0f);
        attributes.transform3D=rotateTransform;
    }
    return attributes;
}
-(UICollectionViewLayoutAttributes*)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath{
    NSLog(@"finalLayoutAttributesForDisappearingItemAtIndexPath:%d",itemIndexPath.row);
    UICollectionViewLayoutAttributes* attributes=[super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
    if ([self.deleteIndexPaths containsObject:itemIndexPath]){
        if (!attributes){
            attributes=[self layoutAttributesForItemAtIndexPath:itemIndexPath];
        }
        CATransform3D moveTransform=CATransform3DMakeTranslation(-320.0f, 0.0f, 0.0f);
        attributes.transform3D=CATransform3DConcat(attributes.transform3D, moveTransform);
    }    
    return attributes;
    
}
///为attribute设置新的角度
-(void)makeRotateTransformForAttributes:(UICollectionViewLayoutAttributes*)attributes{
    attributes.zIndex=attributes.indexPath.row;///要设置zIndex，否则遮挡顺序会有编号
    CGFloat distance=attributes.frame.origin.y-self.collectionView.contentOffset.y;
    CGFloat normalizedDistance = distance / self.collectionView.frame.size.height;
    normalizedDistance=fmaxf(normalizedDistance, 0.0f);
    CGFloat rotate=RotateDegree+20.0f*normalizedDistance;
    //CGFloat rotate=RotateDegree;
    NSLog(@"makeRotateTransformForAttributes:row:%d,normalizedDistance:%f,rotate:%f",
          attributes.indexPath.row,normalizedDistance,rotate);
    ///角度大的会和角度小的cell交叉，即使设置zIndex也没有用，这里设置底部的cell角度越来越大
    CATransform3D rotateTransform=WKFlipCATransform3DPerspectSimpleWithRotate(rotate);
    attributes.transform3D=rotateTransform;
    
}
-(void)makeRotateTransformForAttributes2:(UICollectionViewLayoutAttributes*)attributes{
    attributes.zIndex=attributes.indexPath.row;///要设置zIndex，否则遮挡顺序会有编号
    CGFloat normalizedDistance=attributes.indexPath.row/9.0f;
    CGFloat rotate=RotateDegree+20.0f*normalizedDistance;
    NSLog(@"makeRotateTransformForAttributes:%d,normalizedDistance:%f,rote:%f",attributes.indexPath.row,normalizedDistance,rotate);
    CATransform3D rotateTransform=WKFlipCATransform3DPerspectSimpleWithRotate(rotate);
    attributes.transform3D=rotateTransform;
}
@end