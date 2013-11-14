//
//  ViewController.m
//  WKPagesScrollView
//
//  Created by 秦 道平 on 13-11-14.
//  Copyright (c) 2013年 秦 道平. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    WKFlipView* flipView=[[[WKFlipView alloc]initWithFrame:self.view.bounds] autorelease];
    flipView.backgroundColor=[UIColor lightTextColor];
    UIImageView* imageView=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"weather-default-bg"]] autorelease];
    imageView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [flipView addSubview:imageView];
    [self.view addSubview:flipView];
    
    UIView* secondView=[[[UIView alloc]initWithFrame:self.view.bounds] autorelease];
    secondView.backgroundColor=[UIColor darkGrayColor];
    [self.view addSubview:secondView];
    
    UIImageView* thirdView=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"image-1107"]] autorelease];
    thirdView.frame=self.view.bounds;
    [self.view addSubview:thirdView];
    
    [UIView animateWithDuration:0.3f delay:2.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        CATransform3D flipTransform=WKFlipCATransform3DPerspectSimpleWithRotate(-30.0f);
        flipView.layer.transform=CATransform3DConcat(flipTransform, CATransform3DMakeTranslation(0.0f, -60.0f, 0.0f));
        
        secondView.layer.transform=flipTransform;
        
        thirdView.layer.transform=CATransform3DConcat(flipTransform, CATransform3DMakeTranslation(0.0f, 60.0f, 0.0f));
        
    } completion:^(BOOL finished) {
        
    }];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
