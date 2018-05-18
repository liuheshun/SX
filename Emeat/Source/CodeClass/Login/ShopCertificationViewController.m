//
//  ShopCertificationViewController.m
//  Emeat
//
//  Created by liuheshun on 2018/4/18.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "ShopCertificationViewController.h"

#import "ShopCeritficationView.h"
#import "SearchLocationAddressViewController.h"

#import "MMMyCustomView.h"

#define kMaxNumber 20


@interface ShopCertificationViewController ()

@property (nonatomic,strong) ShopCeritficationView *shopCeritficationView;

@property (nonatomic,strong) NSMutableDictionary *addressDic;
///店铺名称
@property (nonatomic,strong) NSString *ShopName;
//店长姓名
@property (nonatomic,strong) NSString *ShopManagerName;
//手机号
@property (nonatomic,strong) NSString *ShopPhoneNumer;
//地址
@property (nonatomic,strong) NSString *ShopAddress;
//详细地址
@property (nonatomic,strong) NSString *ShopDetailsAddress;
//邀请码
@property (nonatomic,strong) NSString *ShopInviteCode;


@end

@implementation ShopCertificationViewController

-(void)viewWillAppear:(BOOL)animated{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
}

//-(void)viewWillDisappear:(BOOL)animated{
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(238, 238, 238, 1);
    
    [self.view addSubview:self.shopCeritficationView];
    [self addBlockAction];
    if ([self.isRemakeShopCerific isEqualToString:@"1"]) {
        self.navItem.title = @"重新认证";
        [self.shopCeritficationView.skipBtn removeFromSuperview];
        
        [self.shopCeritficationView.submitBtn setTitle:@"重新认证" forState:0];
        [self.shopCeritficationView.submitBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.shopCeritficationView.textFieldInviteCode.mas_bottom).with.offset(30*kScale);
            make.right.equalTo(self.shopCeritficationView.mas_right).with.offset(-15*kScale);
            make.left.equalTo(self.shopCeritficationView.mas_left).with.offset(15*kScale);

            make.height.equalTo(@(40*kScale));
        }];
        
    }else{
        self.navItem.title = @"店铺认证";
        [self.shopCeritficationView.submitBtn setTitle:@"提交认证" forState:0];
        [self.shopCeritficationView.skipBtn setTitle:@"跳过" forState:0];

    }
    
    ///赋值回显
    [self.shopCeritficationView configShopCertifiViewWithModel:self.shopCertifiMyModel];
    
    
    
    [MMPopupWindow sharedWindow].touchWildToHide = YES;
    MMAlertViewConfig1 *alertConfig = [MMAlertViewConfig1 globalConfig1];
    alertConfig.defaultTextOK = @"确定";
    alertConfig.defaultTextCancel = @"取消";
    alertConfig.titleFontSize = 17*kScale;
    alertConfig.detailFontSize = 13*kScale;
    alertConfig.buttonFontSize = 15*kScale;
    alertConfig.buttonHeight = 40*kScale;
    alertConfig.width = 315*kScale;
    alertConfig.buttonBackgroundColor = [UIColor redColor];
    alertConfig.detailColor = RGB(136, 136, 136, 1);
    alertConfig.itemNormalColor = [UIColor whiteColor];
    
    alertConfig.splitColor = [UIColor whiteColor];
}

#pragma mark ========上传店铺认证信息

