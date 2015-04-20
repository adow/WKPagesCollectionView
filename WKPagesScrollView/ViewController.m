//
//  ViewController.m
//  WKPagesScrollView
//
//  Created by 秦 道平 on 13-11-14.
//  Copyright (c) 2013年 秦 道平. All rights reserved.
//

#import "ViewController.h"

static NSString *CellReuseIdentifier = @"CellReuseIdentifier";

@interface ViewController ()<WKPagesCollectionViewDataSource,WKPagesCollectionViewDelegate>

@property (nonatomic, strong) WKPagesCollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *items;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.items = [[NSMutableArray alloc] init];
    
    for (NSUInteger a = 0; a <= 30; a++) {
        [self.items addObject:[NSString stringWithFormat:@"button %lu",(unsigned long)a]];
    }
    
    self.collectionView = [[WKPagesCollectionView alloc] initWithFrame:self.view.bounds];
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    [self.collectionView registerClass:[WKPagesCollectionViewCell class] forCellWithReuseIdentifier:CellReuseIdentifier];
    [self.view addSubview:self.collectionView];
    self.collectionView.maskShow = YES;
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.height - 50.0, self.view.frame.size.width, 50.0)];
    toolBar.barStyle = UIBarStyleBlackTranslucent;
    toolBar.translucent = YES;
    toolBar.tintColor = [UIColor whiteColor];
    [self.view addSubview:toolBar];
    
    UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onButtonAdd:)];
    UIBarButtonItem *flexibleSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    toolBar.items = @[flexibleSpaceItem,
                      addButtonItem,
                      flexibleSpaceItem];
}

- (IBAction)onButtonTitle:(id)sender
{
    UIView *thisButton = (UIView *)sender;
    if (!self.collectionView.isHighLight) {
        NSArray *visibleIndexPaths = [self.collectionView indexPathsForVisibleItems];
        for (NSIndexPath *indexPath in visibleIndexPaths) {
            WKPagesCollectionViewCell *cell = (WKPagesCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
            BOOL doesContain = [cell.cellContentView.subviews containsObject:thisButton];
            if (doesContain) {
                [self.collectionView showCellToHighLightAtIndexPath:indexPath completion:^(BOOL finished) {
                    NSLog(@"highlight completed");
                }];
                break;
            }
        }
    } else {
        [self.collectionView dismissFromHightLightWithCompletion:^(BOOL finished) {
            NSLog(@"dismiss completed");
        }];
    }
}

- (IBAction)onButtonAdd:(id)sender
{
    [self.collectionView appendItem];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WKPagesCollectionViewCell *cell = (WKPagesCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellReuseIdentifier forIndexPath:indexPath];
    cell.collectionView = collectionView;
    
    UIImageView* imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"image-0"]];
    imageView.frame = self.view.bounds;
    [cell.cellContentView addSubview:imageView];
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.0, 100.0, self.view.bounds.size.width, 50.0);
    button.backgroundColor = [UIColor whiteColor];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [button setTitle:self.items[indexPath.row] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onButtonTitle:) forControlEvents:UIControlEventTouchUpInside];
    [cell.cellContentView addSubview:button];
  
    return cell;
}

#pragma mark - WKPagesCollectionViewDataSource

- (void)willAppendItemInCollectionView:(WKPagesCollectionView *)collectionView
{
    [self.items addObject:@"new button"];
}

- (void)collectionView:(WKPagesCollectionView *)collectionView willRemoveCellAtIndexPath:(NSIndexPath *)indexPath
{
    [self.items removeObjectAtIndex:indexPath.row];
}

@end