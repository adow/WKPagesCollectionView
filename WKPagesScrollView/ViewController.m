//
//  ViewController.m
//  WKPagesScrollView
//
//  Created by 秦 道平 on 13-11-14.
//  Copyright (c) 2013年 秦 道平. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<WKPagesCollectionViewDataSource,WKPagesCollectionViewDelegate>{
    WKPagesCollectionView* _collectionView;
    NSMutableArray* _array;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _array=[[NSMutableArray alloc]init];
    for (int a=0; a<=30; a++) {
        [_array addObject:[NSString stringWithFormat:@"button %d",a]];
    }
    _collectionView=[[[WKPagesCollectionView alloc]initWithPagesFlowLayoutAndFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)] autorelease];
    _collectionView.dataSource=self;
    _collectionView.delegate=self;
    [_collectionView registerClass:[WKPagesCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:_collectionView];
    _collectionView.maskShow=YES;
    
    
    UIToolbar* toolBar=[[[UIToolbar alloc]initWithFrame:CGRectMake(0.0f, self.view.frame.size.height-50.0f, self.view.frame.size.width, 50.0f)] autorelease];
    toolBar.barStyle=UIBarStyleBlackTranslucent;
    toolBar.translucent=YES;
    toolBar.tintColor=[UIColor whiteColor];
    [self.view addSubview:toolBar];
    
    
    UIBarButtonItem* addButtonItem=[[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onButtonAdd:)] autorelease];
    toolBar.items=@[
                    [[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease],
                    addButtonItem,
                    [[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease],];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    [_array release];
    [_collectionView release];
    [super dealloc];
}
-(IBAction)onButtonTitle:(id)sender{
    NSLog(@"button");
    [_collectionView dismissFromHightLightWithCompletion:^(BOOL finished) {
        NSLog(@"dismiss completed");
    }];
}
-(IBAction)onButtonAdd:(id)sender{
    [_collectionView appendItem];
}
#pragma mark - UICollectionViewDataSource and UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _array.count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"cellForItemAtIndexPath:%d",indexPath.row);
    static NSString* identity=@"cell";
    WKPagesCollectionViewCell* cell=(WKPagesCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identity forIndexPath:indexPath];
    cell.collectionView=collectionView;
    UIImageView* imageView=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"image-0"]] autorelease];
    imageView.frame=self.view.bounds;
    [cell.cellContentView addSubview:imageView];
    UIButton* button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, (indexPath.row+1)*10+100, 320, 50.0f);
    button.backgroundColor=[UIColor whiteColor];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [button setTitle:_array[indexPath.row] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onButtonTitle:) forControlEvents:UIControlEventTouchUpInside];
    [cell.cellContentView addSubview:button];
    return cell;
}
#pragma mark WKPagesCollectionViewDataSource
///追加数据
-(void)willAppendItemInCollectionView:(WKPagesCollectionView *)collectionView{
    [_array addObject:@"new button"];
}
///删除数据
-(void)collectionView:(WKPagesCollectionView *)collectionView willRemoveCellAtIndexPath:(NSIndexPath *)indexPath{
    [_array removeObjectAtIndex:indexPath.row];
}
@end
