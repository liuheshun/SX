//
//  MyViewController.m
//  Emeat
//
//  Created by liuheshun on 2017/11/6.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import "MyViewController.h"
#import "MyHeadView.h"
#import "MyOrderViewController.h"
#import "MyAddressViewController.h"
#import "ContactServiceViewController.h"
#import "AfterServiceViewController.h"
#import "SettingViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import "BDImagePicker.h"
#import "MHUploadParam.h"
#import "ShopCertificationViewController.h"

@interface MyViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) MyHeadView *headView;

@property (nonatomic,strong) NSString * isLogin;

@property (nonatomic,strong) UIImage *customImage;

///我的数据源
@property (nonatomic,strong) NSMutableArray *myDataMarray;

///存放店铺认证相关信息
@property (nonatomic,strong) NSMutableArray *shopCertifiMarray;

@end

@implementation MyViewController
-(void)viewWillAppear:(BOOL)animated{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if ([user valueForKey:@"isLoginState"])
    {
        [GlobalHelper shareInstance].isLoginState = [user valueForKey:@"isLoginState"];
    }
    
    ReachabilityStatus status = [GLobalRealReachability currentReachabilityStatus];
    if (status == RealStatusNotReachable)
    {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        
    }else{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
//        [self.view addSubview:self.tableView];
        if (self.tableView) {
             [self.view addSubview:self.tableView];
        }
        [self requsetMyData];

    }

}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(238, 238, 238, 1);
    self.navigationController.navigationBarHidden = YES;
    self.myDataMarray = [NSMutableArray array];
    self.shopCertifiMarray = [NSMutableArray array];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    [self netWorkIsOnLine];
}



-(void)netWorkIsOnLine{
    
    ReachabilityStatus status = [GLobalRealReachability currentReachabilityStatus];
    
    if (status == RealStatusNotReachable)
    {
        [[GlobalHelper shareInstance] showErrorIView:self.view errorImageString:@"wuwangluo" errorBtnString:@"重新加载" errorCGRect:CGRectMake(0, 0, kWidth, kHeight)];
        [[GlobalHelper shareInstance].errorLoadingBtn addTarget:self action:@selector(errorLoadingBtnAction) forControlEvents:1];
        
    }else{
        
        [self.view addSubview:self.tableView];
        [self requsetMyData];

        
        [[GlobalHelper shareInstance] removeErrorView];
    }
}


#pragma mark = 重新加载

-(void)errorLoadingBtnAction{
    ReachabilityStatus status = [GLobalRealReachability currentReachabilityStatus];
    
    if (status == RealStatusNotReachable){
        
    }else{
        [self.view addSubview:self.tableView];
        [self requsetMyData];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

        [[GlobalHelper shareInstance] removeErrorView];
    }
}






#pragma mark = 我的数据

