//
//  CancelOredrReasonView.m
//  Emeat
//
//  Created by liuheshun on 2018/11/14.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "CancelOredrReasonView.h"
#import "CancelOrderReasonTableViewCell.h"

@implementation CancelOredrReasonView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.tableView];
        self.isShow = 0;
//        self.reasonMarrayIndex = [NSMutableArray array];
//        self.dataMarray = [NSMutableArray array];
//        for (int i = 0; i<5; i++) {
//            ShoppingCartModel *model = [ShoppingCartModel new];
//            model.productChecked = 0;
//            [self.dataMarray addObject:model];
//        }
    }
    return self;
}




-(UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(15*kScale, 150*kScale, kWidth-30*kScale, 270*kScale) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.backgroundColor = [UIColor whiteColor];
        self.tableView.showsVerticalScrollIndicator = NO;

        self.tableView.bounces = NO;
        self.tableView.layer.cornerRadius = 5;
        self.tableView.layer.masksToBounds = YES;
    }
    return _tableView;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30*kScale;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
    return 50*kScale;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 50*kScale)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel*lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.tableView), 50*kScale)];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:15*kScale];
    lab.textColor = RGB(51, 51, 51, 1);
    lab.text = @"选择取消原因";
    [view addSubview:lab];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (self.isShow == 0) {
        return 70*kScale;
    }else if (self.isShow == 1){
        return 70*kScale+98*kScale;
    }
    
    return 70*kScale;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 50*kScale)];
    view.backgroundColor = [UIColor whiteColor];
    CGFloat CHeight= 0;
    if (self.isShow == 0) {
        CHeight= 70*kScale;
    }else if (self.isShow == 1){
        CHeight=  70*kScale+98*kScale;
    }
    self.cancelOrderBottomView = [[CancelOrderReasonBottomView alloc] initWithFrame:CGRectMake(0*kScale, 0, kWidth-30*kScale, CHeight)];
    self.cancelOrderBottomView.backgroundColor = [UIColor whiteColor];
    
    [self.cancelOrderBottomView isShowOtherReason:self.isShow];
    
    [view addSubview:self.cancelOrderBottomView];
    [self.cancelOrderBottomView.cancelBtn addTarget:self action:@selector(cancelHide) forControlEvents:1];
    [self.cancelOrderBottomView.confirmBtn addTarget:self action:@selector(confirmBtnAction) forControlEvents:1];

    
    return view;
}

-(void)cancelHide{
    DLog(@"---e%@" ,@"yinc");
    [self removeFromSuperview];
    
}
-(void)confirmBtnAction{
    DLog(@"---e%@" ,@"确认");
    
    if ([self respondsToSelector:@selector(confirmBtnActions)]) {
       

        self.otherReasonString = self.otherReasonString = self.cancelOrderBottomView.textView.text;
        
        self.confirmBtnActions(self.reasonMarrayIndex, self.otherReasonString);
    }
    
}

-(void)hideAllView{
     [self removeFromSuperview];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CancelOrderReasonTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"CancelOrderReasonTableViewCell"];
    if (cell1 == nil) {
        cell1 = [[CancelOrderReasonTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"list_cell"];
        
        [cell1 setSelectionStyle:UITableViewCellSelectionStyleNone]; //取消选中的阴影效果
        cell1.backgroundColor = [UIColor whiteColor];
        
    }
    cell1.payTypeBtn.userInteractionEnabled = NO;
    cell1.roundPayBtn.userInteractionEnabled = NO;
    self.titleMarray = [NSMutableArray arrayWithObjects:@"信息填错了,重新下单" ,@"商家缺货" ,@"不想要了" ,@"测试商品" ,@"其它原因", nil];
    [cell1.payTypeBtn setTitle:self.titleMarray[indexPath.row] forState:0];
    
    if (_selIndex == indexPath) {
        [cell1.roundPayBtn setImage:[UIImage imageNamed:@"selected"] forState:0];
    }else {
        [cell1.roundPayBtn setImage:[UIImage imageNamed:@"no_selected"] forState:0];
    }
    
    
    
    return cell1;
}

#pragma mark  = 点击事件


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //隐藏tabBar
    
    //之前选中的，取消选择
    CancelOrderReasonTableViewCell *celled = [tableView cellForRowAtIndexPath:_selIndex];
    [celled.roundPayBtn setImage:[UIImage imageNamed:@"no_selected"] forState:0];
    //记录当前选中的位置索引
    _selIndex = indexPath;
    //当前选择的打勾
    CancelOrderReasonTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell.roundPayBtn setImage:[UIImage imageNamed:@"selected"] forState:0];
    
//    [self.reasonMarrayIndex removeObject:[NSString stringWithFormat:@"%ld" ,indexPath.row]];
//    [self.reasonMarrayIndex addObject:[NSString stringWithFormat:@"%ld" ,indexPath.row]];
    switch (indexPath.row) {
        case 0:
            self.reasonMarrayIndex = @"REORDER";
            break;
        case 1:
            self.reasonMarrayIndex = @"SIMPLE_SERVICE";
            break;
        case 2:
            self.reasonMarrayIndex = @"LET_IT_GO";
            break;
        case 3:
            self.reasonMarrayIndex = @"TEST_COMMODITY";
            break;
        case 4:
            self.reasonMarrayIndex = @"OTHER";
            break;
        default:
            break;
    }
    if (indexPath.row == 4 ) {
        [UIView animateWithDuration:0.2 animations:^{
            self.isShow = 1;
            CGRect tableRect = self.tableView.frame;
            tableRect.size.height = 270*kScale + 98*kScale;
            self.tableView.frame = tableRect;
        }];

    }else {
        [UIView animateWithDuration:0.2 animations:^{
            self.isShow = 0;
            CGRect tableRect = self.tableView.frame;
            tableRect.size.height = 270*kScale ;
            self.tableView.frame = tableRect;
            self.otherReasonString = @" ";
            
        }];
    }

   [self.tableView reloadData];

}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
