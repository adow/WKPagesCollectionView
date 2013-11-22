//
//  WKPagesScrollView.m
//  WKPagesScrollView
//
//  Created by 秦 道平 on 13-11-14.
//  Copyright (c) 2013年 秦 道平. All rights reserved.
//

#import "WKPagesScrollView.h"

@implementation WKPagesScrollView

-(id)initWithPagesFlowLayoutAndFrame:(CGRect)frame{
    WKPagesCollectionViewFlowLayout* flowLayout=[[[WKPagesCollectionViewFlowLayout alloc]init] autorelease];
    self=[super initWithFrame:frame collectionViewLayout:flowLayout];
    if (self){
        
    }
    return self;
}
-(void)dealloc{
    [super dealloc];
}
#pragma mark - Actions
-(void)showCellToHighLightAtIndexPath:(NSIndexPath *)indexPath{
    if (_isHighLight){
        return;
    }
    
    self.scrollEnabled=NO;
    [UIView animateWithDuration:1.0f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.visibleCells enumerateObjectsUsingBlock:^(WKPagesCollectionViewCell* cell, NSUInteger idx, BOOL *stop) {
            NSIndexPath* visibleIndexPath=[self indexPathForCell:cell];
            if (visibleIndexPath.row==indexPath.row){
                cell.showingState=WKPagesCollectionViewCellShowingStateHightlight;
            }
            else if (visibleIndexPath.row<indexPath.row){
                cell.showingState=WKPagesCollectionViewCellShowingStateBackToTop;
            }
            else if (visibleIndexPath.row>indexPath.row){
                cell.showingState=WKPagesCollectionViewCellShowingStateBackToBottom;
            }
            else{
                cell.showingState=WKPagesCollectionViewCellShowingStateNormal;
            }
        }];
    } completion:^(BOOL finished) {
        _isHighLight=YES;
    }];
}
///回到原来的状态
-(void)dismissFromHightLight{
    if (!_isHighLight)
        return;
    [UIView animateWithDuration:1.0f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.visibleCells enumerateObjectsUsingBlock:^(WKPagesCollectionViewCell* cell, NSUInteger idx, BOOL *stop) {
            cell.showingState=WKPagesCollectionViewCellShowingStateNormal;
        }];
    } completion:^(BOOL finished) {
        self.scrollEnabled=YES;
        _isHighLight=NO;
    }];
}
@end
