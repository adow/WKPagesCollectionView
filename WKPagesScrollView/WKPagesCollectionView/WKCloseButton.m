//
//  WKCloseButton.m
//  WKPagesCollectionView
//
//  Created by Xu Zhao on 3/12/14.
//  Copyright (c) 2014 秦 道平. All rights reserved.
//

#import "WKCloseButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation WKCloseButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        [self drawCloseButton];
    }
    return self;
}

- (void)drawCloseButton
{
    self.backgroundColor = [UIColor clearColor];
    CGFloat xOffset = 12;
    CGFloat yOffset = 15;
    CGFloat width = 11;
    CGFloat height = 16;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(xOffset, yOffset)];
    [path addLineToPoint:CGPointMake(width + xOffset, height + yOffset)];
    [path moveToPoint:CGPointMake(width + xOffset, yOffset)];
    [path addLineToPoint:CGPointMake(xOffset, height + yOffset)];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setPath:[path CGPath]];
    [shapeLayer setStrokeColor:[[UIColor blackColor] CGColor]];
    [shapeLayer setLineWidth:1.0f];
    
    [[self layer] addSublayer:shapeLayer];
}

@end
