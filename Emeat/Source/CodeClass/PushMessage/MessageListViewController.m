//
//  MessageListViewController.m
//  Emeat
//
//  Created by liuheshun on 2018/8/13.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "MessageListViewController.h"

@interface MessageListViewController ()

@end

@implementation MessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(238, 238, 238, 1);
    self.navItem.title = @"消息通知";
    // Do any additional setup after loading the view.
    
    
     [[GlobalHelper shareInstance] emptyViewNoticeText:@"暂无消息" NoticeImageString:@"未购买" viewWidth:50 viewHeight:54 UITableView:self.view isShowBottomBtn:NO bottomBtnTitle:@""];
    
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
