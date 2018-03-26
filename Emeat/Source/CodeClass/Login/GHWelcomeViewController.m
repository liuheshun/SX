//
//  GHWelcomeViewController.m
//  GH
//
//  Created by gonghoo on 16/4/5.
//  Copyright © 2016年 gonghoo. All rights reserved.
//

#import "GHWelcomeViewController.h"
#import "UIImageView+WebCache.h"
@interface GHWelcomeViewController ()<UIScrollViewDelegate>
@property (nonatomic ,strong) NSMutableArray *mArray;

@end

@implementation GHWelcomeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    self.scrollview = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.scrollview.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width*4, [UIScreen mainScreen].bounds.size.height);
    self.scrollview.bounces = NO;
    self.scrollview.pagingEnabled = YES;
    self.scrollview.delegate = self;
    [self.view addSubview:self.scrollview];
 
    for (int i = 0; i < 4; i ++) {
            self.imageview = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * i, 0, [UIScreen mainScreen].bounds.size.width , [UIScreen mainScreen].bounds.size.height)];
            
        
             self.imageview.image = [UIImage imageNamed:[NSString stringWithFormat:@"welcome%d",i+1]];
            
            [self.scrollview addSubview:self.imageview];
            self.page = [[UIPageControl alloc] initWithFrame:CGRectMake(50, [UIScreen mainScreen].bounds.size.height-40, [UIScreen mainScreen].bounds.size.width -100, 30)];
            self.page.numberOfPages = 4;//////////

            self.page.currentPageIndicatorTintColor = [UIColor whiteColor];
            self.page.pageIndicatorTintColor = RGB(255, 102, 51, 1);
            [self.view addSubview:self.page];
            [self.page addTarget:self action:@selector(pageAction:) forControlEvents:UIControlEventValueChanged];
            
        
        }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(kWidth*3 +(kWidth-187)/2, kHeight - 85,187, 36);
    
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[[UIImage imageNamed:@"ydybtn"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]forState:UIControlStateNormal];
    [self.scrollview addSubview:button];
    
    
}

-(void)pageAction:(UIPageControl *)sender{
    self.scrollview.contentOffset = CGPointMake([UIScreen mainScreen].bounds.size.width * sender.currentPage, 0);
    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    self.page.currentPage = self.scrollview.contentOffset.x /[UIScreen mainScreen].bounds.size.width;
    
}

-(void)buttonAction{
    self.didSelectedEnter();
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}




@end
