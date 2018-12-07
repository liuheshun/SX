//
//  HomePageDetailsCommentsViewController.m
//  Emeat
//
//  Created by liuheshun on 2018/10/11.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "HomePageDetailsCommentsViewController.h"
#import "HomePageCommentDetailsTableViewCell.h"
#import "GQImageVideoViewer.h"

@interface HomePageDetailsCommentsViewController ()<UITableViewDataSource ,UITableViewDelegate>
@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,assign) CGFloat cellHeight;

@property (nonatomic, strong) NSMutableDictionary *heightAtIndexPath;//缓存cell高度

@end

@implementation HomePageDetailsCommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(238, 238, 238, 1);
    [self.view addSubview:self.tableView];
    self.dataArray = [NSMutableArray array];
    [self requestCommentsListData];
    
}

#pragma mark ====请求评价详情

-(void)requestCommentsListData{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:self.detailsId forKey:@"commodityId"];
    
    [dic setValue:mTypeIOS forKey:@"mtype"];
    [dic setValue:[user valueForKey:@"appVersionNumber"] forKey:@"appVersionNumber"];
    [dic setValue:[user valueForKey:@"user"] forKey:@"user"];
    
    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/m/evaluation/get_evaluation_by_commodity_id",baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
       
        DLog(@"评价列表 ==== %@" ,returnData);
        if ([returnData[@"status"] integerValue] == 200) {
            
            for (NSMutableDictionary *dic in returnData[@"data"]) {
                
                HomePageCommentsModel *model = [HomePageCommentsModel yy_modelWithJSON:dic];
                model.headPic = dic[@"customer"][@"headPic"];
                model.nickname = dic[@"customer"][@"nickname"];
                model.evaluationDate = [self returnTimeStringWithTimeStamp:model.evaluationDate];
                model.unfold = NO;
                [self.dataArray addObject:model];
            }
        
            
        } else {
          
        }
        
        [self.tableView reloadData];
        
    } failureBlock:^(NSError *error) {
        
        
    } showHUD:NO];
    
}



-(UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kBarHeight, kWidth, kHeight-kBarHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
       [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.showsVerticalScrollIndicator = NO;

    }
    return _tableView;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.dataArray.count == 0) {
        return 1;
    }
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataArray.count == 0) {
        return 0;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.dataArray.count == 0) {
        return 500*kScale;
    }
    return 0.001;

}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 15*kScale)];
    view.backgroundColor = [UIColor whiteColor];
    
    if (self.dataArray.count == 0) {
        
        [[GlobalHelper shareInstance] emptyViewNoticeText:@"暂无相关评价" NoticeImageString:@"无评论" viewWidth:50 viewHeight:54 UITableView:view isShowBottomBtn:NO bottomBtnTitle:@""];
    }
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.5*kScale;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 0.5*kScale)];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15*kScale, 0, kWidth-30*kScale, 0.5*kScale)];
    if (self.dataArray.count == 0) {
        lineView.backgroundColor = [UIColor whiteColor];
    }else{
        if (self.dataArray.count -1 == section) {
            lineView.backgroundColor = [UIColor whiteColor];

        }else{
        lineView.backgroundColor = RGB(136, 136, 136, 1);
        }
    }
    [view addSubview:lineView];
    
    return view;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *height = [self.heightAtIndexPath objectForKey:indexPath];
    if(height){
        return height.floatValue;
    }else{
        return 100;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSNumber *height = @(cell.frame.size.height);
    [self.heightAtIndexPath setObject:height forKey:indexPath];
}

#pragma mark - Getters
- (NSMutableDictionary *)heightAtIndexPath
{
    if (!_heightAtIndexPath) {
        _heightAtIndexPath = [NSMutableDictionary dictionary];
    }
    return _heightAtIndexPath;
}






-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *Identifier = [NSString stringWithFormat:@"comment_cell%ld" ,indexPath.section];
    HomePageCommentDetailsTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell1 == nil) {
        cell1 = [[HomePageCommentDetailsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
        
        [cell1 setSelectionStyle:UITableViewCellSelectionStyleNone]; //取消选中的阴影效果
        cell1.backgroundColor = [UIColor whiteColor];
        
        
    }
    
    if (self.dataArray.count != 0) {
        HomePageCommentsModel *model = self.dataArray[indexPath.section];
        [cell1.isFoldingBtn addTarget:self action:@selector(isFoldingBtnAction:) forControlEvents:1];
        cell1.isFoldingBtn.tag = indexPath.section;
        [cell1 configWithModel:model];
        
        cell1.returnClickImaeTag = ^(NSInteger imageViewTag, NSArray *commentsImageArray) {
            
            DLog(@"%ld  == %@" ,imageViewTag , commentsImageArray);
            //基本调用
           [[GQImageVideoViewer sharedInstance] setDataArray:commentsImageArray];//这是图片和视频数组
            [GQImageVideoViewer sharedInstance].usePageControl = YES;//设置是否使用pageControl
            [GQImageVideoViewer sharedInstance].selectIndex = imageViewTag;//设置选中的图片索引
            [GQImageVideoViewer sharedInstance].achieveSelectIndex = ^(NSInteger selectIndex){
                NSLog(@"%ld",selectIndex);
            };//获取当前选中的图片索引
            [GQImageVideoViewer sharedInstance].backgroundColor = [UIColor blackColor];
            [GQImageVideoViewer sharedInstance].laucnDirection = GQLaunchDirectionRight;//设置推出方向
            [[GQImageVideoViewer sharedInstance] showInView:self.navigationController.view];//显示GQImageViewer到指定view上
        };
        
    }
   
    return cell1;
}


-(void)isFoldingBtnAction:(UIButton*)btn{
    
    
    HomePageCommentsModel *model = self.dataArray[btn.tag];
    model.unfold = !model.unfold;
    
    //一个cell刷新
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:btn.tag];
    
    //[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadData];
   // [self.tableView reloadRowsAtIndexPaths:[NSIndexPath indexPathForRow:1 inSection:btn.tag] withRowAnimation:UITableViewRowAnimationFade];
    
}

#pragma mark  = 点击事件


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
  
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
