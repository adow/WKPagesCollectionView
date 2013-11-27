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
        self.clipsToBounds=NO;
        self.backgroundColor=[UIColor clearColor];
        self.contentView.tag=100;
        CGRect rect=CGRectMake(0.0f, 0.0f,
                               [UIScreen mainScreen].bounds.size.width,
                               [UIScreen mainScreen].bounds.size.height);
        if (!_scrollView){
            _scrollView=[[UIScrollView alloc]initWithFrame:rect];
            _scrollView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            _scrollView.clipsToBounds=NO;
            _scrollView.backgroundColor=[UIColor clearColor];
            _scrollView.showsVerticalScrollIndicator=NO;
            _scrollView.showsHorizontalScrollIndicator=YES;
            _scrollView.contentSize=CGSizeMake(_scrollView.frame.size.width+1, _scrollView.frame.size.height);
            [self.contentView addSubview:_scrollView];
            _scrollView.tag=101;
        }
        if (!_cellContentView){
            _cellContentView=[[UIView alloc]initWithFrame:rect];
            _cellContentView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            [_scrollView addSubview:_cellContentView];
            _cellContentView.tag=102;
        }
        if (!_tapGesture){
            _tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapGesture:)];
            [_scrollView addGestureRecognizer:_tapGesture];
        }
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
-(void)dealloc{
    [_tapGesture release];
    [_cellContentView release];
    [_scrollView release];
    [super dealloc];
}
-(void)prepareForReuse{
    [super prepareForReuse];
//    for (UIView* view in self.contentView.subviews) {
//        [view removeFromSuperview];
//    }
    for (UIView* view in _cellContentView.subviews) {
        [view removeFromSuperview];
    }
    
}
-(IBAction)onTapGesture:(UITapGestureRecognizer*)tapGesture{
    NSIndexPath* indexPath=[self.collectionView indexPathForCell:self];
//    NSLog(@"row:%d",indexPath.row);
    [self.collectionView.delegate collectionView:self.collectionView didSelectItemAtIndexPath:indexPath];
}
#pragma mark - Properties
-(void)setShowingState:(WKPagesCollectionViewCellShowingState)showingState{
    if (_showingState==showingState)
        return;
    _showingState=showingState;
     CGFloat pageHeight=[UIScreen mainScreen].bounds.size.height;
    switch (showingState) {
        case WKPagesCollectionViewCellShowingStateHightlight:{
            self.normalTransform=self.layer.transform;///先记录原来的位置
            _scrollView.scrollEnabled=NO;
            NSIndexPath* indexPath=[self.collectionView indexPathForCell:self];
            CGFloat lineSpacing=pageHeight-160;
            CGFloat moveY=self.collectionView.contentOffset.y-(pageHeight-lineSpacing)*indexPath.row;
            //NSLog(@"moveY:%f, contentOffsetY:%f",moveY,self.collectionView.contentOffset.y);
            CATransform3D moveTransform=CATransform3DMakeTranslation(0.0f, moveY, 0.0f);
            self.layer.transform=moveTransform;
        }
            break;
        case WKPagesCollectionViewCellShowingStateBackToTop:{
            self.normalTransform=self.layer.transform;///先记录原来的位置
            _scrollView.scrollEnabled=NO;
            CATransform3D moveTransform=CATransform3DMakeTranslation(0, -1*pageHeight, 0);
            self.layer.transform=CATransform3DConcat(self.normalTransform, moveTransform);
        }
            break;
        case WKPagesCollectionViewCellShowingStateBackToBottom:{
            self.normalTransform=self.layer.transform;///先记录原来的位置
            _scrollView.scrollEnabled=NO;
            CATransform3D moveTransform=CATransform3DMakeTranslation(0, pageHeight, 0);
            self.layer.transform=CATransform3DConcat(CATransform3DIdentity, moveTransform);
        }
            break;
        case WKPagesCollectionViewCellShowingStateNormal:{
            self.layer.transform=self.normalTransform;
            _scrollView.scrollEnabled=YES;
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
