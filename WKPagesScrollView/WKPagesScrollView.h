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
@interface WKPagesScrollView : UICollectionView{
    BOOL _isHighLight;
}
-(id)initWithPagesFlowLayoutAndFrame:(CGRect)frame;
-(void)showCellToHighLightAtIndexPath:(NSIndexPath*)indexPath;
-(void)dismissFromHightLight;
@end
