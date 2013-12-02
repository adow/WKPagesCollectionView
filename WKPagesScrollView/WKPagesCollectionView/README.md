# WKPagesCollectionView

我尝试想做一个类似 iOS7 下的 safari tabs 页面那样的效果。

* 有页面翻转的效果;
* 点击一个页面变成正常的显示状态;
* 往左划动会删除这个cell;
* 可以在底部添加新的cell;

![最终效果](http://farm4.staticflickr.com/3829/11171831814_9c5972bbe6_z.jpg)



##实现滚动

我使用了UICollectionView来实现，本质上是一个垂直的列表，而主要的工作是来创造一个CollectionViewLayout, (我定义为WKPagesCollectionViewFlowLayout)每一个cell其实是和当前屏幕一样大小的，也就是说其实就是有一堆和屏幕一样大的cell错开折叠在一起，他们之间的间隔设置为`self.minimumLineSpacing=-1*(self.itemSize.height-160.0f);`。
![不翻转cell时](http://farm6.staticflickr.com/5521/11171968153_7a7aeb5893_z.jpg)

为了实现翻转的效果，我在WKPagesCollectionViewFlowLayout中的 
`-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect` 中修改了transform3D。

看上去貌似比较简单，而如果所有的页面都是固定的角度的话，的确也没问题，但是我想像safari里那样在滚动时有点视差的效果，所以就为每个页面设置了不同的翻转角度了，其实就是在layoutAttributesForElementsInRect 中根据每个cell的位置来计算角度使得他们在滚动条滚动时有点不同的角度，下面这个是设置角度的方法:

```
-(void)makeRotateTransformForAttributes:(UICollectionViewLayoutAttributes*)attributes{
    attributes.zIndex=attributes.indexPath.row;///要设置zIndex，否则遮挡顺序会有编号
    CGFloat distance=attributes.frame.origin.y-self.collectionView.contentOffset.y;
    CGFloat normalizedDistance = distance / self.collectionView.frame.size.height;
    normalizedDistance=fmaxf(normalizedDistance, 0.0f);
    CGFloat rotate=RotateDegree+15.0f*normalizedDistance;
    //CGFloat rotate=RotateDegree;
    NSLog(@"makeRotateTransformForAttributes:row:%d,normalizedDistance:%f,rotate:%f",
          attributes.indexPath.row,normalizedDistance,rotate);
    ///角度大的会和角度小的cell交叉，即使设置zIndex也没有用，这里设置底部的cell角度越来越大
    CATransform3D rotateTransform=WKFlipCATransform3DPerspectSimpleWithRotate(rotate);
    attributes.transform3D=rotateTransform;
    
}
```

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

后面我想做出safari那样按住其中一个cell往左滑动就删除的效果，我想这个应该也不难吧，在每个cell里面添加一个scrollView，然后scrollViewDidEndDragging 中达到一定距离的时候就触发删除好了，而UICollectionView中的performBatchUpdates就可以很好的完成删除的动画了。

![删除时的效果](http://farm4.staticflickr.com/3831/11171811316_c681d80cc2_z.jpg)

```
#pragma mark - WKPagesCollectionViewCellDelegate
-(void)removeCellAtIndexPath:(NSIndexPath *)indexPath{
    [_array removeObjectAtIndex:indexPath.row];
    [_collectionView performBatchUpdates:^{
        [_collectionView deleteItemsAtIndexPaths:@[indexPath,]];
    } completion:^(BOOL finished) {
    }];
}
```
一开始的时候就很好的完成了我要的效果了，随手删除几个时的效果就是这样，我想UICollectionView真的设计的很好，删除cell时居然如此简单就完成了动画过度，而我甚至没有去写传说中的那个 `-(UICollectionViewLayoutAttributes*)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath` 和 `-(UICollectionViewLayoutAttributes*)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath`

不过没多久我发现在删除最后几个cell的时候会发生一些意想不到的动画效果，滚动到底部，然后在模拟器下按下command+t打开慢速动画的时候就看的很清楚了，往左滑动来删除最后两个cell,在删除时一开始的效果是正常的，而几乎在完成之后，会看到一闪，出现了两个cell在很奇怪的位置，然后又动画慢慢回到预订的位置。

现在的问题就是，如果我删除带有button-0,button-1,button-2,button-3这样的cell，动画是正常的，但是如果我删除最后几个cell,带有button-6,button-7,button-8的，就会出现意想不到的动画。

这几天我一直在琢磨这个，也添加了`initialLayoutAttributesForAppearingItemAtIndexPath`和 `finalLayoutAttributesForDisappearingItemAtIndexPath`，但是这个问题还是会出现。实在是没有想法了，所以放到git上请大家看看是什么问题呢？

我发现如果我的cell的翻转角度如果是全部固定的，那在删除cell时是不会发生奇怪的动画的，我的makeRotateTransformForAttributes2中是指定了一个固定的角度。