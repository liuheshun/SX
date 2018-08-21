//
//  PersonalPageViewController.m
//  Emeat
//
//  Created by liuheshun on 2018/8/14.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "PersonalPageViewController.h"
#import "HomePageNavView.h"
<<<<<<< HEAD


#define headViewHeight 567*kScale

@interface PersonalPageViewController ()<UITableViewDelegate ,UITableViewDataSource ,SDCycleScrollViewDelegate>
@property (nonatomic,strong) HomePageNavView *navView;
@property (nonatomic,strong) UITableView *tableView;
=======
#import "GYChangeTextView.h"

#define headViewHeight 567*kScale

@interface PersonalPageViewController ()<UITableViewDelegate ,UITableViewDataSource ,SDCycleScrollViewDelegate ,GYChangeTextViewDelegate>
@property (nonatomic,strong) HomePageNavView *navView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) SDCycleScrollView*cycleScrollView;
///播报数据
@property (nonatomic,strong) NSMutableArray *PlayTextDataMarray;
>>>>>>> 920e5bc1a595fa5c5010dd4ef6a1a6259a85d234


@end

@implementation PersonalPageViewController

-(void)viewWillAppear:(BOOL)animated{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

-(void)viewWillDisappear:(BOOL)animated{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(238, 238, 238, 1);
    [self.view addSubview:self.navView];
    [self.view addSubview:self.tableView];
<<<<<<< HEAD
=======
    self.PlayTextDataMarray = [NSMutableArray array];
    [self requestPlayTextData];
>>>>>>> 920e5bc1a595fa5c5010dd4ef6a1a6259a85d234
}


-(UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kBarHeight, kWidth, kHeight-kBarHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 135*kScale;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
    return 567*kScale;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 15*kScale)];
    headView.backgroundColor = RGB(238, 238, 238, 1);
    [self addSDCycleScrollViewWithImageURLArray:@"" ParentView:headView];
<<<<<<< HEAD
    
    
    
    
    
    
    return headView;
}


-(void)addSDCycleScrollViewWithImageURLArray:(NSMutableArray*)imageURLArray  ParentView:(UIView*)parentView{
    
    SDCycleScrollView*cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kWidth, 176*kScale) delegate:self placeholderImage:[UIImage imageNamed:@"banner加载"]];   //placeholder
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView.showPageControl = YES;//是否显示分页控件
    cycleScrollView.currentPageDotColor = [UIColor orangeColor]; // 自定义分页控件小圆标颜色
    cycleScrollView.tag = 1;
   // cycleScrollView.imageURLStringsGroup =
    
    [parentView addSubview:cycleScrollView];
=======
    UIView *playTextView = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(self.cycleScrollView)+15*kScale, kWidth, 60*kScale)];
    playTextView.backgroundColor = [UIColor whiteColor];
    [headView addSubview:playTextView];
    [self addChangeTextViewToBgView:playTextView];
    
    
    
    return headView;
}


#pragma mark ===============添加播报视图view

-(void)addChangeTextViewToBgView:(UIView*)bgView{
    UIImageView *playImage = [[UIImageView alloc] initWithFrame:CGRectMake(15*kScale, 8*kScale, 35*kScale, 34*kScale)];
    playImage.image = [UIImage imageNamed:@"saixianbobao"];
    [bgView addSubview:playImage];
    GYChangeTextView *tView = [[GYChangeTextView alloc] initWithFrame:CGRectMake(MaxX(playImage)+25*kScale, 0, kWidth-140*kScale, 60*kScale)];
    tView.delegate = self;
    tView.backgroundColor =  [UIColor whiteColor];
    [bgView addSubview:tView];
    //self.tView = tView;
    NSArray * listArray = self.PlayTextDataMarray;
    [tView animationWithTexts:listArray];
    
    
}

#pragma mark ================== 获取播报数据

-(void)requestPlayTextData{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/m/roll/get_roll_order?appVersionNumber=%@&user=%@" ,baseUrl, [user valueForKey:@"appVersionNumber"] ,[user valueForKey:@"user"]] params:nil successBlock:^(NSDictionary *returnData) {
        
        DLog(@"获取播报数据=====%@" ,returnData);
        if ([returnData[@"status"] integerValue] == 200) {
            [self.PlayTextDataMarray removeAllObjects];
            for (NSDictionary *dic in returnData[@"data"]) {
                HomePageModel *model = [HomePageModel yy_modelWithJSON:dic];
                [self.PlayTextDataMarray addObject:model];
                
            }
           
            
            [self.tableView reloadData];
        }
        
    } failureBlock:^(NSError *error) {
        
    } showHUD:NO];
    
}



-(void)addSDCycleScrollViewWithImageURLArray:(NSMutableArray*)imageURLArray  ParentView:(UIView*)parentView{
    
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kWidth, 176*kScale) delegate:self placeholderImage:[UIImage imageNamed:@"banner加载"]];   //placeholder
    self.cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    self.cycleScrollView.showPageControl = YES;//是否显示分页控件
    self.cycleScrollView.currentPageDotColor = [UIColor orangeColor]; // 自定义分页控件小圆标颜色
    self.cycleScrollView.tag = 1;
   // cycleScrollView.imageURLStringsGroup =
    
    [parentView addSubview:self.cycleScrollView];
>>>>>>> 920e5bc1a595fa5c5010dd4ef6a1a6259a85d234
    
}








-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15*kScale;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 15*kScale)];
    view.backgroundColor = [UIColor cyanColor];
    
    return view;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"list_cell"];
    if (cell1 == nil) {
        cell1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"list_cell"];
        
        //[cell1 setSelectionStyle:UITableViewCellSelectionStyleNone]; //取消选中的阴影效果
        cell1.backgroundColor = [UIColor orangeColor];
        
    }
    
    return cell1;
}

#pragma mark  = 点击事件


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //隐藏tabBar
    
}



#pragma mark =============导航栏视图

-(HomePageNavView*)navView{
    if (!_navView) {
        _navView = [[HomePageNavView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kBarHeight)];
        _navView.backgroundColor = RGB(236, 31, 35, 1);
    }
    return _navView;
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
