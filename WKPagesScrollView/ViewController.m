//
//  ViewController.m
//  WKPagesScrollView
//
//  Created by 秦 道平 on 13-11-14.
//  Copyright (c) 2013年 秦 道平. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//    WKFlipView* flipView=[[[WKFlipView alloc]initWithFrame:self.view.bounds] autorelease];
//    flipView.backgroundColor=[UIColor lightTextColor];
//    UIImageView* imageView=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"weather-default-bg"]] autorelease];
//    imageView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//    [flipView addSubview:imageView];
//    [self.view addSubview:flipView];
//    
//    UIView* secondView=[[[UIView alloc]initWithFrame:self.view.bounds] autorelease];
//    secondView.backgroundColor=[UIColor darkGrayColor];
//    [self.view addSubview:secondView];
//    
//    UIImageView* thirdView=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"image-1107"]] autorelease];
//    thirdView.frame=self.view.bounds;
//    [self.view addSubview:thirdView];
//    
//    [UIView animateWithDuration:0.3f delay:2.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
//        CATransform3D flipTransform=WKFlipCATransform3DPerspectSimpleWithRotate(-30.0f);
//        flipView.layer.transform=CATransform3DConcat(flipTransform, CATransform3DMakeTranslation(0.0f, -60.0f, 0.0f));
//        
//        secondView.layer.transform=flipTransform;
//        
//        thirdView.layer.transform=CATransform3DConcat(flipTransform, CATransform3DMakeTranslation(0.0f, 60.0f, 0.0f));
//        
//    } completion:^(BOOL finished) {
//        
//    }];
    
    UICollectionViewFlowLayout* flowLayout=[[[UICollectionViewFlowLayout alloc]init] autorelease];
    flowLayout.scrollDirection=UICollectionViewScrollDirectionVertical;
    
    WKPagesCollectionViewFlowLayout* pageLayout=[[[WKPagesCollectionViewFlowLayout alloc]init] autorelease];
    
    UICollectionView* collectionView=[[[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:pageLayout] autorelease];
    collectionView.dataSource=self;
    collectionView.delegate=self;
    [collectionView registerClass:[WKPagesCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:collectionView];
    [pageLayout invalidateLayout];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    [super dealloc];
}
#pragma mark - UICollectionViewDataSource and UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 30;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* identity=@"cell";
    WKPagesCollectionViewCell* cell=(WKPagesCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identity forIndexPath:indexPath];
    cell.collectionView=collectionView;
    cell.backgroundColor=[UIColor lightGrayColor];
    UIImageView* imageView=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"weather-default-bg"]] autorelease];
    [cell.contentView addSubview:imageView];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [UIView animateWithDuration:1.0f delay:1.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        [collectionView.visibleCells enumerateObjectsUsingBlock:^(WKPagesCollectionViewCell* cell, NSUInteger idx, BOOL *stop) {
            NSIndexPath* visibleIndexPath=[collectionView indexPathForCell:cell];
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
        [UIView animateWithDuration:1.0f delay:3.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
           [collectionView.visibleCells enumerateObjectsUsingBlock:^(WKPagesCollectionViewCell* cell, NSUInteger idx, BOOL *stop) {
               cell.showingState=WKPagesCollectionViewCellShowingStateNormal;
           }];
        } completion:^(BOOL finished) {
            
        }];
    }];
    
}
@end
