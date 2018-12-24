//
//  SettingViewController.m
//  Emeat
//
//  Created by liuheshun on 2017/12/14.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import "SettingViewController.h"
#import "AboutUsViewController.h"
#import "SuggestionFeedbackViewController.h"
@interface SettingViewController ()<UIActionSheetDelegate>
@property (nonatomic,strong) UIButton *btn;
@property (nonatomic,strong) UIButton *exitBtn;

@property (nonatomic,assign) BOOL isCanSwitchServer;


@end

@implementation SettingViewController
-(void)viewWillAppear:(BOOL)animated{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if ([user valueForKey:@"isLoginState"]) {
        [GlobalHelper shareInstance].isLoginState = [user valueForKey:@"isLoginState"];
    }
    if ([[GlobalHelper shareInstance].isLoginState isEqualToString:@"0"])
    {
        [self.exitBtn setTitle:@"登录" forState:0];
    }
    else
    {
        [self.exitBtn setTitle:@"退出当前登录" forState:0];

    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(238, 238, 238, 1);
    self.navItem.title = @"设置";
    


    ///只有在debug模式下才会出现切换环境
    
#ifdef DEBUG
    //do sth.
    self.isCanSwitchServer = YES;
#else
    //do sth.
    self.isCanSwitchServer = NO;

#endif
   
    [self setUI];
    
}


-(void)btnAction:(UIButton*)sender{
    
    switch (sender.tag) {
        case 0:
        {
            AboutUsViewController *VC = [AboutUsViewController new];
            [self.navigationController pushViewController:VC animated:YES];
           
            break;
        }
        case 1:
        {
            if ([[GlobalHelper shareInstance].isLoginState isEqualToString:@"1"]) {
                
                SuggestionFeedbackViewController *VC = [SuggestionFeedbackViewController new];
                [self.navigationController pushViewController:VC animated:YES];
           
                break;
                
            }else{
                LoginViewController *VC = [LoginViewController new];
                VC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:VC animated:YES];
                
            }
           
        }
        case 2:
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@" ,appStoreURL]]];
           
            break;
        }
        case 3:
        {
            NSString *string;
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
           
            
            if ([[NSString stringWithFormat:@"%@" ,[user valueForKey:@"server"]] containsString:@"admin"]) {
               
                string  = [NSString stringWithFormat:@"切换环境 当前环境(admin)"];
            }else if ([[NSString stringWithFormat:@"%@" ,[user valueForKey:@"server"]] containsString:@"test"]){
                string  = [NSString stringWithFormat:@"切换环境 当前环境(test)"];

            }else if ([[NSString stringWithFormat:@"%@" ,[user valueForKey:@"server"]] containsString:@"192.168.0.141"]){
                string  = [NSString stringWithFormat:@"切换环境 当前环境(徐立)"];
                
            }
            else{
                string  = [NSString stringWithFormat:@"切换环境 当前环境(beta)"];
            }
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:string delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"admin线上环境", @"beta测试环境",@"test测试 ",@"徐立测试", nil];
            
            //actionSheet风格，感觉也没什么差别- -
            actionSheet.actionSheetStyle = UIActionSheetStyleDefault;//默认风格，灰色背景，白色文字
            [actionSheet showInView:self.view];

            
            break;
        }
        default:
            break;
    }
    
    
}

#pragma mark - UIActionSheetDelegate
//根据被点击的按钮做出反应，0对应destructiveButton，之后的button依次排序
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSLog(@"线上环境");
        [[NSUserDefaults standardUserDefaults] setObject:@"http://admin.cyberfresh.cn" forKey:@"server"];

    }
    else if (buttonIndex == 1) {
        NSLog(@"beta环境");
        [[NSUserDefaults standardUserDefaults] setObject:@"http://beta.cyberfresh.cn" forKey:@"server"];
// [[NSUserDefaults standardUserDefaults] setObject:@"http://192.168.0.141" forKey:@"server"];
    }else if (buttonIndex == 2){
        [[NSUserDefaults standardUserDefaults] setObject:@"http://test.cyberfresh.cn" forKey:@"server"];

        DLog(@"test测试环境")
    }else if (buttonIndex == 3){
        [[NSUserDefaults standardUserDefaults] setObject:@"http://192.168.0.141" forKey:@"server"];
        
        DLog(@"test测试环境")
    }
}

