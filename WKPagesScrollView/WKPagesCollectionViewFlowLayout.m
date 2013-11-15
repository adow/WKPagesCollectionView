//
//  WKPagesCollectionViewFlowLayout.m
//  WKPagesScrollView
//
//  Created by 秦 道平 on 13-11-15.
//  Copyright (c) 2013年 秦 道平. All rights reserved.
//

#import "WKPagesCollectionViewFlowLayout.h"
#define PageHeight 100.0f
#define LineSpacing 0.0f
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
    self.itemSize=CGSizeMake(300,PageHeight);
    self.minimumLineSpacing=LineSpacing;
    self.scrollDirection=UICollectionViewScrollDirectionVertical;
}
-(CGSize)collectionViewContentSize{
    return CGSizeMake(320.0f, (PageHeight+LineSpacing)*33);
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds
{
    return YES;
}
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)path
{
    NSLog(@"layoutAttributesForItemAtIndexPath:%d",path.row);
    UICollectionViewLayoutAttributes* attributes=[super layoutAttributesForItemAtIndexPath:path];
    return attributes;
}
-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    //NSLog(@"layoutAttributesForElementsInRect:%@",NSStringFromCGRect(rect));
    NSArray* array = [super layoutAttributesForElementsInRect:rect];
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    //NSLog(@"visibleRect:%@",NSStringFromCGRect(visibleRect));
    for (UICollectionViewLayoutAttributes* attributes in array) {
        
        CGRect rect=attributes.frame;
        rect.size.height=460.0f;
        rect.size.width=320.0f;
        rect.origin.x=0.0f;
        attributes.frame=rect;
        
        if (CGRectIntersectsRect(attributes.frame, rect)) {///显示区域内的找出来
            CGFloat distance = CGRectGetMidY(visibleRect) - attributes.center.y; ///计算和屏幕中心的距离
            CGFloat normalizedDistance = fabsf(distance) / CGRectGetMidY(self.collectionView.frame);
            CATransform3D rotateTransform=WKFlipCATransform3DPerspectSimpleWithRotate(-50+15.0f*(1-normalizedDistance));
            attributes.transform3D=rotateTransform;
        }
        else{
            CATransform3D rotateTransform=WKFlipCATransform3DPerspectSimpleWithRotate(-50.0f);
            attributes.transform3D=rotateTransform;
        }
    }
    return array;
}
@end
