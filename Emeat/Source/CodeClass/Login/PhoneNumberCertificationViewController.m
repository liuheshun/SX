//
//  PhoneNumberCertificationViewController.m
//  Emeat
//
//  Created by liuheshun on 2018/7/13.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "PhoneNumberCertificationViewController.h"
#import "PhoneNumberCertificationView.h"
#import "UserAgreementViewController.h"
#import "ShopCertificationViewController.h"

@interface PhoneNumberCertificationViewController ()<UITextFieldDelegate>
@property (nonatomic,strong) PhoneNumberCertificationView *phoneView;
@property (nonatomic,assign) NSInteger  phoneNum;

@end

@implementation PhoneNumberCertificationViewController
{
    int timeoutCount;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(238, 238, 238, 1);
    self.navItem.title = @"手机号安全验证";
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
    //DLog(@"获取ticket== %@" ,dic);
    
    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/cas/mobile/getticket.html" ,baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        //DLog(@"ticker=== %@" ,returnData);
        if ([returnData[@"code"] isEqualToString:@"00"]) {
            NSString *ticket = returnData[@"ticket"];
            ///保存ticket
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:ticket forKey:@"ticket"];
           // [self requestCode:ticket];
        }
        
    } failureBlock:^(NSError *error) {
        
    } showHUD:NO];
    
}

#pragma mark = 获取验证码

-(void)requestCode{
    NSString *secret = @"UHnyKzP5sNmh2EV0Dflgl4VfzbaWc4crQ7JElfw1cuNCbcJUau";
    NSString *nonce = [self ret32bitString];//随机数
    NSString *curTime = [self dateTransformToTimeSp];
    NSString *checkSum = [self sha1:[NSString stringWithFormat:@"%@%@%@" ,secret ,  nonce ,curTime]];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *ticket = [user valueForKey:@"ticket"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:secret forKey:@"secret"];
    [dic setObject:nonce forKey:@"nonce"];
    [dic setObject:curTime forKey:@"curTime"];
    [dic setObject:checkSum forKey:@"checkSum"];
    [dic setObject:ticket forKey:@"ticket"];
    
    NSString * phoneNum = [user valueForKey:@"phoneNum"];
    [dic setObject:phoneNum forKey:@"phone"];
    [dic setValue:mTypeIOS forKey:@"mtype"];
    [dic setValue:[user valueForKey:@"appVersionNumber"] forKey:@"appVersionNumber"];
    [dic setValue:[user valueForKey:@"user"] forKey:@"user"];
    //DLog(@"获取验证码== %@" ,dic);
    
    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/cas/mobile/sendSmsByPhone" ,baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
       // DLog(@"code=== %@" ,returnData);
        
        
    } failureBlock:^(NSError *error) {
        
    } showHUD:NO];
    
}

#pragma mark======登陆事件

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
    [dic setValue:self.openid forKey:@"openId"];
    [dic setValue:self.nickname forKey:@"nickname"];
    [dic setValue:self.headPic forKey:@"headPic"];
    [dic setValue:mTypeIOS forKey:@"mtype"];
    [dic setValue:[user valueForKey:@"appVersionNumber"] forKey:@"appVersionNumber"];
    [dic setValue:[user valueForKey:@"user"] forKey:@"user"];
    //DLog(@"获取登陆tttt== === %@" ,dic);
    
    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/cas/mobile/doLogin" ,baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
       // DLog(@"denglu 登陆== === %@  "   , returnData);
        if ([returnData[@"code"] isEqualToString:@"00"]) {
            
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setValue:returnData[@"data"][@"id"]  forKey:@"userId"];
            
            [user setValue:@"1" forKey:@"isLoginState"];
            
            
            [user setValue:returnData[@"data"][@"headPic"] forKey:@"headPic"];
            [user setValue:returnData[@"data"][@"nickname"] forKey:@"nickname"];

            
            
            NSDictionary *data = returnData[@"data"];
            if ([data isKindOfClass:[NSDictionary class]] && [data objectForKey:@"store"]) {
                [user setValue:[NSString stringWithFormat:@"%@" ,returnData[@"data"][@"store"][@"isApprove"]] forKey:@"approve"];
                [GlobalHelper shareInstance].isPushLoginView = @"抽奖登陆";

                [self.navigationController popToRootViewControllerAnimated:YES];

            }else{//未认证
                [user setValue:@"0" forKey:@"approve"];

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
                self.phoneView.codeBtn.backgroundColor = RGB(231, 35, 36, 1);
                
                [self.phoneView.codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                self.phoneView.codeBtn.userInteractionEnabled = YES;
                
            });
        }else{
            //          int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                self.phoneView.codeBtn.backgroundColor = RGB(136, 136, 136, 1);
                [self.phoneView.codeBtn setTitle:[NSString stringWithFormat:@"%@s",strTime] forState:UIControlStateNormal];
                self.phoneView.codeBtn.userInteractionEnabled = NO;
                
            });
            timeout--;
            timeoutCount = timeout;
            
        }
    });
    dispatch_resume(_timer);
}
#pragma mark = 发送验证码