-(void)requsetMyData{
    
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *ticket = [user valueForKey:@"ticket"];
        NSString *secret = @"UHnyKzP5sNmh2EV0Dflgl4VfzbaWc4crQ7JElfw1cuNCbcJUau";
        NSString *nonce = [self ret32bitString];//随机数
        NSString *curTime = [self dateTransformToTimeSp];
        NSString *checkSum = [self sha1:[NSString stringWithFormat:@"%@%@%@" ,secret ,  nonce ,curTime]];
        [dic setValue:secret forKey:@"secret"];
        [dic setValue:nonce forKey:@"nonce"];
        [dic setValue:curTime forKey:@"curTime"];
        [dic setValue:checkSum forKey:@"checkSum"];
        [dic setValue:ticket forKey:@"ticket"];
        [dic setValue:[user valueForKey:@"userId"] forKey:@"id"];
        [dic setValue:mTypeIOS forKey:@"mtype"];

        DLog(@"2我的接口=== %@" ,dic);
        [MHAsiNetworkHandler startMonitoring];
        
        [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/m/auth/user/my", baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
            
            DLog(@"2我的接口=== %@" ,returnData);
            if ([returnData[@"code"] isEqualToString:@"0404"] || [returnData[@"code"] isEqualToString:@"04"]) {
                [GlobalHelper shareInstance].isLoginState = @"0";
                [user setValue:@"0" forKey:@"isLoginState"];
                [self.tableView reloadData];
            }
            if ([[returnData[@"status"] stringValue] isEqualToString:@"200"]) {
                [self.myDataMarray removeAllObjects];
                
                NSInteger waitBuy =[ returnData[@"data"][@"waitBuy"] integerValue];
                NSInteger waitTransport =[ returnData[@"data"][@"waitTransport"] integerValue];
                NSInteger  salesReturn = [returnData[@"data"][@"salesReturn"] integerValue];
                NSInteger waitRecive = [returnData[@"data"][@"waitRecive"] integerValue];
                NSInteger waitEvaluation = [returnData[@"data"][@"waitEvaluation"]integerValue ];
                NSString *storeName = returnData[@"data"][@"store"][@"storeName"];
                NSInteger isApprove = [returnData[@"data"][@"store"][@"isApprove"] integerValue];
                NSInteger storeId = [returnData[@"data"][@"store"][@"id"] integerValue];
                NSDictionary *dic = returnData[@"data"][@"user"];
                MyModel *model = [MyModel yy_modelWithJSON:dic];
                model.waitBuy = waitBuy;
                model.waitTransport = waitTransport;
                model.salesReturn = salesReturn;
                model.waitRecive = waitRecive;
                model.waitEvaluation = waitEvaluation;
                model.storeName = storeName;
                model.isApprove = isApprove;
                model.storeId = storeId;
                [self.myDataMarray addObject:model];
                
                
                NSDictionary *dic1 = returnData[@"data"][@"store"];
                if (dic1) {
                    MyModel *model1 = [MyModel yy_modelWithJSON:dic1];
                    NSInteger storeId1 = [returnData[@"data"][@"store"][@"id"] integerValue];
                    model1.storeId = storeId1;
                    [self.shopCertifiMarray removeAllObjects];
                    [self.shopCertifiMarray addObject:model1];
                }else{
                    //清空认证信息 ,不能重新认证店铺,需新增
                    [self.shopCertifiMarray removeAllObjects];

                }
                
            }else{
               // [self alertMessage:returnData[@"msg"] willDo:nil];
            }
            
            [self.tableView reloadData];
            
        } failureBlock:^(NSError *error) {
            DLog(@"2我的接口error=== %@" ,error);
        } showHUD:NO];
        
   

    
    
  
    
}


#pragma mark = 登陆

-(void)loginBtnAction{
    LoginViewController *VC = [LoginViewController new];
    VC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
    
}

#pragma mark = 修改用户头像

-(void)userImvBtn{
    DLog(@"修改用户头像");
   
    [BDImagePicker showImagePickerFromViewController:self allowsEditing:NO finishAction:^(UIImage *image) {
        DLog(@"touxiang===== %@" ,image);
        if (image) {
//            self.customImage = image;
//           [self.headView.userImv setImage:image forState:0];
//
//
//
               [self postImageDta:image];

        }
        
        
    }];
}


#pragma mark=============================上传头像=============================

