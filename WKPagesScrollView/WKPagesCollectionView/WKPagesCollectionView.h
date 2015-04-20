//
//  WKPagesScrollView.h
//  WKPagesScrollView
//
//  Created by 秦 道平 on 13-11-14.
//  Copyright (c) 2013年 秦 道平. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKPagesCollectionViewFlowLayout.h"
#import "WKPagesCollectionViewCell.h"

@class WKPagesCollectionView;

@protocol WKPagesCollectionViewDataSource <UICollectionViewDataSource>
///When you delete a cell is used to delete data
-(void)collectionView:(WKPagesCollectionView *)collectionView willRemoveCellAtIndexPath:(NSIndexPath *)indexPath;
///Called when additional data
-(void)willAppendItemInCollectionView:(WKPagesCollectionView *)collectionView;

@end

@protocol WKPagesCollectionViewDelegate <UICollectionViewDelegate>

@optional
///When displaying a callback
-(void)collectionView:(WKPagesCollectionView *)collectionView didShownToHightlightAtIndexPath:(NSIndexPath *)indexPath;
///Return to the original state when the callback
-(void)didDismissFromHightlightOnCollectionView:(WKPagesCollectionView *)collectionView;

@end

@interface WKPagesCollectionView : UICollectionView

@property (nonatomic, assign) BOOL canRemove;
@property (nonatomic, assign) BOOL maskShow;
@property (readonly, nonatomic, assign) BOOL isHighLight;
@property (nonatomic, assign) BOOL isAddingNewPage;
@property (nonatomic, assign) CGFloat topOffScreenMargin;
@property (nonatomic, assign) CGFloat highLightAnimationDuration;
@property (nonatomic, assign) CGFloat dismisalAnimationDuration;

-(void)showCellToHighLightAtIndexPath:(NSIndexPath*)indexPath completion:(void(^)(BOOL finished))completion;
///No animation display state, there will be didShowCellToHightLight callback
-(void)showCellToHighLightAtIndexPath:(NSIndexPath*)indexPath;
///Scroll back to its original state
-(void)dismissFromHightLightWithCompletion:(void(^)(BOOL finished))completion;
///Additional content
-(void)appendItem;

@end
