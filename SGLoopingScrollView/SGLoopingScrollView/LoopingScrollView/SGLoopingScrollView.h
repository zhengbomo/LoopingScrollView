//
//  SGLoopingScrollView.h
//  SGLoopingScrollView
//
//  Created by ZhengXiankai on 15/5/17.
//  Copyright (c) 2015年 ZhengXiankai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SGLoopingScrollViewDelegate <NSObject>

@required
- (UIImage *)imageFromItem:(id)item;

@optional
- (void)itemTab:(id)item;

@end

@interface SGLoopingScrollView : UIView <UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, assign) id<SGLoopingScrollViewDelegate> delegate;

@end
