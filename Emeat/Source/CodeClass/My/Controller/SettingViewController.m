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
@interface SettingViewController ()
@property (nonatomic,strong) UIButton *btn;
@property (nonatomic,strong) UIButton *exitBtn;

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
    [self setUI];
    // Do any additional setup after loading the view.
}


-(void)btnAction:(UIButton*)sender{
    
    switch (sender.tag) {
        case 0:
        {
            AboutUsViewController *VC = [AboutUsViewController new];
            [self.navigationController pushViewController:VC animated:YES];
            DLog(@"关于我们");
            break;
        }
        case 1:
        {
            if ([[GlobalHelper shareInstance].isLoginState isEqualToString:@"1"]) {
                
                SuggestionFeedbackViewController *VC = [SuggestionFeedbackViewController new];
                [self.navigationController pushViewController:VC animated:YES];
                DLog(@"意见反馈");
                break;
                
            }else{
                LoginViewController *VC = [LoginViewController new];
                VC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:VC animated:YES];
                
            }
           
        }
        default:
            break;
    }
    
    
}


-(void)exitBtnAction{
    
    DLog(@"退出登录");
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
        
        [user setValue:@"0" forKey:@"isLoginState"];
       // [user setValue:@"退出登录ticket" forKey:@"ticket"];
        ///购物车BadgeValue置为0
        [GlobalHelper shareInstance].shoppingCartBadgeValue = 0;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"shoppingCart" object:nil userInfo:nil];
        
        [self.navigationController popViewControllerAnimated:YES];
        
        
    }
    
  
}






-(void)setUI{
    NSArray *textArray = @[@"关于我们" ,@"意见反馈"];
    for (int i = 0; i < 2; i ++) {
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