-(void)postShopCertifiDate{
    
    NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *ticket = [user valueForKey:@"ticket"];
    NSString *secret = @"UHnyKzP5sNmh2EV0Dflgl4VfzbaWc4crQ7JElfw1cuNCbcJUau";
    NSString *nonce = [self ret32bitString];//随机数
    NSString *curTime = [self dateTransformToTimeSp];
    NSString *checkSum = [self sha1:[NSString stringWithFormat:@"%@%@%@" ,secret ,  nonce ,curTime]];
    
    [dic1 setValue:secret forKey:@"secret"];
    [dic1 setValue:nonce forKey:@"nonce"];
    [dic1 setValue:curTime forKey:@"curTime"];
    [dic1 setValue:checkSum forKey:@"checkSum"];
    [dic1 setValue:ticket forKey:@"ticket"];
    [dic1 setValue:self.ShopName forKey:@"storeName"];
    [dic1 setValue:self.ShopManagerName forKey:@"kp"];
    [dic1 setValue:self.ShopPhoneNumer forKey:@"callNumber"];
    [dic1 setValue:self.ShopAddress forKey:@"address"];
    [dic1 setValue:self.ShopDetailsAddress forKey:@"addressDetail"];
    [dic1 setValue:self.ShopInviteCode forKey:@"userName"];
    //    ///
    //    [dic1 setValue:@"0" forKey:@"isDeleted"];
    
    //parentId=0
    [MHAsiNetworkHandler startMonitoring];
    NSString *url;
    if ([self.isRemakeShopCerific isEqualToString:@"1"]) {//重新认证
        [dic1 setValue:[NSString stringWithFormat:@"%ld" ,self.shopCertifiMyModel.storeId] forKey:@"id"];
        url = [NSString stringWithFormat:@"%@/auth/mobile/store/updateStore" ,baseUrl];
    }else{
        url = [NSString stringWithFormat:@"%@/auth/mobile/store/newStore" ,baseUrl];
    }
    DLog(@"上传店铺信息dic==== %@      ====== %@" ,dic1 ,url);
    
    __block int index1;
    [MHNetworkManager postReqeustWithURL:url params:dic1 successBlock:^(NSDictionary *returnData) {
        DLog(@"上传店铺信息returnData==== %@" ,returnData);
        if ([returnData[@"status"] integerValue] == 200) {
            
            MMPopupItemHandler block = ^(NSInteger index){
                
                NSLog(@"clickd %@ button",@(index));
                //返回到指定的控制器，要保证前面有入栈。
                index1 = (int)[[self.navigationController viewControllers]indexOfObject:self];
                if (index1>2) {
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index1-2)] animated:YES];
                }else
                {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
                
            };
            NSArray *items = @[MMItemMake(@"知道了", MMItemTypeNormal, block),];
            
            MMMyCustomView *alertView =  [[MMMyCustomView alloc] initWithTitle:@"认证提示" detail:@" 您的店铺信息已成功提交，请耐心等待工作人员与您联系，客服热线4001106111" items:items];
            
            alertView.attachedView.mm_dimBackgroundBlurEnabled = NO;
            
            alertView.attachedView.mm_dimBackgroundBlurEffectStyle = UIBlurEffectStyleDark;
            
            [alertView show];
            
            
            
            
        }else{
            MMPopupItemHandler block = ^(NSInteger index){
                NSLog(@"clickd %@ button",@(index));
            };
            NSArray *items = @[MMItemMake(@"知道了", MMItemTypeNormal, block),];
            MMMyCustomView *alertView =  [[MMMyCustomView alloc] initWithTitle:@"认证提示" detail:@" 您的店铺信息提交失败，请稍后重试，如需帮助请拨打客服热线 4001106111" items:items];
            
            alertView.attachedView.mm_dimBackgroundBlurEnabled = NO;
            
            alertView.attachedView.mm_dimBackgroundBlurEffectStyle = UIBlurEffectStyleDark;
            
            [alertView show];
            
        }
        
        
        
    } failureBlock:^(NSError *error) {
        DLog(@"上传店铺信息error==== %@" ,error);
        
    } showHUD:NO];
    
    
    
    
}

#pragma mark =====跳过认证

-(void)skipBtnAction{
    //返回到指定的控制器，要保证前面有入栈。

    int index1 = (int)[[self.navigationController viewControllers]indexOfObject:self];
    if (index1>2) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index1-2)] animated:YES];
    }else
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}

#pragma mark =====提交认证

-(void)submitBtnAction{
    
    
    
    [self.view endEditing:YES]; //实现该方法是需要注意view需要是继承UIControl而来的
    self.ShopName = self.shopCeritficationView.textFieldShopName.text;
    self.ShopManagerName = self.shopCeritficationView.textFieldShopManagerName.text;
    self.ShopPhoneNumer = self.shopCeritficationView.textFieldPhoneNumer.text;
    self.ShopAddress = self.shopCeritficationView.textFieldCity.text;
    self.ShopDetailsAddress = self.shopCeritficationView.textFieldDetailsAddress.text;
    self.ShopInviteCode = self.shopCeritficationView.textFieldInviteCode.text;
    
    
    DLog(@"保存 = = 名字= %@  dianzhang==%@  电话== %@    详细地址== %@  dizhhi== %@  code= %@" , self.shopCeritficationView.textFieldShopName.text, self.shopCeritficationView.textFieldShopManagerName.text ,self.ShopPhoneNumer , self.ShopAddress  ,self.ShopDetailsAddress ,self.ShopInviteCode);
    
    
    if (self.ShopName.length == 0 || self.ShopManagerName.length == 0 || self.ShopPhoneNumer.length == 0 ) {
        
        [self alertMessage:@"请填写完整的店铺信息" willDo:nil];
        
    }else if ((self.ShopAddress.length != 0 && self.ShopDetailsAddress.length == 0) || (self.ShopAddress.length == 0 && self.ShopDetailsAddress.length != 0)){
        [self alertMessage:@"请填写完整的店铺地址信息" willDo:nil];
    }
    
    else{
        
        if ([self checkTel:self.ShopPhoneNumer] == NO) {
            
            [self alertMessage:@"请填写正确格式的手机号" willDo:nil];
            
        }else if ([self containTheillegalCharacter:self.ShopName] == YES){
            
            [self alertMessage:@"姓名或详细地址不能包含特殊字符" willDo:nil];
            
        }else if (self.ShopDetailsAddress.length !=0 && [self containTheillegalCharacter:self.ShopDetailsAddress] == YES){
            
            [self alertMessage:@"姓名或详细地址不能包含特殊字符" willDo:nil];
            
        }else if ([self containTheillegalCharacter:self.ShopManagerName] == YES){
            [self alertMessage:@"姓名或详细地址不能包含特殊字符" willDo:nil];
            
        }else{
            
            [self.addressDic setValue:self.ShopName forKey:@"shopName"];
            [self.addressDic setValue:self.ShopManagerName forKey:@"shopManagerName"];
            [self.addressDic setValue:self.ShopPhoneNumer forKey:@"shopPhoneNum"];
            
            [self.addressDic setValue:[NSString stringWithFormat:@"%@" ,self.ShopAddress] forKey:@"receiverProvince"];
            [self.addressDic setValue:[NSString stringWithFormat:@"%@"  ,self.ShopAddress] forKey:@"shopAddressDetails"];///收货人详细地址:receiverAddress
            
            
            [self.addressDic setValue:[NSString stringWithFormat:@"%@" ,self.ShopInviteCode] forKey:@"shopInviteCode"];
            DLog(@"%@" ,self.addressDic);
            [self postShopCertifiDate];
            
            
        }
        
    }
    
    
    
}





