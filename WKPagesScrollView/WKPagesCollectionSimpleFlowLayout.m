//
//  WKPagesCollectionSimpleFlowLayout.m
//  WKPagesScrollView
//
//  Created by 秦 道平 on 13-11-16.
//  Copyright (c) 2013年 秦 道平. All rights reserved.
//

#import "WKPagesCollectionSimpleFlowLayout.h"

@implementation WKPagesCollectionSimpleFlowLayout
-(void)prepareLayout{
    [super prepareLayout];
    self.itemSize=self.collectionView.frame.size;
    self.minimumLineSpacing=10.0f;
    self.scrollDirection=UICollectionViewScrollDirectionVertical;
}
-(CGSize)collectionViewContentSize{
    return CGSizeMake(self.collectionView.frame.size.width, (self.itemSize.height+self.minimumLineSpacing)*[self.collectionView numberOfItemsInSection:0]);
}
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds
{
    return YES;
}
-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray* array=[super layoutAttributesForElementsInRect:rect];
    return array;
}
@end
