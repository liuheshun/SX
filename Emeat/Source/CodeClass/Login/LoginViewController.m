//
//  LoginViewController.m
//  Emeat
//
//  Created by liuheshun on 2017/12/27.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginView.h"
#import "UserAgreementViewController.h"
#import "ShopCertificationViewController.h"
@interface LoginViewController ()<UITextFieldDelegate>
@property (nonatomic,strong) LoginView *loginView;
@property (nonatomic,assign) NSInteger  phoneNum;


@end

@implementation LoginViewController
{
    int timeoutCount;
}
-(void)viewWillAppear:(BOOL)animated{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(238, 238, 238, 1);
    self.navItem.title = @"登录/注册";
    [self setLoginViewFrame];
    
}




#pragma mark = 获取ticket

-(void)requestTicket{
    NSString *secret = @"UHnyKzP5sNmh2EV0Dflgl4VfzbaWc4crQ7JElfw1cuNCbcJUau";
    NSString *nonce = [self ret32bitString];//随机数
    NSString *curTime = [self dateTransformToTimeSp];
    NSString *checkSum = [self sha1:[NSString stringWithFormat:@"%@%@%@" ,secret ,  nonce ,curTime]];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:secret forKey:@"secret"];
    [dic setObject:nonce forKey:@"nonce"];
    [dic setObject:curTime forKey:@"curTime"];
    [dic setObject:checkSum forKey:@"checkSum"];
    [dic setValue:mTypeIOS forKey:@"mtype"];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [dic setValue:[user valueForKey:@"appVersionNumber"] forKey:@"appVersionNumber"];
    [dic setValue:[user valueForKey:@"user"] forKey:@"user"];
    DLog(@"获取ticket== %@" ,dic);
    
    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/cas/mobile/getticket.html" ,baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        DLog(@"ticker=== %@" ,returnData);
        if ([returnData[@"code"] isEqualToString:@"00"]) {
            NSString *ticket = returnData[@"ticket"];
            ///保存ticket
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:ticket forKey:@"ticket"];
            [self requestCode:ticket];
        }
        
    } failureBlock:^(NSError *error) {
        
    } showHUD:NO];
    
}

#pragma mark = 获取验证码

