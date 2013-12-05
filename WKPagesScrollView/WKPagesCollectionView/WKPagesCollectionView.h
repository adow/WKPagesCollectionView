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
@interface WKPagesCollectionView : UICollectionView{
    BOOL _isHighLight;
    UIImageView* _maskImageView;
    BOOL _maskShow;
}
///是否可以删除
@property (nonatomic,assign) BOOL canRemove;
@property (nonatomic,assign) BOOL maskShow;
-(id)initWithPagesFlowLayoutAndFrame:(CGRect)frame;
-(UIImage*)makeGradientImage;
#pragma mark - Action
-(void)showCellToHighLightAtIndexPath:(NSIndexPath*)indexPath;
-(void)dismissFromHightLight;
@end
