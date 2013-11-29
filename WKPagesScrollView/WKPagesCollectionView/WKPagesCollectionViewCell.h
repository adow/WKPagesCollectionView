//
//  WKPagesCollectionViewCell.h
//  WKPagesScrollView
//
//  Created by 秦 道平 on 13-11-15.
//  Copyright (c) 2013年 秦 道平. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum WKPagesCollectionViewCellShowingState:NSUInteger{
    WKPagesCollectionViewCellShowingStateNormal=0,
    WKPagesCollectionViewCellShowingStateHightlight=1,
    WKPagesCollectionViewCellShowingStateBackToTop=2,
    WKPagesCollectionViewCellShowingStateBackToBottom=3,
} WKPagesCollectionViewCellShowingState;
@protocol WKPagesCollectionViewCellDelegate <NSObject>
///触发删除内容
-(void)removeCellAtIndexPath:(NSIndexPath*)indexPath;
@end
@interface WKPagesCollectionViewCell : UICollectionViewCell<UIScrollViewDelegate>{
    WKPagesCollectionViewCellShowingState _showingState;
    UITapGestureRecognizer* _tapGesture;
    UIScrollView* _scrollView;
}
///正常状态下的位置
@property (nonatomic,assign) CATransform3D normalTransform;
///正常状态下的位置
@property (nonatomic,assign) CGRect normalFrame;
///显示状态
@property (nonatomic,assign) WKPagesCollectionViewCellShowingState showingState;
///引用collectionView
@property (nonatomic,assign) UICollectionView* collectionView;
@property (nonatomic,retain) UIView* cellContentView;
@property (nonatomic,assign) id<WKPagesCollectionViewCellDelegate> cellDelegate;
@end