-(void)requestCode:(NSString*)ticket{
    NSString *secret = @"UHnyKzP5sNmh2EV0Dflgl4VfzbaWc4crQ7JElfw1cuNCbcJUau";
    NSString *nonce = [self ret32bitString];//随机数
    NSString *curTime = [self dateTransformToTimeSp];
    NSString *checkSum = [self sha1:[NSString stringWithFormat:@"%@%@%@" ,secret ,  nonce ,curTime]];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:secret forKey:@"secret"];
    [dic setObject:nonce forKey:@"nonce"];
    [dic setObject:curTime forKey:@"curTime"];
    [dic setObject:checkSum forKey:@"checkSum"];
    [dic setObject:ticket forKey:@"ticket"];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString * phoneNum = [user valueForKey:@"phoneNum"];
    [dic setObject:phoneNum forKey:@"phone"];
    [dic setValue:mTypeIOS forKey:@"mtype"];

    [dic setValue:[user valueForKey:@"appVersionNumber"] forKey:@"appVersionNumber"];
    [dic setValue:[user valueForKey:@"user"] forKey:@"user"];
    DLog(@"获取验证码== %@" ,dic);

    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/cas/mobile/sendSmsByPhone" ,baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        DLog(@"code=== %@" ,returnData);
      
        
    } failureBlock:^(NSError *error) {
        
    } showHUD:NO];
    
}
-(void)requestLogin{
    
    NSString *secret = @"UHnyKzP5sNmh2EV0Dflgl4VfzbaWc4crQ7JElfw1cuNCbcJUau";
    NSString *nonce = [self ret32bitString];//随机数
    NSString *curTime = [self dateTransformToTimeSp];
    NSString *checkSum = [self sha1:[NSString stringWithFormat:@"%@%@%@" ,secret ,  nonce ,curTime]];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:secret forKey:@"secret"];
    [dic setValue:nonce forKey:@"nonce"];
    [dic setValue:curTime forKey:@"curTime"];
    [dic setValue:checkSum forKey:@"checkSum"];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [dic setValue:[user valueForKey:@"ticket"] forKey:@"ticket"];
    [dic setValue:[user valueForKey:@"phoneNum"] forKey:@"phone"];
    [dic setValue:[user valueForKey:@"code"] forKey:@"code"];
    [dic setValue:mTypeIOS forKey:@"mtype"];

    [dic setValue:[user valueForKey:@"appVersionNumber"] forKey:@"appVersionNumber"];
    [dic setValue:[user valueForKey:@"user"] forKey:@"user"];
    DLog(@"获取登陆tttt== === %@" ,dic);

    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/cas/mobile/doLogin" ,baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        DLog(@"denglu 登陆== === %@  "   , returnData);
        if ([returnData[@"code"] isEqualToString:@"00"]) {
   
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setValue:returnData[@"data"][@"id"]  forKey:@"userId"];
            [user setValue:returnData[@"data"][@"customerAccount"] forKey:@"user"];
            [user setValue:@"1" forKey:@"isLoginState"];
            NSDictionary *data = returnData[@"data"];
            if ([data isKindOfClass:[NSDictionary class]] && [data objectForKey:@"store"]) {
                //
                [GlobalHelper shareInstance].merchantsIsLoginStated = @"2";
                [self.navigationController popViewControllerAnimated:YES];

            }else{//未认证
                [self.navigationController pushViewController:[ShopCertificationViewController new] animated:YES];
            }
            
            
            
            
            
        }else if ([returnData[@"code"] isEqualToString:@"0406"]){
            [SVProgressHUD showErrorWithStatus:@"手机号与验证码错误不匹配"];

        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"验证码错误"];
        }
        
    } failureBlock:^(NSError *error) {
        
    } showHUD:NO];
    
    
}

#pragma mark - 按钮倒计时
-(void)yourButtonTitleTime{
    
    __block int timeout=59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                self.loginView.codeBtn.backgroundColor = RGB(231, 35, 36, 1);

                [self.loginView.codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                self.loginView.codeBtn.userInteractionEnabled = YES;
                
            });
        }else{
            //          int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                self.loginView.codeBtn.backgroundColor = RGB(136, 136, 136, 1);
                [self.loginView.codeBtn setTitle:[NSString stringWithFormat:@"%@s",strTime] forState:UIControlStateNormal];
                self.loginView.codeBtn.userInteractionEnabled = NO;
                
            });
            timeout--;
            timeoutCount = timeout;
            
        }
    });
    dispatch_resume(_timer);
}
#pragma mark = 发送验证码

-(void)sendCodeMessage{
    [self requestTicket];
    DLog(@"发送消息");
    [self yourButtonTitleTime];

}



#pragma mark = 登陆

-(void)loginBtnActions{
    [self requestLogin];
    DLog(@"登陆 ===");
    

}


