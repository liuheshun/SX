//
//  SaleMoneyViewController.m
//  Emeat
//
//  Created by liuheshun on 2018/8/28.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "SaleMoneyViewController.h"
#import "SaleMoneyTableViewCell.h"
#import "SaleWebViewController.h"
#import "ActionSheetView.h"
#import "SaleShareImageViewController.h"

@interface SaleMoneyViewController ()<UITableViewDelegate ,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UIButton *leftBtn;

@property (nonatomic,strong) UIButton *rightBtn;

///分销商id
@property (nonatomic,strong) NSString *distributorUid;




@end

@implementation SaleMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(238, 238, 238, 1);
    self.navItem.title = @"赛鲜推手 躺着赚钱";
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.leftBtn];
    [self.view addSubview:self.rightBtn];
    
    [self requestSalePeopleId];
}


//////
-(void)requestSalePeopleId{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic = [self checkoutData];
    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/cas/d/getDistributor" ,baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        
        if ([returnData[@"code"] integerValue] == 00 ) {
            
            self.distributorUid = [NSString stringWithFormat:@"%@" ,returnData[@"data"][@"distributorUid"]];
            
        }else{
            
        }
        
       // DLog(@"分销 ===== %@" ,returnData);
        
        
    } failureBlock:^(NSError *error) {
        
        
    } showHUD:NO];
    
    
    
    
}






#pragma mark =======推手链接
-(void)saleURLleftBtnAction{
    
    [self linkingOfShare];
    
}

#pragma mark=====================链接分享============================

-(void)linkingOfShare{
    
    
    NSArray *titlearr = @[@"",@"微信好友",@"微信朋友圈",@""];
    NSArray *imageArr = @[@"",@"微信",@"朋友圈",@""];
    ActionSheetView *actionsheet  = [[ActionSheetView alloc] initWithShareHeadOprationWith:titlearr andImageArry:imageArr andProTitle:@"分享至" and:ShowTypeIsShareStyle];
    actionsheet.otherBtnFont = 14.0f;
    actionsheet.otherBtnColor = RGB(51, 51, 51, 1);
    actionsheet.cancelBtnFont = 14.0f;
    actionsheet.cancelBtnColor = RGB(51, 51, 51, 1);
    
    [actionsheet setBtnClick:^(NSInteger btnTag) {
        
        
        if (btnTag ==0) {
        }else if (btnTag ==1){
            //分享到聊天
            [self wxchatWebShare:WXSceneSession];
        }else if (btnTag ==2){
            //分享到朋友圈
            [self wxchatWebShare:WXSceneTimeline];
        }else if (btnTag == 3){
        }
        
    }];
    
    [[UIApplication sharedApplication].keyWindow addSubview:actionsheet];
}



-(void)wxchatWebShare:(int)scene{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = self.productTitle;
    message.description = self.productContent;
    
    [message setThumbImage:[self handleImageWithURLStr:self.productImageURL]];
    WXWebpageObject *webpageObject = [WXWebpageObject object];
    webpageObject.webpageUrl = [NSString stringWithFormat:@"%@/breaf/beef_detail.html?ds=%@&disuid=%@" ,baseUrl,self.detailsId ,self.distributorUid];
    message.mediaObject = webpageObject;
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    
    [WXApi sendReq:req];
    
}
- (UIImage *)handleImageWithURLStr:(NSString *)imageURLStr {
    
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURLStr]];
    NSData *newImageData = imageData;
    // 压缩图片data大小
    newImageData = UIImageJPEGRepresentation([UIImage imageWithData:newImageData scale:0.1], 0.1f);
    UIImage *image = [UIImage imageWithData:newImageData];
    
    // 压缩图片分辨率(因为data压缩到一定程度后，如果图片分辨率不缩小的话还是不行)
    CGSize newSize = CGSizeMake(200, 200);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,(NSInteger)newSize.width, (NSInteger)newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


#pragma mark ========推手图片
-(void)saleImageRightBtnAction{
    
    SaleShareImageViewController *VC = [SaleShareImageViewController new];
    VC.productTitle = self.productTitle;
    VC.productContent = self.productContent;
    VC.productImageURL = self.productImageURL;
    VC.detailsId = self.detailsId;
    VC.productPrices = self.productPrices;
    VC.priceTypes = self.priceTypes;
    VC.distributorUid = self.distributorUid;
    
    [self.navigationController pushViewController:VC animated:YES];
}


-(UIButton *)leftBtn{
    if (_leftBtn == nil) {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.frame = CGRectMake(42*kScale, kHeight-40*kScale-25*kScale-LL_TabbarSafeBottomMargin,125*kScale, 40*kScale);
//        _leftBtn.backgroundColor = RGB(238, 238, 238, 1);
        [_leftBtn setImage:[UIImage imageNamed:@"推手链接"] forState:0];
        [_leftBtn setTitle:@"推手链接" forState:0];
        _leftBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f*kScale];
        _leftBtn.backgroundColor = RGB(249, 133, 35, 1);
        _leftBtn.layer.cornerRadius = 10*kScale;
        _leftBtn.layer.masksToBounds = YES;
        [_leftBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:10*kScale];
        [_leftBtn addTarget:self action:@selector(saleURLleftBtnAction) forControlEvents:1];

    }
    return _leftBtn;
}

-(UIButton *)rightBtn{
    if (_rightBtn == nil) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.frame = CGRectMake(kWidth-125*kScale-42*kScale, kHeight-40*kScale-25*kScale-LL_TabbarSafeBottomMargin, 125*kScale, 40*kScale);
//        _rightBtn.backgroundColor = RGB(238, 238, 238, 1);
        [_rightBtn setImage:[UIImage imageNamed:@"推手图片"] forState:0];
//        [_rightBtn setTitleColor:RGB(51, 51, 51, 1) forState:0];
        _rightBtn.backgroundColor = RGB(249, 133, 35, 1);
        _rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f*kScale];

        [_rightBtn setTitle:@"推手图片" forState:0];
        _rightBtn.layer.cornerRadius = 10*kScale;
        _rightBtn.layer.masksToBounds = YES;
        
        [_rightBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:10*kScale];
        [_rightBtn addTarget:self action:@selector(saleImageRightBtnAction) forControlEvents:1];

    }
    return _rightBtn;
}


-(UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kBarHeight, kWidth, kHeight-kBarHeight-LL_TabbarSafeBottomMargin) style:UITableViewStyleGrouped];
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
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
    return 0.0001*kScale;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 15*kScale)];
    view.backgroundColor = [UIColor redColor];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001*kScale;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 15*kScale)];
    view.backgroundColor = [UIColor cyanColor];
    
    return view;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SaleMoneyTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"SaleMoneyTableViewCell"];
    if (cell1 == nil) {
        cell1 = [[SaleMoneyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SaleMoneyTableViewCell"];
        
        [cell1 setSelectionStyle:UITableViewCellSelectionStyleNone]; //取消选中的阴影效果
        cell1.backgroundColor = [UIColor whiteColor];
        [cell1.enterSaleWeb addTarget:self action:@selector(enterSaleWebAction) forControlEvents:1];
    }
    
    
    return cell1;
}

#pragma mark  = 点击事件


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //隐藏tabBar
    
}

#pragma mark ====进入分销平台
-(void)enterSaleWebAction{
    
    SaleWebViewController*VC = [SaleWebViewController new];
    
    [self.navigationController pushViewController:VC animated:YES];
    
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
