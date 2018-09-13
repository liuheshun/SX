//
//  HomePageSortListViewController.m
//  Emeat
//
//  Created by liuheshun on 2017/11/24.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import "HomePageSortListViewController.h"
#import "HomePageTableViewCell.h"
#import "SortListSegmentView.h"
#import "PYSearch.h"

#import "HomePageAllSortListViewController.h"


///
#import "SGPagingView.h"
#import "HomePageAllSortListViewController.h"

@interface HomePageSortListViewController ()<UITableViewDelegate,UITableViewDataSource  ,SGPageTitleViewDelegate, SGPageContentScrollViewDelegate >

@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentScrollView *pageContentScrollView;

@property (nonatomic,strong) HomePageNavView *homePageNavView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIButton *leftButtons;
@property (nonatomic,strong) SortListSegmentView *segmentView;
///列表数据源
@property (nonatomic,strong) NSMutableArray *dataArray;
///筛选数据源
@property (nonatomic,strong) NSMutableArray *checkMarray;

@property (nonatomic,strong) NSString *statusStringURL;

@property (nonatomic,strong) UITapGestureRecognizer * tap;
@property (nonatomic,strong) NSString *minPrices;
@property (nonatomic,strong) NSString *maxPrices;
@property (nonatomic,strong) NSString *counStr;
@property (nonatomic,strong) NSString *kindStr;
@property (nonatomic,strong) NSString *weightStr;



///热搜标签数据
@property (nonatomic,strong) NSMutableArray *hotSearchMarray;
///历史搜索数据
@property (nonatomic,strong) NSMutableArray *historySearchMarray;

@property (nonatomic,strong) UIButton *leftBtn;



@end

@implementation HomePageSortListViewController
{
    NSInteger totalPage;//分页
    NSInteger totalPageCount;//分页总数
}

-(void)viewWillAppear:(BOOL)animated{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;

}
- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(238, 238, 238, 1);
    self.navItem.title = @"分类";

      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSelectedIndex:) name:@"changeSelectedIndex" object:nil];
    [self setupPageView];
    

    
    
}

- (void)changeSelectedIndex:(NSNotification *)noti {
    _pageTitleView.resetSelectedIndex = [noti.object integerValue];
}





- (void)setupPageView {
    CGFloat pageTitleViewY = kBarHeight;
    
    NSMutableArray *titleArr = [NSMutableArray array];
    for (HomePageModel *model in self.segmentTitleMarray) {
        [titleArr addObject:model.classifyName];
    }
    
    
    SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
    //configure.indicatorAdditionalWidth = 10; // 说明：指示器额外增加的宽度，不设置，指示器宽度为标题文字宽度；若设置无限大，则指示器宽度为按钮宽度
    configure.titleColor = RGB(51, 51, 51, 1);
    configure.titleSelectedColor = RGB(236, 31, 35, 1);
    /// pageTitleView
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, pageTitleViewY, self.view.frame.size.width, 44) delegate:self titleNames:titleArr configure:configure];
    //self.pageTitleView.selectedIndex = 0;
    [self.view addSubview:_pageTitleView];
//    [_pageTitleView addBadgeForIndex:1];
//    [_pageTitleView addBadgeForIndex:5];
    NSMutableArray *childArr = [NSMutableArray array];

    for (int i =0; i < self.segmentTitleMarray.count; i++) {
          HomePageAllSortListViewController *oneVC = [[HomePageAllSortListViewController alloc] init];
//        oneVC.titleIndexs = i;
        if (i==0) {
            oneVC.isFirsrEnter = 1;
        }
        oneVC.segmentTitleMarray = self.segmentTitleMarray;
        oneVC.sortId = self.sortId;
        oneVC.sortType = self.sortType;
        
//        oneVC.titleModelMarray = self.segmentTitleMarray;
        [childArr addObject:oneVC];
    }
   
    /// pageContentScrollView
    CGFloat ContentCollectionViewHeight = self.view.frame.size.height - CGRectGetMaxY(_pageTitleView.frame);
    
    self.pageContentScrollView = [[SGPageContentScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_pageTitleView.frame), self.view.frame.size.width, ContentCollectionViewHeight) parentVC:self childVCs:childArr];
    
    
    
    
    _pageContentScrollView.delegatePageContentScrollView = self;
    [self.view addSubview:_pageContentScrollView];
}

- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex {
    [GlobalHelper shareInstance].isEnterDetails = @"0";

    [self.pageContentScrollView setPageContentScrollViewCurrentIndex:selectedIndex];
   // [[NSNotificationCenter defaultCenter] postNotificationName:@"selectIndexRefreshData" object:[NSString stringWithFormat:@"%ld", (long)selectedIndex]];
    
}

- (void)pageContentScrollView:(SGPageContentScrollView *)pageContentScrollView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    //DLog(@"originalIndex ==== %ld  targetIndex=====  %ld" , (long)originalIndex , targetIndex);
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}

- (void)pageContentScrollView:(SGPageContentScrollView *)pageContentScrollView index:(NSInteger)index {
   // DLog(@"Index ==== %ld " , index );
    [GlobalHelper shareInstance].isEnterDetails = @"0";
    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectIndexRefreshData" object:[NSString stringWithFormat:@"%ld", (long)index]];

}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
