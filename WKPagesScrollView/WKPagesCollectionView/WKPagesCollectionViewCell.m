//
//  WKPagesCollectionViewCell.m
//  WKPagesScrollView
//
//  Created by 秦 道平 on 13-11-15.
//  Copyright (c) 2013年 秦 道平. All rights reserved.
//

#import "WKPagesCollectionViewCell.h"
#import "WKPagesCollectionView.h"
#import "WKCloseButton.h"

@interface WKPagesCollectionViewCell ()

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) WKCloseButton *closeButton;

@end

@implementation WKPagesCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = NO;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.tag = 100;
        
        CGRect rect=CGRectMake(0.0f, 0.0f,
                               [UIScreen mainScreen].bounds.size.width,
                               [UIScreen mainScreen].bounds.size.height);

        self.scrollView = [[UIScrollView alloc] initWithFrame:rect];
        self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.scrollView.clipsToBounds = NO;
        self.scrollView.backgroundColor = [UIColor clearColor];
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.showsHorizontalScrollIndicator = YES;
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width + 1.0, self.scrollView.frame.size.height);
        self.scrollView.delegate=self;
        [self.contentView addSubview:_scrollView];
        self.scrollView.tag = 101;
        
        self.cellContentView = [[UIView alloc] initWithFrame:rect];
        self.cellContentView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self.scrollView addSubview:self.cellContentView];
        self.cellContentView.tag=102;

        self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognized:)];
        [self.scrollView addGestureRecognizer:self.tapGestureRecognizer];
        
        self.closeButton = [[WKCloseButton alloc] initWithFrame:CGRectMake(0.0, 0.0, CloseButtonWidth, CloseButtonHeight)];
        [self.closeButton addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:self.closeButton];
    }
    
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    for (UIView *view in self.cellContentView.subviews) {
        [view removeFromSuperview];
    }
}

- (void)tapGestureRecognized:(UITapGestureRecognizer*)tapGesture
{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:self];
    [(WKPagesCollectionView *)self.collectionView showCellToHighLightAtIndexPath:indexPath completion:^(BOOL finished) {
        NSLog(@"highlight completed");
    }];
}

-(void) closeButtonPressed:(id)sender
{
    [self removeCurrentCell];
    
}

#pragma mark -

- (void)setState:(WKPagesCollectionViewCellState)state
{
    if (_state == state)
        return;
    
    _state = state;
    
    WKPagesCollectionViewFlowLayout *collectionLayout = (WKPagesCollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    CGFloat pageHeight=collectionLayout.pageHeight;
    CGFloat topMargin=[(WKPagesCollectionView*)self.collectionView topOffScreenMargin];
    
    switch (state) {
        case WKPagesCollectionViewCellStateHightlight: {
            self.normalTransform = self.layer.transform;
            _scrollView.scrollEnabled = NO;
            _closeButton.hidden = YES;
            NSIndexPath* indexPath = [self.collectionView indexPathForCell:self];
            CGFloat moveY = self.collectionView.contentOffset.y - (WKPagesCollectionViewPageSpacing)*indexPath.row + topMargin;
            CATransform3D moveTransform = CATransform3DMakeTranslation(0.0, moveY, 0.0);
            self.layer.transform = moveTransform;
        }
            break;
        case WKPagesCollectionViewCellStateBackToTop: {
            self.normalTransform = self.layer.transform;
            _scrollView.scrollEnabled = NO;
            _closeButton.hidden = NO;
            CATransform3D rotateTransform = WKFlipCATransform3DPerspectSimpleWithRotate(HighLightRotateAngle);
            CATransform3D moveTransform = CATransform3DMakeTranslation(0, -1*pageHeight - topMargin, 0.0);
            self.layer.transform=CATransform3DConcat(rotateTransform, moveTransform);
        }
            break;
        case WKPagesCollectionViewCellStateBackToBottom: {
            self.normalTransform = self.layer.transform;
            _scrollView.scrollEnabled = NO;
            _closeButton.hidden = NO;
            CATransform3D rotateTransform = WKFlipCATransform3DPerspectSimpleWithRotate(HighLightRotateAngle);
            CATransform3D moveTransform = CATransform3DMakeTranslation(0.0, pageHeight + topMargin, 0.0);
            self.layer.transform = CATransform3DConcat(rotateTransform, moveTransform);
        }
            break;
        case WKPagesCollectionViewCellStateNormal: {
            self.layer.transform = self.normalTransform;
            _scrollView.scrollEnabled = YES;
            _closeButton.hidden = NO;
        }
            break;
        default:
            break;
    }
}

- (void)removeCurrentCell
{
    NSIndexPath* indexPath = [self.collectionView indexPathForCell:self];
    NSLog(@"delete cell at %ld",(long)indexPath.row);
    //Delete data
    id<WKPagesCollectionViewDataSource> pagesDataSource=(id<WKPagesCollectionViewDataSource>)self.collectionView.dataSource;
    [pagesDataSource collectionView:(WKPagesCollectionView*)self.collectionView willRemoveCellAtIndexPath:indexPath];
    //Animation
    [self.collectionView performBatchUpdates:^{
        [self.collectionView deleteItemsAtIndexPaths:@[indexPath,]];
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.state == WKPagesCollectionViewCellStateNormal) {
        CGFloat slideDistance = scrollView.frame.size.width / 6;
        if (scrollView.contentOffset.x >= slideDistance) {
            [self removeCurrentCell];
        }
    }
}

@end
