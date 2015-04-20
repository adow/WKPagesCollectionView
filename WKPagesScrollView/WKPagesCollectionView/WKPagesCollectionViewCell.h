//
//  WKPagesCollectionViewCell.h
//  WKPagesScrollView
//
//  Created by 秦 道平 on 13-11-15.
//  Copyright (c) 2013年 秦 道平. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKCloseButton.h"

typedef NS_ENUM(NSUInteger, WKPagesCollectionViewCellState) {
    WKPagesCollectionViewCellStateNormal,
    WKPagesCollectionViewCellStateHightlight,
    WKPagesCollectionViewCellStateBackToTop,
    WKPagesCollectionViewCellStateBackToBottom,
};

@interface WKPagesCollectionViewCell : UICollectionViewCell <UIScrollViewDelegate>

@property (nonatomic, assign) CATransform3D normalTransform;
@property (nonatomic, assign) CGRect normalFrame;
@property (nonatomic, assign) WKPagesCollectionViewCellState state;
@property (nonatomic, assign) UICollectionView *collectionView; // cell should not need a reference to the collection view (its parent)
@property (nonatomic, strong) UIView *cellContentView;

@end
