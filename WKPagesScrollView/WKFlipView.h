//
//  WKFlipView.h
//  WKPagesScrollView
//
//  Created by 秦 道平 on 13-11-14.
//  Copyright (c) 2013年 秦 道平. All rights reserved.
//

#import <UIKit/UIKit.h>
#pragma mark - Graphics
CATransform3D WKFlipCATransform3DMakePerspective(CGPoint center, float disZ);
CATransform3D WKFlipCATransform3DPerspect(CATransform3D t, CGPoint center, float disZ);
CATransform3D WKFlipCATransform3DPerspectSimple(CATransform3D t);
CATransform3D WKFlipCATransform3DPerspectSimpleWithRotate(CGFloat degree);

#pragma mark - WKFlipView
@interface WKFlipView : UIView{
    CGFloat _rotate;
}
@property (nonatomic,assign) CGFloat rotate;
@end
