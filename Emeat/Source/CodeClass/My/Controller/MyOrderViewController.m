//
//  MyOrderViewController.m
//  Emeat
//
//  Created by liuheshun on 2017/12/8.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import "MyOrderViewController.h"

#import "SGPagingView.h"
#import "AllOrderViewController.h"
#import "WaitPayViewController.h"
#import "WaitSendViewController.h"
#import "WaitReceiveViewController.h"
#import "WaitCommentViewController.h"
#import "AfterSaleViewController.h"
#import "ZJScrollPageView.h"
#import "InvoiceListViewController.h"


@interface MyOrderViewController ()<ZJScrollPageViewDelegate>
@property(strong, nonatomic)NSArray<NSString *> *titles;
@property(strong, nonatomic)NSArray<UIViewController<ZJScrollPageViewChildVcDelegate> *> *childVcs;

@end

@implementation MyOrderViewController
-(void)viewWillAppear:(BOOL)animated{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    self.navItem.title = @"我的订单";
   
    [self setMainView];
}

-(void)rightBtnClickAction{
    __weak __typeof(self) weakSelf = self;

    [self setRightItemBlockAction:^{
        InvoiceListViewController *VC = [InvoiceListViewController new];
        [weakSelf.navigationController pushViewController:VC animated:YES];
    }];
}



-(void)setMainView{
    //必要的设置, 如果没有设置可能导致内容显示不正常
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    //显示遮盖
    style.showCover = NO;
    style.scrollLineColor = RGB(231, 35, 36, 1);
    style.selectedTitleColor = RGB(231, 35, 36, 1);
    // 根据title总宽度自动调整位置 -- 达到个数少的时候会'平分'的效果, 个数多的时候就是可以滚动的效果 只有当scrollTitle == YES的时候才有效
    //    style.autoAdjustTitlesWidth = YES;
    // 不滚动标题
    style.scrollTitle = NO;
    style.scaleTitle = NO;
    style.showLine = YES;
    
    // 同步调整遮盖或者滚动条的宽度 -- 只有当scrollTitle == NO的时候有效
    //    style.adjustCoverOrLineWidth = YES;
    // 颜色渐变
    style.gradualChangeTitleColor = NO;
    //    style.showExtraButton = YES;
    self.titles = @[@"全部", @"待付款", @"待确认", @"待收货"  ,@"退货/售后"];
    // 初始化
    ZJScrollPageView *scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, kBarHeight, self.view.bounds.size.width, self.view.bounds.size.height - kBarHeight) segmentStyle:style titles:self.titles parentViewController:self delegate:self];
    
    
    [self.view addSubview:scrollPageView];
    [scrollPageView setSelectedIndex:self.selectIndex animated:YES];

    AllOrderViewController *oneVC = [[AllOrderViewController alloc] init];
    WaitPayViewController *twoVC = [[WaitPayViewController alloc] init];
    WaitSendViewController *threeVC= [[WaitSendViewController alloc] init];
    WaitReceiveViewController *fourVC = [[WaitReceiveViewController alloc] init];
    AfterSaleViewController *fiveVC = [[AfterSaleViewController alloc] init];
    self.childVcs = @[oneVC, twoVC, threeVC, fourVC ,fiveVC];

}


- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}

- (NSInteger)numberOfChildViewControllers {
    return self.titles.count;
}



- (void)setUpTitleView:(ZJTitleView *)titleView forIndex:(NSInteger)index {
    titleView.label.layer.cornerRadius = 15;
    titleView.label.layer.masksToBounds = YES;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {

    UIViewController<ZJScrollPageViewChildVcDelegate> *childVc = reuseViewController;
    
    if (!childVc) {
        childVc = self.childVcs[index];
    }
    
    return childVc;
}

- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllDidAppear:(UIViewController *)childViewController forIndex:(NSInteger)index{
    
    if (index != 0) {
        self.navItem.rightBarButtonItem= nil;
    }else{
        self.rightButtonTitle = @"开发票";
        [self showNavBarItemRight];
        [self rightBtnClickAction];
    }
}












- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
