//
//  ViewController.m
//  WKPagesScrollView
//
//  Created by 秦 道平 on 13-11-14.
//  Copyright (c) 2013年 秦 道平. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>{
    UIButton* _button;
    WKPagesCollectionView* _collectionView;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _collectionView=[[[WKPagesCollectionView alloc]initWithPagesFlowLayoutAndFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)] autorelease];
    _collectionView.dataSource=self;
    _collectionView.delegate=self;
    [_collectionView registerClass:[WKPagesCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:_collectionView];
    
    _button=[[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _button.frame=CGRectMake(10.0f, 20.0f, 300.0f, 50.0f);
    _button.backgroundColor=[UIColor whiteColor];
    [_button setTitle:@"cancel" forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(onButtonDismiss:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];
    
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    [_button release];
    [_collectionView release];
    [super dealloc];
}
-(IBAction)onButtonDismiss:(id)sender{
    [_collectionView dismissFromHightLight];
}
#pragma mark - UICollectionViewDataSource and UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* identity=@"cell";
    WKPagesCollectionViewCell* cell=(WKPagesCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identity forIndexPath:indexPath];
    cell.collectionView=collectionView;
    cell.clipsToBounds=NO;
    UIImageView* imageView=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"weather-default-bg"]] autorelease];
    [cell.cellContentView addSubview:imageView];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [(WKPagesCollectionView*)collectionView showCellToHighLightAtIndexPath:indexPath];
}
@end
