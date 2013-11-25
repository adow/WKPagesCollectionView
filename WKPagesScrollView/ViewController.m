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
-(IBAction)onButtonTitle:(id)sender{
    NSLog(@"button");
}
#pragma mark - UICollectionViewDataSource and UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 30;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* identity=@"cell";
    WKPagesCollectionViewCell* cell=(WKPagesCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identity forIndexPath:indexPath];
    cell.collectionView=collectionView;
    cell.clipsToBounds=NO;
//    UIImageView* imageView=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"image-%d",indexPath.row]]] autorelease];
    UIImageView* imageView=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"image-0"]] autorelease];
    imageView.frame=self.view.bounds;
    [cell.cellContentView addSubview:imageView];
    UIButton* button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, (indexPath.row+1)*10+100, 320, 50.0f);
    button.backgroundColor=[UIColor whiteColor];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [button setTitle:[NSString stringWithFormat:@"button %d",indexPath.row] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onButtonTitle:) forControlEvents:UIControlEventTouchUpInside];
    [cell.cellContentView addSubview:button];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [(WKPagesCollectionView*)collectionView showCellToHighLightAtIndexPath:indexPath];
}
@end