-(void)setLoginViewFrame{
    self.loginView = [[LoginView alloc] initWithFrame:CGRectMake(0, kBarHeight, kWidth, kHeight-kBarHeight-LL_TabbarSafeBottomMargin)];
    self.loginView.backgroundColor = RGB(238, 238, 238, 1);
    self.loginView.phoneNumTextField.delegate = self;
    self.loginView.codeTextField.delegate = self;
    [self.view addSubview:self.loginView];
    [self.loginView.phoneNumTextField addTarget:self action:@selector(phoneNumTextFieldTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.loginView.codeTextField addTarget:self action:@selector(codeTextFieldTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.loginView.codeBtn addTarget:self action:@selector(sendCodeMessage) forControlEvents:1];
    [self.loginView.loginBtn addTarget:self action:@selector(loginBtnActions) forControlEvents:1];
   
    if (![WXApi isWXAppInstalled]) {
        [self.loginView.oauthLable removeFromSuperview];
        [self.loginView.leftLineView removeFromSuperview];
        [self.loginView.rightLineView removeFromSuperview];
        [self.loginView.wechatBtn removeFromSuperview];
    }else{
        [self.loginView.wechatBtn addTarget:self action:@selector(wechatBtnLoginAction) forControlEvents:1];
    }
    
    [self.loginView.agreementBtn addTarget:self action:@selector(agreementBtnAction) forControlEvents:1];

}

#pragma mark == 微信登陆
-(void)wechatBtnLoginAction{
    
//
//    ShopCertificationViewController *VC = [ShopCertificationViewController new];
//    [self.navigationController pushViewController:VC animated:YES];
    
    
    
    if (![WXApi isWXAppInstalled]) {
        [self alertMessage:@"请安装微信客户端进行使用" willDo:nil];
    }else{
        SendAuthReq *req =[[SendAuthReq alloc ] init];
        req.scope = @"snsapi_userinfo"; // 此处不能随意改
        req.state = @"123"; // 这个貌似没影响
        [WXApi sendReq:req];
    }
}

#pragma mark = 用户协议
-(void)agreementBtnAction{
    
    UserAgreementViewController *VC = [UserAgreementViewController new];
    [self.navigationController pushViewController:VC animated:YES];
}

-(void)phoneNumTextFieldTextFieldDidChange:(UITextField*)textField{
    
        if (textField.text.length > 11) {
            textField.text = [textField.text substringToIndex:11];
        }
   
    DLog(@"sssss== %@" ,textField.text);

    if (textField.text.length == 11)
    {
        if (![self checkTel:textField.text] )
        {
            [SVProgressHUD showInfoWithStatus:@"手机格式不正确"];
        }
        else
        {
            if (timeoutCount >0) {
                self.loginView.codeBtn.backgroundColor = RGB(136, 136, 136, 1);
                self.loginView.codeBtn.userInteractionEnabled = NO;

            }else{
                self.loginView.codeBtn.backgroundColor = RGB(231, 35, 36, 1);
                self.loginView.codeBtn.userInteractionEnabled = YES;
            }
         
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setValue:textField.text forKey:@"phoneNum"];
            
            self.phoneNum = [textField.text integerValue];
            
            if (self.loginView.codeTextField.text.length!=0)
            {
                self.loginView.loginBtn.userInteractionEnabled = YES;
                self.loginView.loginBtn.backgroundColor = RGB(231, 35, 36, 1);
               
            }
        }
        
    }else if (textField.text.length > 11){
        [SVProgressHUD showInfoWithStatus:@"手机格式不正确"];
        self.loginView.codeBtn.backgroundColor = RGB(136, 136, 136, 1);
        self.loginView.codeBtn.userInteractionEnabled = NO;
        self.loginView.loginBtn.backgroundColor = RGB(136, 136, 136, 1);
        self.loginView.loginBtn.userInteractionEnabled = NO;
    }else{
        self.loginView.codeBtn.backgroundColor = RGB(136, 136, 136, 1);
        self.loginView.codeBtn.userInteractionEnabled = NO;
        self.loginView.loginBtn.backgroundColor = RGB(136, 136, 136, 1);
        self.loginView.loginBtn.userInteractionEnabled = NO;
    }
   
}

-(void)codeTextFieldTextFieldDidChange:(UITextField*)textField{
    DLog(@"c== %@" ,textField.text);
    if (textField.text.length > 6) {
        textField.text = [textField.text substringToIndex:6];
    }
    if (textField.text.length == 6) {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setValue:textField.text forKey:@"code"];
        
        self.loginView.loginBtn.userInteractionEnabled = YES;
        self.loginView.loginBtn.backgroundColor = RGB(231, 35, 36, 1);
        
    }else{
        self.loginView.loginBtn.backgroundColor = RGB(136, 136, 136, 1);
        self.loginView.loginBtn.userInteractionEnabled = NO;
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    
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