-(void)exitBtnAction{
    

    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if ([user valueForKey:@"isLoginState"]) {
        [GlobalHelper shareInstance].isLoginState = [user valueForKey:@"isLoginState"];
    }
    
    if ([[GlobalHelper shareInstance].isLoginState isEqualToString:@"0"]) {
        LoginViewController *VC = [LoginViewController new];
        [self.navigationController pushViewController:VC animated:YES];
    }
    else if ([[GlobalHelper shareInstance].isLoginState isEqualToString:@"1"])
    {
        
        NSUserDefaults *defatluts = [NSUserDefaults standardUserDefaults];
        
        NSDictionary *dictionary = [defatluts dictionaryRepresentation];
        
        for(NSString *key in [dictionary allKeys]){

            if ([key isEqualToString:@"appVersion"]) {
                ///此处退出登录不清除记录引导页状态
            }else if ([key isEqualToString: @"appVersionNumber"]){
                
            }
            else if ([key isEqualToString:@"server"]){
                
            }else{
            
                [defatluts removeObjectForKey:key];
            
            [defatluts synchronize];
            }
        }
        

//        
//        [user setValue:@"0" forKey:@"isLoginState"];
//       [user setValue:@"退出登录ticket" forKey:@"ticket"];
//        [user setValue:@"" forKey:@"user"];

        
        ///购物车BadgeValue置为0
        [GlobalHelper shareInstance].shoppingCartBadgeValue = 0;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"shoppingCart" object:nil userInfo:nil];
        
        [self.navigationController popViewControllerAnimated:YES];
        
        
    }
    
  
}






-(void)setUI{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
   
    NSString *currentAppVersion = infoDic[@"CFBundleShortVersionString"];
    currentAppVersion = [NSString stringWithFormat:@"版本更新 (当前版本V%@)" ,currentAppVersion];
    NSArray *textArray = [NSArray array];
    if (self.isCanSwitchServer == YES) {
        
        textArray = @[@"关于我们" ,@"意见反馈" ,currentAppVersion,@"切换环境"];
    }else{
        textArray = @[@"关于我们" ,@"意见反馈" ,currentAppVersion];

    }

    for (int i = 0; i < textArray.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:btn];
        [btn setTitle:textArray[i] forState:0];
        btn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [btn setTitleColor:[UIColor blackColor] forState:0];
        btn.backgroundColor = [UIColor whiteColor];
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        btn.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentLeft;
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, kWidth-15, 0, 0);
        [btn setImage:[UIImage imageNamed:@"进入"] forState:0];
        btn.tag = i;
        self.btn = btn;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:1];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.height.equalTo(@33);
            make.top.equalTo(self.view.mas_top).with.offset(kBarHeight+15+48*i);
        }];
        
    }
    
    self.exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.exitBtn];
    self.exitBtn.layer.cornerRadius = 5;
    self.exitBtn.layer.masksToBounds = YES;
    self.exitBtn.backgroundColor = RGB(231, 35, 36, 1);
    [self.exitBtn addTarget:self action:@selector(exitBtnAction) forControlEvents:1];
    [self.exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(15);
        make.right.equalTo(self.view.mas_right).with.offset(-15);
        make.height.equalTo(@40);
        make.top.equalTo(self.btn.mas_bottom).with.offset(30);
    }];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if ([user valueForKey:@"isLoginState"]) {
        [GlobalHelper shareInstance].isLoginState = [user valueForKey:@"isLoginState"];
    }
    
    if ([[GlobalHelper shareInstance].isLoginState isEqualToString:@"0"]) {
        [self.exitBtn setTitle:@"登录" forState:0];

    }
    else if ([[GlobalHelper shareInstance].isLoginState isEqualToString:@"1"])
    {
        [self.exitBtn setTitle:@"退出当前登录" forState:0];


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