-(void)postImageDta:(UIImage*)image{
    [SVProgressHUD show];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    NSData *finallImageData = UIImageJPEGRepresentation(newImage,0.50);

    NSData *data = [self resetSizeOfImageData:image maxSize:1024];

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *ticket = [user valueForKey:@"ticket"];
    NSString *secret = @"UHnyKzP5sNmh2EV0Dflgl4VfzbaWc4crQ7JElfw1cuNCbcJUau";
    NSString *nonce = [self ret32bitString];//随机数
    NSString *curTime = [self dateTransformToTimeSp];
    NSString *checkSum = [self sha1:[NSString stringWithFormat:@"%@%@%@" ,secret ,  nonce ,curTime]];
    
    [dic setValue:secret forKey:@"secret"];
    [dic setValue:nonce forKey:@"nonce"];
    [dic setValue:curTime forKey:@"curTime"];
    [dic setValue:checkSum forKey:@"checkSum"];
    [dic setValue:ticket forKey:@"ticket"];
    [dic setValue:[user valueForKey:@"userId"] forKey:@"id"];
    [dic setValue:mTypeIOS forKey:@"mtype"];

    //使用日期生成图片名称
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *fileName = [NSString stringWithFormat:@"%@.png",[formatter stringFromDate:[NSDate date]]];

    MHUploadParam *upParam = [[MHUploadParam alloc] init];
    upParam.name = @"headPic";
    upParam.fileName = fileName;
    upParam.mimeType =@"image/png";
    upParam.data = data;

    [MHAsiNetworkHandler startMonitoring];

    [MHNetworkManager uploadFileWithURL:[NSString stringWithFormat:@"%@/m/auth/user/updateHeadPic" ,baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        DLog(@"头像返回======= %@",returnData);
        if ([returnData[@"status"] integerValue] == 200) {
            
            [self.headView.userImv setImage:[UIImage imageNamed:returnData[@"data"]] forState:0];
            MyModel *model = self.myDataMarray[0];
            model.headPic = returnData[@"data"];
            [self.myDataMarray addObject:model];
//            SVProgressHUD.minimumDismissTimeInterval =2;
//            [SVProgressHUD showSuccessWithStatus:@"上传头像成功"];

        }else{
            [SVProgressHUD showSuccessWithStatus:returnData[@"msg"]];
        }
        [SVProgressHUD dismiss];

        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        DLog(@"头像上传error======= %@" ,error);
        [SVProgressHUD dismiss];

    } uploadParam:upParam showHUD:NO];


    
}

#pragma mark==================图片压缩===========================
- (NSData *)resetSizeOfImageData:(UIImage *)source_image maxSize:(NSInteger)maxSize
{
    //先调整分辨率
    CGSize newSize = CGSizeMake(source_image.size.width, source_image.size.height);
    DLog(@"wwwwwwww=w==w=w==w=w  %f %f " ,newSize.height , newSize.width);
    CGFloat tempHeight = newSize.height / maxSize;
    CGFloat tempWidth = newSize.width / maxSize;
    
    if (tempWidth > 1.0 && tempWidth > tempHeight) {
        newSize = CGSizeMake(source_image.size.width / tempWidth, source_image.size.height / tempWidth);
    }
    else if (tempHeight > 1.0 && tempWidth < tempHeight){
        newSize = CGSizeMake(source_image.size.width / tempHeight, source_image.size.height / tempHeight);
    }
    
    UIGraphicsBeginImageContext(newSize);
    [source_image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //调整大小
    NSData *imageData = UIImageJPEGRepresentation(newImage,1.0);
    NSUInteger sizeOrigin = [imageData length];
    NSUInteger sizeOriginKB = sizeOrigin / maxSize;
    if (sizeOriginKB > maxSize) {
        NSData *finallImageData = UIImageJPEGRepresentation(newImage,0.50);
        return finallImageData;
    }
    
    return imageData;
}





#pragma mark = 修改用户昵称

-(void)updataUserName:(NSString*)userNameString{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *ticket = [user valueForKey:@"ticket"];
    NSString *secret = @"UHnyKzP5sNmh2EV0Dflgl4VfzbaWc4crQ7JElfw1cuNCbcJUau";
    NSString *nonce = [self ret32bitString];//随机数
    NSString *curTime = [self dateTransformToTimeSp];
    NSString *checkSum = [self sha1:[NSString stringWithFormat:@"%@%@%@" ,secret ,  nonce ,curTime]];
    
    [dic setValue:secret forKey:@"secret"];
    [dic setValue:nonce forKey:@"nonce"];
    [dic setValue:curTime forKey:@"curTime"];
    [dic setValue:checkSum forKey:@"checkSum"];
    [dic setValue:ticket forKey:@"ticket"];
    [dic setValue:[user valueForKey:@"userId"] forKey:@"id"];
    [dic setValue:userNameString forKey:@"nickname"];
    [dic setValue:mTypeIOS forKey:@"mtype"];

    DLog(@"修改用户昵称dic==== %@" ,dic);
    [MHAsiNetworkHandler startMonitoring];

    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/m/auth/user/updateName" ,baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        DLog(@"修改用户昵称==== %@" ,returnData);
        if ([returnData[@"status"] integerValue] == 200) {
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
        }
    } failureBlock:^(NSError *error) {
        DLog(@"修改用户昵称error==== %@" ,error);

    } showHUD:NO];
    
}



#pragma mark = ===店家认证点击事件