-(void)sendCodeMessage{
//    [self requestTicket];
    [self requestCode];
    [self yourButtonTitleTime];
    
}



#pragma mark = 登陆

-(void)loginBtnActions{
    [self requestLogin];
}



-(void)setLoginViewFrame{
    self.phoneView = [[PhoneNumberCertificationView alloc] initWithFrame:CGRectMake(0, kBarHeight, kWidth, kHeight-kBarHeight-LL_TabbarSafeBottomMargin)];
    self.phoneView.backgroundColor = RGB(238, 238, 238, 1);
    self.phoneView.phoneNumTextField.delegate = self;
    self.phoneView.codeTextField.delegate = self;
    [self.view addSubview:self.phoneView];
    [self.phoneView.phoneNumTextField addTarget:self action:@selector(phoneNumTextFieldTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.phoneView.codeTextField addTarget:self action:@selector(codeTextFieldTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.phoneView.codeBtn addTarget:self action:@selector(sendCodeMessage) forControlEvents:1];
    [self.phoneView.loginBtn addTarget:self action:@selector(loginBtnActions) forControlEvents:1];
    
    
    
    [self.phoneView.agreementBtn addTarget:self action:@selector(agreementBtnAction) forControlEvents:1];
    
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
    
    
    if (textField.text.length == 11)
    {
        if (![self checkTel:textField.text] )
        {
            [SVProgressHUD showInfoWithStatus:@"手机格式不正确"];
        }
        else
        {
            if (timeoutCount >0) {
                self.phoneView.codeBtn.backgroundColor = RGB(136, 136, 136, 1);
                self.phoneView.codeBtn.userInteractionEnabled = NO;
                
            }else{
                self.phoneView.codeBtn.backgroundColor = RGB(231, 35, 36, 1);
                self.phoneView.codeBtn.userInteractionEnabled = YES;
            }
            
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setValue:textField.text forKey:@"phoneNum"];
            
            self.phoneNum = [textField.text integerValue];
            
            if (self.phoneView.codeTextField.text.length!=0)
            {
                self.phoneView.loginBtn.userInteractionEnabled = YES;
                self.phoneView.loginBtn.backgroundColor = RGB(231, 35, 36, 1);
                
            }
        }
        
    }else if (textField.text.length > 11){
        [SVProgressHUD showInfoWithStatus:@"手机格式不正确"];
        self.phoneView.codeBtn.backgroundColor = RGB(136, 136, 136, 1);
        self.phoneView.codeBtn.userInteractionEnabled = NO;
        self.phoneView.loginBtn.backgroundColor = RGB(136, 136, 136, 1);
        self.phoneView.loginBtn.userInteractionEnabled = NO;
    }else{
        self.phoneView.codeBtn.backgroundColor = RGB(136, 136, 136, 1);
        self.phoneView.codeBtn.userInteractionEnabled = NO;
        self.phoneView.loginBtn.backgroundColor = RGB(136, 136, 136, 1);
        self.phoneView.loginBtn.userInteractionEnabled = NO;
    }
    
}

-(void)codeTextFieldTextFieldDidChange:(UITextField*)textField{
    if (textField.text.length > 6) {
        textField.text = [textField.text substringToIndex:6];
    }
    if (textField.text.length == 6) {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setValue:textField.text forKey:@"code"];
        
        self.phoneView.loginBtn.userInteractionEnabled = YES;
        self.phoneView.loginBtn.backgroundColor = RGB(231, 35, 36, 1);
        
    }else{
        self.phoneView.loginBtn.backgroundColor = RGB(136, 136, 136, 1);
        self.phoneView.loginBtn.userInteractionEnabled = NO;
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
