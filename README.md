# LoopingScrollView
Looping AD ScrollView

## Requirements

* Xcode 6
* iOS 5.0+
* ARC
* 

## Config
  AdviewTimerInterval: Time Interval to go to next page;
  pageControlIndicatorTintColor;
  pageControlcurrentIndicatorTintColor;

##Usage
============
```
- (void)loadAdView
{
    NSMutableArray *imgArr = [NSMutableArray array];
    for (int i = 1; i <= 7; i++) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        NSString *key = [NSString stringWithFormat:@"%d.png", i];
        [dict setValue:key forKey:@"imageName"];
        
        [dict setValue:[UIImage imageNamed:key] forKey:@"image"];
        
        [imgArr addObject:dict];
    }
    
    SGLoopingScrollView *loopingScrollView = [[SGLoopingScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
    loopingScrollView.delegate = self;
    loopingScrollView.items = imgArr;
    
    [self.view addSubview:loopingScrollView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(60, 300, 200, 200)];
    self.imageView = imageView;
    [self.view addSubview:imageView];
}

#pragma mark - LoopScrollViewDelegate
- (void)itemTab:(NSDictionary *)item
{
    self.imageView.image = [item valueForKey:@"image"];;
}

- (UIImage *)imageFromItem:(NSDictionary *)item
{
    return [item valueForKey:@"image"];
}

```
