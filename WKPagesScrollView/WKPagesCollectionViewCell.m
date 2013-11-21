//
//  WKPagesCollectionViewCell.m
//  WKPagesScrollView
//
//  Created by 秦 道平 on 13-11-15.
//  Copyright (c) 2013年 秦 道平. All rights reserved.
//

#import "WKPagesCollectionViewCell.h"
#import "WKFlipView.h"
@implementation WKPagesCollectionViewCell
@dynamic showingState;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)prepareForReuse{
    [super prepareForReuse];
    for (UIView* view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
}
#pragma mark - Properties
-(void)setShowingState:(WKPagesCollectionViewCellShowingState)showingState{
    _showingState=showingState;
    switch (showingState) {
        case WKPagesCollectionViewCellShowingStateHightlight:{
            self.normalTransform=self.layer.transform;///先记录原来的位置
            NSIndexPath* indexPath=[self.collectionView indexPathForCell:self];
            CGFloat moveY=self.collectionView.contentOffset.y-100*indexPath.row;
            NSLog(@"moveY:%f, contentOffsetY:%f",moveY,self.collectionView.contentOffset.y);
            CATransform3D moveTransform=CATransform3DMakeTranslation(0.0f, moveY, 0.0f);
            self.layer.transform=moveTransform;
        }
            break;
        case WKPagesCollectionViewCellShowingStateBackToTop:{
            self.normalTransform=self.layer.transform;///先记录原来的位置
            CATransform3D moveTransform=CATransform3DMakeTranslation(0, -460.0f, 0);
            self.layer.transform=CATransform3DConcat(self.normalTransform, moveTransform);
        }
            break;
        case WKPagesCollectionViewCellShowingStateBackToBottom:{
            self.normalTransform=self.layer.transform;///先记录原来的位置
            CATransform3D moveTransform=CATransform3DMakeTranslation(0, 460.0f, 0);
            self.layer.transform=CATransform3DConcat(self.normalTransform, moveTransform);
        }
            break;
        case WKPagesCollectionViewCellShowingStateNormal:{
            self.layer.transform=self.normalTransform;
        }
            break;
        default:
            break;
    }
    
    
    
}
-(WKPagesCollectionViewCellShowingState)showingState{
    return _showingState;
}
#pragma mark - Actions
-(void)showToHightlight{
    ///先记录原来的位置
    self.normalTransform=self.layer.transform;
    int currentIndex=[self.collectionView.visibleCells indexOfObject:self];///当前这个cell所在的位置
    [self.collectionView.visibleCells enumerateObjectsUsingBlock:^(WKPagesCollectionViewCell* cell, NSUInteger idx, BOOL *stop) {
        cell.normalTransform=cell.layer.transform;
        cell.normalFrame=cell.layer.frame;
        int index=[self.collectionView.visibleCells indexOfObject:cell];
        ///在当前cell下面的，移到上面去
        if (index<currentIndex){
            NSLog(@"back:%d,%@",index,cell);
            CATransform3D moveTransform=CATransform3DMakeTranslation(0, -460.0f, 0);
            [UIView animateWithDuration:0.5 delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
                cell.layer.transform=CATransform3DConcat(cell.normalTransform, moveTransform);
            } completion:^(BOOL finished) {
                
            }];
            
        }
        ///在当前cell上面的，移到下面去
        else if (index>currentIndex){
            NSLog(@"front:%d,%@",index,cell);
            CATransform3D moveTransform=CATransform3DMakeTranslation(0, 460, 301.0f);
            [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
                cell.layer.transform=CATransform3DConcat(cell.normalTransform, moveTransform);
            } completion:^(BOOL finished) {
                
            }];
            
        }
        ///当前的cell，不动
        else{
            NSLog(@"current:%d,%@",index,cell);
            CGFloat moveY=self.collectionView.contentOffset.y-100*index;
            NSLog(@"moveY:%f, contentOffsetY:%f",moveY,self.collectionView.contentOffset.y);
            CATransform3D moveTransform=CATransform3DMakeTranslation(0.0f, moveY, 0.0f);
            [UIView animateWithDuration:1.0f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
                NSLog(@"animate start frame:%@",NSStringFromCGRect(cell.layer.frame));
                cell.layer.transform=moveTransform;
                NSLog(@"animate end frame:%@",NSStringFromCGRect(cell.layer.frame));
            } completion:^(BOOL finished) {
                NSLog(@"end frame:%@",NSStringFromCGRect(cell.layer.frame));
            }];
        }
    }];
}
-(void)backFromHightlight{
    self.layer.transform=self.normalTransform;
}
@end
