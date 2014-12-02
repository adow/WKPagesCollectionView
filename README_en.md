# WKPagesCollectionView

I wanted to implement an UI effect like iOS7 Safari tabs pages.

* Page-flipping effect;
* Click on a page then can put it into a normal display state;
* Scratch to left can delete the cell;
* You can add a new cell at the bottom;

[See video](http://v.youku.com/v_show/id_XNzAzNDg4OTQ4.html)

![Effect video](http://farm4.staticflickr.com/3829/11171831814_9c5972bbe6_z.jpg)]



##Usage
* Add `WKPagesCollectionView` folder and the following files inside it to project :`WK.h`, `WKPagesCollectionView.h`, `WKPagesCollectionView.m`, `WKPagesCollectionViewCell.h`, `WKPagesCollectionViewCell.m`, `WKPagesCollectionViewFlowLayout.h`, `WKPagesCollectionViewFlowLayout.m`;
* Import `WKPagesCollectionView`;
* Prepare data

		_array=[[NSMutableArray alloc]init];
	    for (int a=0; a<=30; a++) {
	        [_array addObject:[NSString stringWithFormat:@"button %d",a]];
	    }

* Create `collectionView`

		_collectionView=[[[WKPagesCollectionView alloc]initWithPagesFlowLayoutAndFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)] autorelease];
	    _collectionView.dataSource=self;
	    _collectionView.delegate=self;
	    [_collectionView registerClass:[WKPagesCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
	    [self.view addSubview:_collectionView];
	    _collectionView.maskShow=YES;


* Implement `WKPagesCollectionViewDataSource`(inherited from `UICollectionViewDataSource`) and `WKPagesCollectionViewDelegate`(inherited from `UICollectionViewDelegate`), in addition of these, also need to provide methods of append item and remove item : 
`-(void)willAppendItemInCollectionView:(WKPagesCollectionView *)collectionView` 
and `-(void)collectionView:(WKPagesCollectionView *)collectionView willRemoveCellAtNSIndexPath:(NSIndexPath *)indexPath`

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
		///append item
		-(void)willAppendItemInCollectionView:(WKPagesCollectionView *)collectionView{
		    [_array addObject:@"new button"];
		}
		///remove item
		-(void)collectionView:(WKPagesCollectionView *)collectionView willRemoveCellAtNSIndexPath:(NSIndexPath *)indexPath{
		    [_array removeObjectAtIndex:indexPath.row];
		}

* Append a page by press button

		-(IBAction)onButtonAdd:(id)sender{
		    [_collectionView appendItem];
		}
		
* Expand to display a specific page. this will be triggered when clicking the page, the code be invoked as follows;

		[_collectionView showCellToHighLightAtIndexPath:indexPath completion:^(BOOL finished) {
	        NSLog(@"highlight completed");
    	}];
    	
* Stop expand the page and back to normal mode(tab mode)

		-(IBAction)onButtonTitle:(id)sender{
		    NSLog(@"button");
		    [_collectionView dismissFromHightLightWithCompletion:^(BOOL finished) {
		        NSLog(@"dismiss completed");
		    }];
		}

##TODO
* `bug` ~~When roll the tab several times, the top page will be first invisible and then suddenly appeared, did not found the reason~~ This problem has been solved by @ Nikolay Abelyashev. The root cause is due to the too small height of WKPagesCollectionView, and the `UICollectionView` will not display cells outside the device screen. In `WKPagesCollectionView` the three cells outside the screen will not be displayed. The solution is to modify the frame of `WKPagesCollectionView` , so that the height will higher than the device window (here add `topOfScreen: 120.0f`), then the `frame.origin.y` also adds up that distance, so in fact the `WKPagesCollectionView` is larger than the window.


##Way to implement
###Implement scroll

I used `UICollectionView` to implement the scroll, this is essentially a vertical list, and the main part is a `CollectionViewLayout`. (I define it as `WKPagesCollectionViewFlowLayout`) each cell have the same size of device screen, that is actually a pile of screen size cells stagger folded together, and the space between them is `self.minimumLineSpacing = -1 * (self.itemSize.height-160.0f);`.

![When not flip cell](http://farm6.staticflickr.com/5521/11171968153_7a7aeb5893_z.jpg)

In order to achieve the flipping effect, in the function 
`-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect` of WKPagesCollectionViewFlowLayout, I modify the transform3D.

Looks simple, but if all the pages have fixed angle, then its ok, but I imagine that like safari when scroll the page, there have a little parallax effect, so I set up a different flip angles for each page. In fact, is in `layoutAttributesForElementsInRect` function, base on the position of each cell calculate the angle so that when they scroll there have a little different perspective. the following is the code to set the angle:

		-(void)makeRotateTransformForAttributes:(UICollectionViewLayoutAttributes*)attributes{
		    attributes.zIndex=attributes.indexPath.row;///Set the zIndex, to implement sequential occlusion
		    CGFloat distance=attributes.frame.origin.y-self.collectionView.contentOffset.y;
		    CGFloat normalizedDistance = distance / self.collectionView.frame.size.height;
		    normalizedDistance=fmaxf(normalizedDistance, 0.0f);
		    CGFloat rotate=RotateDegree+20.0f*normalizedDistance;
		    //CGFloat rotate=RotateDegree;
		    NSLog(@"makeRotateTransformForAttributes:row:%d,normalizedDistance:%f,rotate:%f",
		          attributes.indexPath.row,normalizedDistance,rotate);
		    ///Bigger angle cell will have cross with smaller angle cell, even set the zIndex. Here set the lower cell have the bigger angle.
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

Now have the desired effect, although not so perfect like Safari's.

##Implement delete item

Later I want to implement the delete item effect which like Safari's: hold on one of the cell and slide left then can remove it. I add a scrollView in every cell, in function of `scrollViewDidEndDragging`, when slide to left reach a certain distance then trigger the delete function. The animation effect of removing was implemented in UICollectionView's `performBatchUpdates` function.

![The UI effect of deletion.](http://farm4.staticflickr.com/3831/11171811316_c681d80cc2_z.jpg)

		-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
		    if (self.showingState==WKPagesCollectionViewCellShowingStateNormal){
		        if (scrollView.contentOffset.x>=90.0f){
		            NSIndexPath* indexPath=[self.collectionView indexPathForCell:self];
		            NSLog(@"delete cell at %d",indexPath.row);
		            //self.alpha=0.0f;
		            ///Remove item
		            id<WKPagesCollectionViewDataSource> pagesDataSource=(id<WKPagesCollectionViewDataSource>)self.collectionView.dataSource;
		            [pagesDataSource collectionView:(WKPagesCollectionView*)self.collectionView willRemoveCellAtNSIndexPath:indexPath];
		            ///Animation
		            [self.collectionView performBatchUpdates:^{
		                [self.collectionView deleteItemsAtIndexPaths:@[indexPath,]];
		            } completion:^(BOOL finished) {
		                
		            }];
		        }
		    }
		}

To make the animation effect of add and delete item look better, we have to modify
`(UICollectionViewLayoutAttributes*)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath` 
and `-(UICollectionViewLayoutAttributes*)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath`

I add insertIndexPaths and deleteIndexPaths functions in WKPagesCollectionViewFlowLayout, to record the position when add and remove item. The two callback functions will be called not just for being added or deleted NSIndexPath, and will be called at another place.

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


Beginning will be some unexpected animation, scrolling to the end, and then press command + t to open slow animations in simulator can see very clearly. When slide left to remove the last two cell, at the beginning of remove effect it works normal, but when almost complete the remove effect, will see one flash happened at a very strange position between two cells, and then slowly return to the normal animation.

Now the question is, if I remove the cell of button-0, button-1, button-2, button-3, the animation is OK, but if I delete the last several cell of button-6, button -7, button-8, it will appear unexpected animation.

And I found that if the flip angle is all fixed, then when delete cell, there will not have strange animation, my `makeRotateTransformForAttributes2` is assigned a fixed angle.
####Fixed

Then finally know where the problem lies, just because the miscalculation of contentSize leading to the lack of content area, so when the cell is deleted and then rolling will produce this behaviour. so the height which be set in `- (CGSize) collectionViewContentSize` must be correct.

###Implement add page

Now the `WKPagesCollectionView` have two states, one is `normal` state, another is  `highlight` state. At normal state, one can scroll the pages. When tap on one page, it will trigger to transfer to `highlight` state. In highlight state the page be tapped will be displayed in full screen.

When you go to add a new page, you need to press `+` which at the bottom of screen to add a page, then the last page which be added will be displayed in full screen(`highlight` state). If currently is in `highlight` state, it will back to `normal` state and then transfer to `highlight` state to display the last page in full screen.

Here is add page method in `WKPagesCollectionView`:

		///Append an item
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
		///Add a new page
		-(void)_addNewPage{
		    int total=[self numberOfItemsInSection:0];
		    [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:total-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
		    double delayInSeconds = 0.3f;
		    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
		    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
		        ///Add an item
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
