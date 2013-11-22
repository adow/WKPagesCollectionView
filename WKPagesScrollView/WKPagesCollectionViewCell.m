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
    if (_showingState==showingState)
        return;
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

@end