-(void)shopNameBtnAction{
    
    if (self.shopCertifiMarray.count != 0) {
        ShopCertificationViewController *VC = [ShopCertificationViewController new];
        VC.hidesBottomBarWhenPushed = YES;
        VC.isRemakeShopCerific = @"1";
        VC.shopCertifiMyModel = [self.shopCertifiMarray firstObject];
        [self.navigationController pushViewController:VC animated:YES];
    }else{                    [self.shopCertifiMarray removeAllObjects];

        //首次认证
        ShopCertificationViewController *VC = [ShopCertificationViewController new];
        VC.isRemakeShopCerific = @"0";
        VC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:VC animated:YES];

    }
}







#pragma mark = 查看全部订单

-(void)checkAllOrderBtnAction{
    DLog(@"查看全部订单");
    if ([[GlobalHelper shareInstance].isLoginState isEqualToString:@"1"]) {
        MyOrderViewController *VC = [MyOrderViewController new];
        VC.selectIndex = 0;
        VC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:VC animated:YES];
      
        
    }else{
        LoginViewController *VC = [LoginViewController new];
        VC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:VC animated:YES];
    }
}

#pragma mark = 等待付款

-(void)waitPayBtnAction{
    DLog(@"等待付款");
    if ([[GlobalHelper shareInstance].isLoginState isEqualToString:@"1"]) {
        
        MyOrderViewController *VC = [MyOrderViewController new];
        VC.hidesBottomBarWhenPushed = YES;
        VC.selectIndex = 1;
        [self.navigationController pushViewController:VC animated:YES];
      
    }else{
        LoginViewController *VC = [LoginViewController new];
        VC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:VC animated:YES];
        
    }
}




#pragma mark = 等待发货

-(void)waitSendGoodsBtnAction{
    DLog(@"等待发货");
    if ([[GlobalHelper shareInstance].isLoginState isEqualToString:@"1"]) {
        MyOrderViewController *VC = [MyOrderViewController new];
        VC.hidesBottomBarWhenPushed = YES;
        VC.selectIndex = 2;
        [self.navigationController pushViewController:VC animated:YES];
        
    }else{
        LoginViewController *VC = [LoginViewController new];
        VC.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:VC animated:YES];
        
    }
}

#pragma mark = 等待收货

-(void)waitReceiveBtnAction{
    DLog(@"等待收货");
    if ([[GlobalHelper shareInstance].isLoginState isEqualToString:@"1"]) {
        MyOrderViewController *VC = [MyOrderViewController new];
        VC.hidesBottomBarWhenPushed = YES;
        VC.selectIndex = 3;
        
        [self.navigationController pushViewController:VC animated:YES];
      
        
    }else{
        LoginViewController *VC = [LoginViewController new];
        VC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:VC animated:YES];
    }
}

#pragma mark = 等待评价

-(void)waitCommentBtnAction{
    DLog(@"等待评价");
    if ([[GlobalHelper shareInstance].isLoginState isEqualToString:@"1"]) {
        
        MyOrderViewController *VC = [MyOrderViewController new];
        VC.hidesBottomBarWhenPushed = YES;
        // VC.selectIndex = 4;
        [self.navigationController pushViewController:VC animated:YES];
        
     
    }else{
        LoginViewController *VC = [LoginViewController new];
        VC.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:VC animated:YES];
        
    }
}

#pragma mark = 退货/售后

-(void)returnGoodsBtnAction{
    DLog(@"售后");
    if ([[GlobalHelper shareInstance].isLoginState isEqualToString:@"1"]) {
        
        MyOrderViewController *VC = [MyOrderViewController new];
        VC.hidesBottomBarWhenPushed = YES;
        VC.selectIndex = 4;
        [self.navigationController pushViewController:VC animated:YES];
    }else{
        LoginViewController *VC = [LoginViewController new];
        VC.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:VC animated:YES];
   
    }
}

#pragma mark = 点击事件

