//
//  ViewController.m
//  SGLoopingScrollView
//
//  Created by ZhengXiankai on 15/5/17.
//  Copyright (c) 2015年 ZhengXiankai. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSMutableArray *imgArr = [NSMutableArray array];
    for (int i = 1; i <= 1; i++) {
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
