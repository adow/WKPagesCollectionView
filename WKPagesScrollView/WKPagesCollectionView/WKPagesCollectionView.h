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
    UIImageView* _maskImageView;
    BOOL _maskShow;
}
///是否可以删除
@property (nonatomic,assign) BOOL canRemove;
@property (nonatomic,assign) BOOL maskShow;
@property (nonatomic,assign) BOOL isHighLight;
-(id)initWithPagesFlowLayoutAndFrame:(CGRect)frame;
-(UIImage*)makeGradientImage;
#pragma mark - Action
-(void)showCellToHighLightAtIndexPath:(NSIndexPath*)indexPath completion:(void(^)(BOOL finished))completion;
-(void)dismissFromHightLightWithCompletion:(void(^)(BOOL finished))completion;
@end
