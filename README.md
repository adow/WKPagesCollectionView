# WKPagesCollectionView

我尝试想做一个类似 iOS7 下的 safari tabs 页面那样的效果。

* 有页面翻转的效果;
* 点击一个页面变成正常的显示状态;
* 往左划动会删除这个cell;
* 可以在底部添加新的cell;

下面链接是实现的效果视频:

[![效果视频](http://farm4.staticflickr.com/3829/11171831814_9c5972bbe6_z.jpg)](http://v.youku.com/v_show/id_XNjQ0NzM3Nzky.html)

##使用
* 项目中添加 WKPagesCollectionView目录以及下面的`WK.h`, `WKPagesCollectionView.h`, `WKPagesCollectionView.m`, `WKPagesCollectionViewCell.h`, `WKPagesCollectionViewCell.m`, `WKPagesCollectionViewFlowLayout.h`, `WKPagesCollectionViewFlowLayout.m`;
* 引用 `WKPagesCollectionView`;
* 准备数据

		_array=[[NSMutableArray alloc]init];
	    for (int a=0; a<=30; a++) {
	        [_array addObject:[NSString stringWithFormat:@"button %d",a]];
	    }

* 创建collectionView

		_collectionView=[[[WKPagesCollectionView alloc]initWithPagesFlowLayoutAndFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)] autorelease];
	    _collectionView.dataSource=self;
	    _collectionView.delegate=self;
	    [_collectionView registerClass:[WKPagesCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
	    [self.view addSubview:_collectionView];
	    _collectionView.maskShow=YES;


* 完成WKPagesCollectionViewDataSource(继承自UICollectionViewDataSource) 和 WKPagesCollectionViewDelegate(继承自UICollectionViewDelegate), 除了要完成UICollectionViewDataSource中提供数据的方法外，还要完成追加数据的方法`-(void)willAppendItemInCollectionView:(WKPagesCollectionView *)collectionView`
和删除数据的方法`
-(void)collectionView:(WKPagesCollectionView *)collectionView willRemoveCellAtNSIndexPath:(NSIndexPath *)indexPath`

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
		-(void)collectionView:(WKPagesCollectionView *)collectionView willRemoveCellAtNSIndexPath:(NSIndexPath *)indexPath{
		    [_array removeObjectAtIndex:indexPath.row];
		}

* 添加一个页面时的操作

		-(IBAction)onButtonAdd:(id)sender{
		    [_collectionView appendItem];
		}
		
* 展开显示一个具体的页面,这个在点击页面的时候会自动实现，也可以像下面这样代码调用;

		[_collectionView showCellToHighLightAtIndexPath:indexPath completion:^(BOOL finished) {
	        NSLog(@"highlight completed");
    	}];
    	
* 停止展开，回到普通的滚动模式

		-(IBAction)onButtonTitle:(id)sender{
		    NSLog(@"button");
		    [_collectionView dismissFromHightLightWithCompletion:^(BOOL finished) {
		        NSLog(@"dismiss completed");
		    }];
		}

##TODO
* `bug` <s>每滚动几个时候顶上的那一个就会先看不见然后又突然出现了，还没想到原因</s> 这个问题已经解决，@Nikolay Abelyashev 修复了这个bug,原因是由于WKPagesCollectionView的高度太小，而UICollectionView会把屏幕外的cell不在显示，在WKPagesCollectionView中，屏幕外的3个cell会被取消显示，解决的办法是修改WKPagesCollectionView的frame，使他高出window（这里添加了 topOfScreen:120.0f）,然后把frame.origin.y也往上移动了那么多距离，这样WKPagesCollectionView其实就更大;



##实现的方式
###实现滚动

我使用了UICollectionView来实现，本质上是一个垂直的列表，而主要的工作是来创造一个CollectionViewLayout, (我定义为WKPagesCollectionViewFlowLayout)每一个cell其实是和当前屏幕一样大小的，也就是说其实就是有一堆和屏幕一样大的cell错开折叠在一起，他们之间的间隔设置为`self.minimumLineSpacing=-1*(self.itemSize.height-160.0f);`。
![不翻转cell时](http://farm6.staticflickr.com/5521/11171968153_7a7aeb5893_z.jpg)

为了实现翻转的效果，我在WKPagesCollectionViewFlowLayout中的 
`-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect` 中修改了transform3D。

看上去貌似比较简单，而如果所有的页面都是固定的角度的话，的确也没问题，但是我想像safari里那样在滚动时有点视差的效果，所以就为每个页面设置了不同的翻转角度了，其实就是在layoutAttributesForElementsInRect 中根据每个cell的位置来计算角度使得他们在滚动条滚动时有点不同的角度，下面这个是设置角度的方法:


		-(void)makeRotateTransformForAttributes:(UICollectionViewLayoutAttributes*)attributes{
		    attributes.zIndex=attributes.indexPath.row;///要设置zIndex，否则遮挡顺序会有编号
		    CGFloat distance=attributes.frame.origin.y-self.collectionView.contentOffset.y;
		    CGFloat normalizedDistance = distance / self.collectionView.frame.size.height;
		    normalizedDistance=fmaxf(normalizedDistance, 0.0f);
		    CGFloat rotate=RotateDegree+20.0f*normalizedDistance;
		    //CGFloat rotate=RotateDegree;
		    NSLog(@"makeRotateTransformForAttributes:row:%d,normalizedDistance:%f,rotate:%f",
		          attributes.indexPath.row,normalizedDistance,rotate);
		    ///角度大的会和角度小的cell交叉，即使设置zIndex也没有用，这里设置底部的cell角度越来越大
		    CATransform3D rotateTransform=WKFlipCATransform3DPerspectSimpleWithRotate(rotate);
		    attributes.transform3D=rotateTransform;
		    
		}

```
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)path
{
    NSLog(@"layoutAttributesForItemAtIndexPath:%d",path.row);
    UICollectionViewLayoutAttributes* attributes=[super layoutAttributesForItemAtIndexPath:path];
    [self makeRotateTransformForAttributes:attributes];
    return attributes;
}
-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSLog(@"layoutAttributesForElementsInRect:%@",NSStringFromCGRect(rect));
    NSArray* array = [super layoutAttributesForElementsInRect:rect];
    for (UICollectionViewLayoutAttributes* attributes in array) {
        [self makeRotateTransformForAttributes:attributes];
    }
    return array;
}
```

现在运行的时候，滚动起来就和想要的效果差不多了，虽然不如safari那么细节完美，大概的意思是达到了。

##实现删除

后面我想做出safari那样按住其中一个cell往左滑动就删除的效果，在每个cell里面添加一个scrollView，然后scrollViewDidEndDragging 中达到一定距离的时候就触发删除好了，而UICollectionView中的performBatchUpdates就可以很好的完成删除的动画了。

![删除时的效果](http://farm4.staticflickr.com/3831/11171811316_c681d80cc2_z.jpg)

		-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
		    if (self.showingState==WKPagesCollectionViewCellShowingStateNormal){
		        if (scrollView.contentOffset.x>=90.0f){
		            NSIndexPath* indexPath=[self.collectionView indexPathForCell:self];
		            NSLog(@"delete cell at %d",indexPath.row);
		            //self.alpha=0.0f;
		            ///删除数据
		            id<WKPagesCollectionViewDataSource> pagesDataSource=(id<WKPagesCollectionViewDataSource>)self.collectionView.dataSource;
		            [pagesDataSource collectionView:(WKPagesCollectionView*)self.collectionView willRemoveCellAtNSIndexPath:indexPath];
		            ///动画
		            [self.collectionView performBatchUpdates:^{
		                [self.collectionView deleteItemsAtIndexPaths:@[indexPath,]];
		            } completion:^(BOOL finished) {
		                
		            }];
		        }
		    }
		}

为了添加和删除的时候动画的好看一点，我们还得修改
`(UICollectionViewLayoutAttributes*)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath` 和 `-(UICollectionViewLayoutAttributes*)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath`

我在WKPagesCollectionViewFlowLayout 中添加了insertIndexPaths 和 deleteIndexPaths 来记录用来添加和删除的位置,因为这个两个回调在添加和删除时会被调用，而且不仅仅是针对正在添加或者删除的NSIndexPath,其他行也会被调用，而我们这里只要处理正在添加和删除的NSIndexPath;

		-(UICollectionViewLayoutAttributes*)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath{
		    UICollectionViewLayoutAttributes* attributes=[super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
		    NSLog(@"initialLayoutAttributesForAppearingItemAtIndexPath:%d",itemIndexPath.row);
		    if ([self.insertIndexPaths containsObject:itemIndexPath]){
		        if (!attributes)
		            attributes=[self layoutAttributesForItemAtIndexPath:itemIndexPath];
		        CATransform3D rotateTransform=WKFlipCATransform3DPerspectSimpleWithRotate(-90.0f);
		        attributes.transform3D=rotateTransform;
		    }
		    return attributes;
		}
		-(UICollectionViewLayoutAttributes*)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath{
		    NSLog(@"finalLayoutAttributesForDisappearingItemAtIndexPath:%d",itemIndexPath.row);
		    UICollectionViewLayoutAttributes* attributes=[super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
		    if ([self.deleteIndexPaths containsObject:itemIndexPath]){
		        if (!attributes){
		            attributes=[self layoutAttributesForItemAtIndexPath:itemIndexPath];
		        }
		        CATransform3D moveTransform=CATransform3DMakeTranslation(-320.0f, 0.0f, 0.0f);
		        attributes.transform3D=CATransform3DConcat(attributes.transform3D, moveTransform);
		    }    
		    return attributes;
		    
		}


开始的时候会发生一些意想不到的动画效果，滚动到底部，然后在模拟器下按下command+t打开慢速动画的时候就看的很清楚了，往左滑动来删除最后两个cell,在删除时一开始的效果是正常的，而几乎在完成之后，会看到一闪，出现了两个cell在很奇怪的位置，然后又动画慢慢回到预订的位置。

现在的问题就是，如果我删除带有button-0,button-1,button-2,button-3这样的cell，动画是正常的，但是如果我删除最后几个cell,带有button-6,button-7,button-8的，就会出现意想不到的动画。

而且我发现如果我的cell的翻转角度如果是全部固定的，那在删除cell时是不会发生奇怪的动画的，我的makeRotateTransformForAttributes2中是指定了一个固定的角度。

####Fixed

后来终于知道问题在哪里了，只是由于contentSize计算错误导致内容区域不够所以在删除cell后又自动滚动时产生了奇怪的行为，所以`-(CGSize)collectionViewContentSize`中的高度一定要正确。

###实现添加页面

现在页面有两种状态，一种就是这种普通的滚动页面的状态，当点击某一个页面的时候，他会翻转到全屏显示，这时我称作是`highlight`。如果只是在普通的滚动状态下，会先滚动到屏幕地步，然后添加一个页面，之后又会把这个页面展开到highLight显示状态。而如果现在整个collectionView本身就已经有一个页面在hightLight了，那应该先退回到普通状态，再重复之前的添加页面过程。

下面是在WKPagesCollectionView中的添加页面的方法;

		///追加一个页面
		-(void)appendItem{
		    if (self.isHighLight){
		        [self dismissFromHightLightWithCompletion:^(BOOL finished) {
		            [self _addNewPage];
		        }];
		    }
		    else{
		        [self _addNewPage];
		    }
		}
		///添加一页
		-(void)_addNewPage{
		    int total=[self numberOfItemsInSection:0];
		    [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:total-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
		    double delayInSeconds = 0.3f;
		    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
		    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
		        ///添加数据
		        [(id<WKPagesCollectionViewDataSource>)self.dataSource willAppendItemInCollectionView:self];
		        int lastRow=total;
		        NSIndexPath* insertIndexPath=[NSIndexPath indexPathForItem:lastRow inSection:0];
		        [self performBatchUpdates:^{
		            [self insertItemsAtIndexPaths:@[insertIndexPath]];
		        } completion:^(BOOL finished) {
		            double delayInSeconds = 0.3f;
		            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
		            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
		                [self showCellToHighLightAtIndexPath:insertIndexPath completion:^(BOOL finished) {
		                    
		                }];
		            });
		            
		        }];
		    });
		}