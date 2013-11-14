//
//  WKFlipView.m
//  WKPagesScrollView
//
//  Created by 秦 道平 on 13-11-14.
//  Copyright (c) 2013年 秦 道平. All rights reserved.
//

#import "WKFlipView.h"
#pragma mark - Graphics
CATransform3D WKFlipCATransform3DMakePerspective(CGPoint center, float disZ)
{
    CATransform3D transToCenter = CATransform3DMakeTranslation(-center.x, -center.y, -300.0f);
    CATransform3D transBack = CATransform3DMakeTranslation(center.x, center.y, 0);
    CATransform3D scale = CATransform3DIdentity;
    scale.m34 = -1.0f/disZ;
    return CATransform3DConcat(CATransform3DConcat(transToCenter, scale), transBack);
}
CATransform3D WKFlipCATransform3DPerspect(CATransform3D t, CGPoint center, float disZ)
{
    return CATransform3DConcat(t, WKFlipCATransform3DMakePerspective(center, disZ));
}
CATransform3D WKFlipCATransform3DPerspectSimple(CATransform3D t){
    return WKFlipCATransform3DPerspect(t, CGPointMake(0, 0), 1000);
}
CATransform3D WKFlipCATransform3DPerspectSimpleWithRotate(CGFloat degree){
    return WKFlipCATransform3DPerspectSimple(CATransform3DMakeRotation((M_PI*degree/180.0f), 1.0, 0.0, 0.0));
}
#pragma mark - WKFlipView
@implementation WKFlipView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        self.layer.anchorPoint=CGPointMake(0.5, 0);
//        self.layer.position=CGPointMake(self.layer.position.x,
//                                  self.layer.position.y-self.layer.frame.size.height/2);
    }
    return self;
}
-(void)dealloc{
    [super dealloc];
}
#pragma mark - Properties
-(void)setRotate:(CGFloat)rotate{
    _rotate=rotate;
    self.layer.transform=WKFlipCATransform3DPerspectSimpleWithRotate(rotate);
}
-(CGFloat)rotate{
    return _rotate;
}
@end
