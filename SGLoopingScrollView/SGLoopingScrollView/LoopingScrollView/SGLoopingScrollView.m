//
//  SGLoopingScrollView.m
//  SGLoopingScrollView
//
//  Created by ZhengXiankai on 15/5/17.
//  Copyright (c) 2015年 ZhengXiankai. All rights reserved.
//


#import "SGLoopingScrollView.h"
#define AdviewTimerInterval 2

@interface SGLoopingScrollView ()
{
    int _currentIndex;
    NSTimer *_timer;
}

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIPageControl *pageControl;
@property (nonatomic, weak) UIImageView *leftImageView;
@property (nonatomic, weak) UIImageView *centerImageView;
@property (nonatomic, weak) UIImageView *rightImageView;

@end

@implementation SGLoopingScrollView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _currentIndex = 0;
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        scrollView.delegate = self;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.pagingEnabled = YES;
        scrollView.bounces = NO;
        
        
        UITapGestureRecognizer *tapGestureRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureRecognizer:)];
        tapGestureRecognize.numberOfTapsRequired = 1;
        
        [scrollView addGestureRecognizer:tapGestureRecognize];
        
        
        self.scrollView = scrollView;
        
        
        UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        UIImageView *centerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width, 0, frame.size.width, frame.size.height)];
        UIImageView *rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width * 2, 0, frame.size.width, frame.size.height)];
        
        self.leftImageView = leftImageView;
        self.centerImageView = centerImageView;
        self.rightImageView = rightImageView;
        
        [self.scrollView addSubview:leftImageView];
        [self.scrollView addSubview:centerImageView];
        [self.scrollView addSubview:rightImageView];
        
        self.scrollView.contentSize = CGSizeMake(frame.size.width * 3, frame.size.height);
        
        
        UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, frame.size.height - 36, frame.size.width, 36)];
        pageControl.pageIndicatorTintColor = [UIColor grayColor];
        pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        [self.pageControl setHidden:YES];
        self.pageControl = pageControl;
        
        [self addSubview:self.scrollView];
        [self addSubview:self.pageControl];
    }
    
    return self;
}

- (void)setItems:(NSArray *)items{
    _items = items;
    self.pageControl.numberOfPages = items.count;
    _currentIndex = 0;
    [self setImage:_currentIndex];
    
    if (items.count > 1) {
        self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width * 3, self.scrollView.bounds.size.height);
        self.scrollView.contentOffset = CGPointMake(self.scrollView.bounds.size.width, 0);
        
        [self startTimer];
        [self.pageControl setHidden:NO];
    }
    else{
        self.scrollView.contentSize = self.scrollView.frame.size;
        self.scrollView.contentOffset = CGPointMake(0, 0);
        [self.pageControl setHidden:YES];
    }
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [self stopTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self startTimer];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"scroll");
    if (self.scrollView.contentOffset.x > self.scrollView.frame.size.width * 1.5) {
        
        self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x - self.scrollView.frame.size.width, 0);
        
        if (_currentIndex < self.items.count - 1) {
            _currentIndex = _currentIndex + 1;
        }else{
            _currentIndex = 0;
        }
        
        [self setImage:_currentIndex];
        
    }else if(self.scrollView.contentOffset.x < self.scrollView.frame.size.width * 0.5){
        
        self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x + self.scrollView.frame.size.width, 0);
        
        if (_currentIndex > 0) {
            _currentIndex = _currentIndex - 1;
        }else{
            _currentIndex = self.items.count - 1;
        }
        
        
        [self setImage:_currentIndex];
    }
}

#pragma mark - TapGestureRecognizer
- (void)singleTapGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    id item = [self.items objectAtIndex:_currentIndex];
    if (self.delegate && [self.delegate respondsToSelector:@selector(itemTab:)]) {
        [self.delegate itemTab:item];
    }
}

#pragma mark - private method
- (void)setImage:(NSInteger)index{
    self.centerImageView.image = [self getImageFromItem:[self.items objectAtIndex:index]];
    
    if (index == 0) {
        self.leftImageView.image = [self getImageFromItem:[self.items lastObject]];
    }else{
        self.leftImageView.image = [self getImageFromItem:[self.items objectAtIndex:index - 1]];
    }
    
    if (index == self.items.count - 1) {
        self.rightImageView.image = [self getImageFromItem:[self.items firstObject]];
    }else{
        self.rightImageView.image = [self getImageFromItem:[self.items objectAtIndex:index + 1]];
    }
    
    self.pageControl.currentPage = _currentIndex;
    [self.pageControl updateCurrentPageDisplay];
}


- (UIImage *)getImageFromItem:(id)item{
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageFromItem:)]) {
        return [self.delegate imageFromItem:item];
    }else{
        return item;
    }
}

- (void)startTimer{
    // 定时器 循环
    _timer = [NSTimer scheduledTimerWithTimeInterval:AdviewTimerInterval target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    //5秒后开启
    [_timer setFireDate:[[NSDate alloc] initWithTimeIntervalSinceNow:AdviewTimerInterval]];
}

-(void)stopTimer{
    [_timer invalidate];
    _timer = nil;
}

- (void)nextPage{
    [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.frame.size.width * 2, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height) animated:YES];
}

@end
