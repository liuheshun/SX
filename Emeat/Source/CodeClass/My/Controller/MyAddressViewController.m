//
//  MyAddressViewController.m
//  Emeat
//
//  Created by liuheshun on 2017/12/14.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import "MyAddressViewController.h"
#import "MyAddressTableViewCell.h"
#import "AddNewAddressViewController.h"


@interface MyAddressViewController ()<UITableViewDelegate ,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *addressDataMarray;



@end

@implementation MyAddressViewController
-(void)viewWillAppear:(BOOL)animated{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    [self getMyAddressData];

}

-(void)viewWillDisappear:(BOOL)animated{
    [[GlobalHelper shareInstance] removeEmptyView];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navItem.title = @"收货地址管理";
    self.rightButtonTitle = @"新增地址";
    [self showNavBarItemRight];
    [self addBlockAction];
    self.view.backgroundColor = RGB(238, 238, 238, 1);
    [self.view addSubview:self.tableView];

}

#pragma mark = 收货地址列表

-(void)getMyAddressData{
    
    NSMutableDictionary *dic = [self checkoutData];    
    self.addressDataMarray = [NSMutableArray array];
    [self.addressDataMarray removeAllObjects];
    
    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/auth/shipping/list" ,baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        if ([[returnData[@"status"] stringValue] isEqualToString:@"200"]) {
            for (NSDictionary *dic in returnData[@"data"]) {
                MyAddressModel *addressModel = [MyAddressModel yy_modelWithJSON:dic];
               DLog(@"我的地址== %@" ,addressModel.receiverName);
                [self.addressDataMarray addObject:addressModel];
            }
        }else{
            
        }
        if (self.addressDataMarray.count == 0) {
            [[GlobalHelper shareInstance] emptyViewNoticeText:@"还没有收货地址,新建一个吧" NoticeImageString:@"wudizhi" viewWidth:50 viewHeight:68 UITableView:self.tableView];
            
        }
        else
        {
            [[GlobalHelper shareInstance] removeEmptyView];
        }
        
        [self.tableView reloadData];

        DLog(@"收货地址列表===== %@ %@ " ,returnData, returnData[@"status"]);
        
    } failureBlock:^(NSError *error) {
        
        DLog(@"收货地址错误列表=== %@" , error);
        
    } showHUD:NO];
    
    
  
    
    
    
}




-(void)addBlockAction{
    __weak __typeof(self) weakSelf = self;
    
    self.rightItemBlockAction = ^{
        DLog(@"新增收货地址跳转");
        
        AddNewAddressViewController *VC = [AddNewAddressViewController new];
        VC.isCanRemove = YES;
        VC.navTitle = @"新增收货地址";

        [weakSelf.navigationController pushViewController:VC animated:YES];
    };
    
}



-(UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kBarHeight, kWidth, kHeight-kBarHeight-LL_TabbarSafeBottomMargin) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.backgroundColor = RGB(238, 238, 238, 1);
    }
    return _tableView;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.addressDataMarray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
    return 15;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 15)];
    view.backgroundColor = RGB(238, 238, 238, 1);
    return view;
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
    
    MyAddressTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"myAddress_cell1"];
    if (cell1 == nil) {
        cell1 = [[MyAddressTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myAddress_cell1"];
        
        [cell1 setSelectionStyle:UITableViewCellSelectionStyleNone]; //取消选中的阴影效果
        cell1.backgroundColor = [UIColor whiteColor];
      
    }
    
   
    if (self.addressDataMarray.count!= 0) {
        MyAddressModel *model = self.addressDataMarray[indexPath.section];
        
        [cell1 setConfigAddressInfo:model isEdit:YES fromConfirmVC:self.fromConfirmVC];
    }
  
    [cell1.editBtn addTarget:self action:@selector(editBtnAction:) forControlEvents:1];
    cell1.editBtn.tag = indexPath.section;
    
    return cell1;
}







-(void)editBtnAction:(UIButton*)btn{
    DLog(@"编辑位置=== %ld" ,btn.tag);
    
    AddNewAddressViewController *VC = [AddNewAddressViewController new];
    VC.isCanRemove = NO;
    VC.navTitle = @"编辑收货地址";
    VC.postMyAddressModel = self.addressDataMarray[btn.tag];
    [self.navigationController pushViewController:VC animated:YES];
}





#pragma mark  = 点击事件


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.fromConfirmVC isEqualToString:@"1"]) {
        
        if (self.addressDataMarray.count!= 0) {
            
            MyAddressModel *model = self.addressDataMarray[indexPath.section];
            
            if ([model.receiverProvince containsString:@"上海市"] && ![model.receiverProvince containsString:@"崇明区"]) {
                DLog(@"在范围内");
                if ([self respondsToSelector:@selector(myShippingAddressBlock)]) {
                    self.myShippingAddressBlock(model);
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }
            }else{
                DLog(@"-------------不在");
                SVProgressHUD.minimumDismissTimeInterval = 1;
                SVProgressHUD.maximumDismissTimeInterval = 2;
                [SVProgressHUD showErrorWithStatus:@"不在配送范围内"];
            }
            
            
            
            
            
           
        }
    }
    
    
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
