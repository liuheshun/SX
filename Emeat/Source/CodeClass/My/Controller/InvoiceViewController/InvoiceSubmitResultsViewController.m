//
//  InvoiceSubmitResultsViewController.m
//  Emeat
//
//  Created by liuheshun on 2018/6/26.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "InvoiceSubmitResultsViewController.h"
#import "InvoiceSubmitResultsView.h"
#import "InvoiceHistoryViewController.h"
#import "InvoiceListViewController.h"
@interface InvoiceSubmitResultsViewController ()
@property (nonatomic,strong) InvoiceSubmitResultsView *invoiceSubmitResultsView;

@end

@implementation InvoiceSubmitResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navItem.title = @"开具发票";
    [self.view addSubview:self.invoiceSubmitResultsView];
    [self showNavBarLeftItem];
}

-(void)showNavBarLeftItem{
    NSArray *viewcontrollers=self.navigationController.viewControllers;
    if (viewcontrollers.count>1) {
        if ([viewcontrollers objectAtIndex:viewcontrollers.count-1]==self) {
            //push方式 判断页面是否存在push
            //创建一个左边按钮
            self.leftButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"fanhui"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]style:UIBarButtonItemStylePlain target:self action:@selector(leftItemAction)];
            [self.navBar pushNavigationItem:self.navItem animated:NO];
            [self.navItem setLeftBarButtonItem:self.leftButton];
            
        }
    }
    else{
        //present方式
    }
    
    
    
}

#pragma mark = 返回事件

-(void)leftItemAction{
    
    for (UIViewController *vc in self.navigationController.childViewControllers) {
        if ([vc isKindOfClass:[InvoiceListViewController class]]) {
            InvoiceListViewController *mainVC = (InvoiceListViewController *)vc;
            [self.navigationController popToViewController:mainVC animated:YES];
        }
    }
    

 

}




-(void)continueInvoiceBtnAction{
    DLog(@"继续开票")
    
    InvoiceListViewController *VC = [InvoiceListViewController new];
    [self.navigationController pushViewController:VC animated:YES];
}

-(void)historyInvoiceBtnAction{
   DLog(@"开票历史")
    InvoiceHistoryViewController *VC = [InvoiceHistoryViewController new];
    [self.navigationController pushViewController:VC animated:YES];
}

-(InvoiceSubmitResultsView *)invoiceSubmitResultsView{
    if (!_invoiceSubmitResultsView) {
        _invoiceSubmitResultsView = [[InvoiceSubmitResultsView alloc] initWithFrame:CGRectMake(0, kBarHeight, kWidth, kHeight-kBarHeight-LL_TabbarSafeBottomMargin)];
        [_invoiceSubmitResultsView.continueInvoiceBtn addTarget:self action:@selector(continueInvoiceBtnAction) forControlEvents:1];
        [_invoiceSubmitResultsView.historyInvoiceBtn addTarget:self action:@selector(historyInvoiceBtnAction) forControlEvents:1];

        
    }
    return _invoiceSubmitResultsView;
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