-(void)addCkickAction{
    
    [self.headView.checkAllOrderBtn addTarget:self action:@selector(checkAllOrderBtnAction) forControlEvents:1];
    
    [self.headView.waitPayBtn addTarget:self action:@selector(waitPayBtnAction) forControlEvents:1];
    
    [self.headView.waitSendGoodsBtn addTarget:self action:@selector(waitSendGoodsBtnAction) forControlEvents:1];
    
    [self.headView.waitReceiveBtn addTarget:self action:@selector(waitReceiveBtnAction) forControlEvents:1];
    
    [self.headView.waitCommentBtn addTarget:self action:@selector(waitCommentBtnAction) forControlEvents:1];
    
    [self.headView.returnGoodsBtn addTarget:self action:@selector(returnGoodsBtnAction) forControlEvents:1];
    [self.headView.userImv addTarget:self action:@selector(userImvBtn) forControlEvents:1];
    [self.headView.loginBtn addTarget:self action:@selector(loginBtnAction) forControlEvents:1];
    ///修改名字
    __weak __typeof(self) weakSelf = self;

    self.headView.userNameBlock = ^(NSString *userName) {
        DLog(@"uuuuu=== %@" ,userName);
        [weakSelf updataUserName:userName];
    };
   // [self.headView.userName addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.headView.shopNameBtn addTarget:self action:@selector(shopNameBtnAction) forControlEvents:1];
}



-(UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-kBottomBarHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.backgroundColor = RGB(238, 238, 238, 1);
    }
    return _tableView;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return 3;
    }else if (section == 2){
        return 1;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 235*kScale;
    }
    return 15*kScale;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        self.headView = [[MyHeadView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 235*kScale)];
        self.headView.backgroundColor = [UIColor whiteColor];
        if (self.myDataMarray.count != 0)
        {
            MyModel *model = self.myDataMarray[section];
            [self.headView addTopHeadView:[GlobalHelper shareInstance].isLoginState configHeadViewMyModel:model];

            
        }else
        {
            [self.headView addTopHeadView:[GlobalHelper shareInstance].isLoginState configHeadViewMyModel:nil];
        }
       
        
        [self addCkickAction];
        return self.headView;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 15)];
    view.backgroundColor = RGB(238, 238, 238, 1);
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 0.1)];
    view.backgroundColor = RGB(238, 238, 238, 1);

    return view;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *imvArray = @[@"dingwei" , @"kefu" , @"shouhou-1"];
    NSArray *titleArray = @[@"收货地址管理" , @"联系客服" ,@"售后服务"];
    UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"my_cell"];
    if (cell1 == nil) {
        cell1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"my_cell"];
        [cell1 setSelectionStyle:UITableViewCellSelectionStyleNone]; //取消选中的阴影效果
        cell1.backgroundColor = [UIColor whiteColor];
        cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    if (indexPath.section == 1) {
        cell1.imageView.image = [UIImage imageNamed:imvArray[indexPath.row]];
        cell1.textLabel.text  = titleArray[indexPath.row];
        
    }else if (indexPath.section == 2){
        cell1.imageView.image = [UIImage imageNamed:@"shezhi"];
        cell1.textLabel.text  = @"设置";
    }
    cell1.textLabel.font = [UIFont systemFontOfSize:15.0f*kScale];
    return cell1;
}

#pragma mark  = 点击事件


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            
            if ([[GlobalHelper shareInstance].isLoginState isEqualToString:@"1"]) {
                MyAddressViewController *VC = [MyAddressViewController new];
                VC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:VC animated:YES];
              
                
            }else{
                LoginViewController *VC = [LoginViewController new];
                VC.hidesBottomBarWhenPushed = YES;
                
                [self.navigationController pushViewController:VC animated:YES];
            }
            
        }else if (indexPath.row == 1){
            DLog(@"联系客服");
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"4001106111"];
            UIWebView * callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [self.view addSubview:callWebview];
//
//            ContactServiceViewController *VC = [ContactServiceViewController new];
//            VC.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:VC animated:YES];
        }else if (indexPath.row == 2){
            
            
            AfterServiceViewController *VC = [AfterServiceViewController new];
            VC.hidesBottomBarWhenPushed = YES;

            [self.navigationController pushViewController:VC animated:YES];
        }
        
    }else if (indexPath.section == 2){
        
        SettingViewController *VC = [SettingViewController new];
        VC.hidesBottomBarWhenPushed = YES;

        [self.navigationController pushViewController:VC animated:YES];
    
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
