//
//  HomePageDetailsGoodsViewController.m
//  Emeat
//
//  Created by liuheshun on 2018/10/11.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "HomePageDetailsGoodsViewController.h"
#import "YNPageViewController.h"
#import "UIViewController+YNPageExtend.h"
#import "HomePageShoppingDetailsTableViewCell.h"
#import "HomePageDeatilsHeadSpecificationsView.h"

@interface HomePageDetailsGoodsViewController ()<UITableViewDataSource ,UITableViewDelegate>
@property (nonatomic,strong) NSMutableArray *detailsDataArray;
@property (nonatomic,strong) HomePageDeatilsHeadSpecificationsView *specificationsView;
@property (nonatomic,strong) NSMutableArray *headDataArray;

@end

@implementation HomePageDetailsGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.detailsDataArray = [NSMutableArray array];
    self.headDataArray = [NSMutableArray array];
    [self requsetDetailsData];
    [self.view addSubview:self.tableView];
    
}
#pragma mark = 商品详情数据

-(void)requsetDetailsData{
    [SVProgressHUD show];
    self.detailsDataArray = [NSMutableArray array];
    self.headDataArray = [NSMutableArray array];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    
    NSString *str;
    if ([self.fromBaner isEqualToString:@"1"]) {////来自banner
        str = [NSString stringWithFormat:@"%@/m/mobile/commodity/commodityDeatilByCode?commodityCode=%@&mtype=%@&appVersionNumber=%@&user=%@" ,baseUrl ,self.detailsId,mTypeIOS ,[user valueForKey:@"appVersionNumber"] ,[user valueForKey:@"user"]];
    }
    else ///来自商品列表
    {
        str = [NSString stringWithFormat:@"%@/m/mobile/commodity/commodityDeatil?id=%@&mtype=%@&appVersionNumber=%@&user=%@" , baseUrl ,self.detailsId,mTypeIOS ,[user valueForKey:@"appVersionNumber"] ,[user valueForKey:@"user"]];
    }
    
    //DLog(@"详情接口==== %@" ,str);
    
    [MHNetworkManager getRequstWithURL:str params:nil successBlock:^(NSDictionary *returnData) {
        DLog(@"详情返回结果=== %@" ,returnData);
        if ([[returnData[@"status"] stringValue] isEqualToString:@"200"]) {
            
            
            
            HomePageModel *bannerModel = [HomePageModel yy_modelWithJSON:returnData[@"data"]];
            [GlobalHelper shareInstance].homePageDetailsId = [NSString stringWithFormat:@"%ld" ,bannerModel.id];
            
           
            
           
           
            if (bannerModel) {
                [self.headDataArray addObject:bannerModel];
               
                
                NSMutableArray *imvMarray = [NSMutableArray arrayWithArray:[bannerModel.commodityDetail componentsSeparatedByString:@","]];
                
                for (NSString *imvString in imvMarray) {
                    HomePageModel *detailsModel = [HomePageModel new];
                    detailsModel.commodityDetail = imvString;
                    [self.detailsDataArray addObject:detailsModel];
                }
            
                
            }
            
        }else{
            
            [[GlobalHelper shareInstance] emptyViewNoticeText:@"您浏览的商品已下架, 换一个吧" NoticeImageString:@"下架商品" viewWidth:56*kScale viewHeight:65*kScale UITableView:(UITableView*)self.view isShowBottomBtn:NO bottomBtnTitle:@""];
        }
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
        
    } failureBlock:^(NSError *error) {
        
        [SVProgressHUD dismiss];
        
    } showHUD:NO];
    [SVProgressHUD show];
    
    
}


//
//-(UITableView*)tableView{
//    if (!_tableView) {
//        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kBarHeight, kWidth, kHeight-kBarHeight) style:UITableViewStyleGrouped];
//        _tableView.delegate = self;
//        _tableView.dataSource = self;
//        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//        _tableView.backgroundColor = [UIColor whiteColor];
//    }
//    return _tableView;
//}
//
//
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//
//    return 3;
//}
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return 1;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 180*kScale;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//
//    return [self placeHolderCellHeight];
//}
//
#pragma mark - 求出占位cell高度
- (CGFloat)placeHolderCellHeight {
    CGFloat height = self.config.contentHeight - 135*kScale * self.detailsDataArray.count;
    height = height < 0 ? 0 : height;
    return height;
}
//
//-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 15*kScale)];
//    view.backgroundColor = [UIColor redColor];
//    return view;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 15*kScale;
//}
//
//-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 15*kScale)];
//    view.backgroundColor = [UIColor cyanColor];
//
//    return view;
//}
//
//
//
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"list_cell"];
//    if (cell1 == nil) {
//        cell1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"list_cell"];
//
//        //[cell1 setSelectionStyle:UITableViewCellSelectionStyleNone]; //取消选中的阴影效果
//        cell1.backgroundColor = [UIColor orangeColor];
//
//    }
//
//    return cell1;
//}

-(UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kBarHeight, kWidth, kHeight-kBarHeight-49-LL_TabbarSafeBottomMargin) style:UITableViewStyleGrouped];
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
   
    return self.detailsDataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    // 先从缓存中查找图片
    HomePageModel *model = self.detailsDataArray[indexPath.row];
    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey: model.commodityDetail];
    // 没有找到已下载的图片就使用默认的占位图，当然高度也是默认的高度了，除了高度不固定的文字部分。
    if (!image) {
        
        image = [UIImage imageNamed:@"small_placeholder"];
    }
    //手动计算cell
    CGFloat imgHeight = image.size.height * [UIScreen mainScreen].bounds.size.width / image.size.width;
    model.cellHeight = imgHeight;
    
    return imgHeight;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
  
    if (self.detailsDataArray.count == 0) {
        return [self placeHolderCellHeight];
    }
    
    return 100*kScale;

}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 15)];
    view.backgroundColor = [UIColor whiteColor];
    return self.specificationsView;
}

-(HomePageDeatilsHeadSpecificationsView *)specificationsView{
    if (_specificationsView == nil) {
        _specificationsView = [[HomePageDeatilsHeadSpecificationsView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 100*kScale)];
        _specificationsView.backgroundColor = [UIColor whiteColor];
    }
    ///头部赋值
    if (self.headDataArray.count!=0) {
        HomePageModel *model = [self.headDataArray firstObject];
        [_specificationsView configSpecialHeadViewWithModel:model];
    }
    
    return _specificationsView;
}



-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 0.01)];
    view.backgroundColor = RGB(238, 238, 238, 1);
    
    return view;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
        HomePageShoppingDetailsTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"shoppingDetails_cell"];
        if (cell1 == nil) {
            cell1 = [[HomePageShoppingDetailsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"shoppingDetails_cell"];
            
            [cell1 setSelectionStyle:UITableViewCellSelectionStyleNone]; //取消选中的阴影效果
            cell1.backgroundColor = [UIColor whiteColor];
            
        }
        if (self.detailsDataArray.count!=0) {
            //  DLog(@"yyyyy== %@" ,self.detailsDataArray);
            HomePageModel *model = self.detailsDataArray[indexPath.row];
            [cell1 configCell:model forIndexPath:indexPath tableView:self.tableView];
        }
        
        return cell1;
    
}

#pragma mark  = 点击事件


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //隐藏tabBar
    
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
