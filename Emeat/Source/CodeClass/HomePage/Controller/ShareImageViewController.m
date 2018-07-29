//
//  ShareImageViewController.m
//  Emeat
//
//  Created by liuheshun on 2018/7/16.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "ShareImageViewController.h"
#import "ShareImageView.h"
#import "ShareImageBottomView.h"


@interface ShareImageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) ShareImageView *shareImageView;
@property (nonatomic,strong) ShareImageBottomView *shareBottomView;

@end

@implementation ShareImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navItem.title = @"分享图片";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.shareBottomView];
    [self.shareBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-LL_TabbarSafeBottomMargin);
        make.height.equalTo(@(160*kScale));
        
    }];
    
    
    
}

-(UIImage*)shareImage{
    // UIGraphicsBeginImageContext(self.shareView.bounds.size); //currentView 当前的view
    UIGraphicsBeginImageContextWithOptions(self.shareImageView.bounds.size, NO, 0.0);//原图
    [self.shareImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


-(void)shareTypes:(int)scene{
    
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"ocr.jpg"];
    NSData *imageData = UIImageJPEGRepresentation([self shareImage], 1);
    [imageData writeToFile:filePath atomically:NO];
   
    
    
    WXMediaMessage *message = [WXMediaMessage message];
   // [message setThumbImage:[self shareImage]];
    WXImageObject *imageObject = [WXImageObject object];
    
    imageObject.imageData = imageData;
    message.mediaObject = imageObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    [WXApi sendReq:req];
}

#pragma mark = 微信好友
-(void)wechatBtnAction{
    DLog(@"微信好友");
    [self shareTypes:WXSceneSession];
   
    
}
#pragma mark = 微信朋友圈

-(void)wechatTimeLineBtnAction{
    [self shareTypes:WXSceneTimeline];

    DLog(@"微信朋友圈");

}
- (ShareImageView *)shareImageView{
    if (!_shareImageView) {
        _shareImageView = [[ShareImageView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    }
    return _shareImageView;
}



- (ShareImageBottomView *)shareBottomView{
    if (!_shareBottomView) {
        _shareBottomView = [[ShareImageBottomView alloc] init];
        _shareBottomView.backgroundColor = RGB(244, 244, 244, 1);
        [_shareBottomView.wechatBtn addTarget:self action:@selector(wechatBtnAction) forControlEvents:1];
        [_shareBottomView.wechatTimeLineBtn addTarget:self action:@selector(wechatTimeLineBtnAction) forControlEvents:1];

    }
    return _shareBottomView;
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
    return 0.1*kScale;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
    return kHeight;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    [self.shareImageView configShareViewMainimage:self.productImageURL Title:self.productTitle Desc:self.productContent Prices:self.productPrices codeURL:[NSString stringWithFormat:@"%@/breaf/beef_detail.html?ds=%@" ,baseUrl,self.detailsId] PriceTypes:self.priceTypes];
    return self.shareImageView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 160*kScale;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 0.1*kScale)];
    view.backgroundColor = [UIColor whiteColor];
    
    return view;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"list_cellss"];
    if (cell1 == nil) {
        cell1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"list_cellss"];
        
        //[cell1 setSelectionStyle:UITableViewCellSelectionStyleNone]; //取消选中的阴影效果
        cell1.backgroundColor = [UIColor orangeColor];
        
    }
    
    return cell1;
}

#pragma mark  = 点击事件


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //隐藏tabBar
    
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
