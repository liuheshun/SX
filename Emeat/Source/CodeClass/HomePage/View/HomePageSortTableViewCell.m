//
//  HomePageSortTableViewCell.m
//  Emeat
//
//  Created by liuheshun on 2018/8/2.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "HomePageSortTableViewCell.h"
#import "HomePageSortListTableViewCell.h"
@implementation HomePageSortTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        [self addSubview:self.leftTableView];
//        [self addSubview:self.rightTableView];
//        self.leftTableView.bounces = NO;
//        self.rightTableView.bounces = NO;
//       
        
    }
    return self;
}




-(UITableView *)leftTableView{
    if (_leftTableView == nil) {
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 86, kHeight-kBottomBarHeight-kStatusBarHeight) style:UITableViewStyleGrouped];
        _leftTableView.dataSource = self;
        _leftTableView.delegate = self;
        _leftTableView.backgroundColor = [UIColor whiteColor];
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    }
    return _leftTableView;
}


-(UITableView *)rightTableView{
    if (_rightTableView == nil) {
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(86, 0, kWidth-86, kHeight-kBottomBarHeight-kStatusBarHeight) style:UITableViewStyleGrouped];
        _rightTableView.dataSource = self;
        _rightTableView.delegate = self;
        _rightTableView.backgroundColor = [UIColor yellowColor];
        _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    }
    return _rightTableView;
}





-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.leftTableView) {
        return 1;

    }
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.leftTableView) {
        return 10;
        
    }else{
        return 20;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.leftTableView) {
        return 41;
    }
    return 100*kScale;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
    if (tableView == self.leftTableView) {
        return 0.0001*kScale;
    }
    return 41*kScale;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == self.leftTableView) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 85*kScale, 0.001*kScale)];
        view.backgroundColor = [UIColor whiteColor];
        return view;
    }else{
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(85*kScale, 0, kWidth-85*kScale, 15*kScale)];
        view.backgroundColor = [UIColor whiteColor];
        for (int i = 0; i <4;i++ ) {
            UIButton *levelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            levelBtn.frame = CGRectMake(10*kScale+55*i*kScale+10*kScale*i, 10*kScale, 55*kScale, 25*kScale);
            levelBtn.layer.cornerRadius = 5;
            levelBtn.layer.masksToBounds = YES;
            levelBtn.backgroundColor = RGB(238, 238, 238, 1);
            [levelBtn setTitle:@"分类" forState:0];
            levelBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f*kScale];
            if (i== 0) {
                levelBtn.backgroundColor = RGB(231, 35, 36, 1);
            }
            if (i == 3) {
                levelBtn.frame = CGRectMake(10*kScale+55*i*kScale+10*kScale*i, 10*kScale, 77*kScale, 25*kScale);
            }
            levelBtn.tag = i+100;
            [view addSubview:levelBtn];
            [levelBtn addTarget:self action:@selector(levelBtnClickAction:) forControlEvents:1];
        }
        
        return view;
        
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView == self.leftTableView) {
        return 0.001*kScale;
    }
    return 40*kScale;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (tableView == self.leftTableView) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 0.001*kScale)];
        view.backgroundColor = RGB(238, 238, 238, 1);
        return view;
        
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 15*kScale)];
    view.backgroundColor = [UIColor whiteColor];
    
    return view;
}





-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.leftTableView) {
        UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"list_cell"];
        if (cell1 == nil) {
            cell1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"list_cell"];
            
            cell1.backgroundColor = RGB(238, 238, 238, 1);
            
        }
        cell1.textLabel.text = self.leftTileMarray[indexPath.row];
        
        //默认选中第一行
        cell1.selectedBackgroundView = [[UIView alloc]initWithFrame:cell1.bounds];
        cell1.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
        [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]animated:YES scrollPosition:UITableViewScrollPositionTop];
        if ([self.leftTableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
        {
            [self.leftTableView.delegate tableView:self.leftTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        }
        

        return cell1;
    }
    
    HomePageSortListTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"HomePageSortListTableViewCell"];
    if (cell1 == nil) {
        cell1 = [[HomePageSortListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HomePageSortListTableViewCell"];
        
        //[cell1 setSelectionStyle:UITableViewCellSelectionStyleNone]; //取消选中的阴影效果
        cell1.backgroundColor = [UIColor whiteColor];
        
    }
    
    return cell1;
}

#pragma mark  = 点击事件


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.leftTableView) {
        
    }
    
}



-(void)levelBtnClickAction:(UIButton*)btn{
    
    for (int i =0; i<4; i++) {
        if (btn.tag == i+100) {
            [btn setBackgroundColor:RGB(231, 35, 36, 1)];
            continue;
        }
        UIButton *btn1  = (UIButton*)[self viewWithTag:i+100];
        [btn1 setBackgroundColor:RGB(238, 238, 238, 1)];
        
    }
    
}








- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