-(void)addBlockAction{
    __weak __typeof(self) weakSelf = self;
    
#pragma mark = 保存收货地址
    
    self.shopCeritficationView.textFieldTitleBlock = ^(NSMutableDictionary *dic) {
        
        
    };
    
    
    
    
    self.shopCeritficationView.addressTitleBlockClickAction = ^(NSMutableDictionary *dic) {
        
        SearchLocationAddressViewController *VC = [SearchLocationAddressViewController new];
        
        VC.returnSearchAddressBlock = ^(Location *location) {
            
            if ([location.administrativeArea isEqualToString:location.city]) {//判断是否为直辖市
                weakSelf.shopCeritficationView.textFieldCity.text = [NSString stringWithFormat:@"%@%@%@" ,location.city,location.subLocality,location.name];
                //                weakSelf.ShopAddress = location.city;
            }else{
                weakSelf.shopCeritficationView.textFieldCity.text = [NSString stringWithFormat:@"%@%@%@%@" ,location.administrativeArea ,location.city,location.subLocality ,location.name];
                
                //                weakSelf.ShopAddress = location.administrativeArea;
            }
            //            weakSelf.shopCeritficationView.textFieldSubstreet.text = [NSString stringWithFormat:@"%@%@",location.thoroughfare ,location.name];
            
            weakSelf.ShopAddress = [NSString stringWithFormat:@"%@" ,weakSelf.shopCeritficationView.textFieldCity.text];
            
        };
        [weakSelf.navigationController pushViewController:VC animated:YES];
        DLog(@"进入选着地址页面");
        
    };
    
    
}





-(void)phoneNumTextFieldTextFieldDidChange:(UITextField*)textField{
    
    if (textField.text.length > 11)
    {
        textField.text = [textField.text substringToIndex:11];
    }
    
    DLog(@"sssss== %@" ,textField.text);
    
    if (textField.text.length == 11) {
        if (![self checkTel:textField.text] ) {
            [SVProgressHUD showInfoWithStatus:@"请输入正确手机号码"];
        }
        
    }
}

-(void)textFieldNameTextFieldDidChange:(UITextField*)textField{
    if (kMaxNumber == 0) return;
    
    NSString *toBeString = textField.text;
    
    NSLog(@" 打印信息toBeString:%@",toBeString);
    
    NSString *lang = [[textField textInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        
        //判断markedTextRange是不是为Nil，如果为Nil的话就说明你现在没有未选中的字符，
        //可以计算文字长度。否则此时计算出来的字符长度可能不正确
        
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分(感觉输入中文的时候才有)
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position)
        {
            //中文和字符一起检测  中文是两个字符
            if ([toBeString getStringLenthOfBytes] > kMaxNumber)
            {
                textField.text = [toBeString subBytesOfstringToIndex:kMaxNumber];
                [SVProgressHUD showInfoWithStatus:@"姓名长度10字以内"];
                
            }
        }
    }
    else
    {
        if ([toBeString getStringLenthOfBytes] > kMaxNumber)
        {
            textField.text = [toBeString subBytesOfstringToIndex:kMaxNumber];
            [SVProgressHUD showInfoWithStatus:@"姓名长度10字以内"];
            
        }
    }
    
    
}

-(ShopCeritficationView*)shopCeritficationView{
    if (!_shopCeritficationView) {
        _shopCeritficationView = [[ShopCeritficationView alloc] initWithFrame:CGRectMake(0, kBarHeight, kWidth, kHeight-kBarHeight)];
        _shopCeritficationView.backgroundColor = RGB(238, 238, 238, 1);
    }
    [_shopCeritficationView.textFieldPhoneNumer addTarget:self action:@selector(phoneNumTextFieldTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_shopCeritficationView.textFieldShopName addTarget:self action:@selector(textFieldNameTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [_shopCeritficationView.submitBtn addTarget:self action:@selector(submitBtnAction) forControlEvents:1];
    [_shopCeritficationView.skipBtn addTarget:self action:@selector(skipBtnAction) forControlEvents:1];
    return _shopCeritficationView;
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

