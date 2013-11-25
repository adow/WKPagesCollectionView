//
//  WKFlipView.m
//  WKPagesScrollView
//
//  Created by 秦 道平 on 13-11-14.
//  Copyright (c) 2013年 秦 道平. All rights reserved.
//

#import "WKFlipView.h"
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
