//
//  HomePageNavView.m
//  Emeat
//
//  Created by liuheshun on 2017/11/23.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import "HomePageNavView.h"
#import "HomePageNavSortTableViewCell.h"

@implementation HomePageNavView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.selectAddressBtn];
        [self addSubview:self.sortBtn];
        [self addSubview:self.searchBtn];
    }
    return self;
}


-(void)searchBtnAction{
    if ([self respondsToSelector:@selector(searchBtnBlock)]) {
        self.searchBtnBlock();
    }
}

-(void)selectAddressBtnAction{
    if ([self respondsToSelector:@selector(selectAddressBtnBlock)]) {
        self.selectAddressBtnBlock();
    }
}


-(UIButton*)selectAddressBtn{
    if (!_selectAddressBtn) {
        _selectAddressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectAddressBtn.frame = CGRectMake((kWidth-150*kScale)/2, kStatusBarHeight, 150*kScale, kTopBarHeight);
        _selectAddressBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f*kScale];
        [_selectAddressBtn setImage:[UIImage imageNamed:@"jiantou"] forState:0];
        _selectAddressBtn.titleLabel.lineBreakMode =  NSLineBreakByTruncatingTail;
        _selectAddressBtn.backgroundColor = RGB(236, 31, 35, 1);
//        [_selectAddressBtn setTitle:@"浙江中小企业大厦608" forState:0];
        
        [_selectAddressBtn addTarget:self action:@selector(selectAddressBtnAction) forControlEvents:1];

    }
    return _selectAddressBtn;
}

-(UIButton*)sortBtn{
    if (!_sortBtn) {
        _sortBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sortBtn.frame = CGRectMake(kWidth-kTopBarHeight, kStatusBarHeight, kTopBarHeight, kTopBarHeight);
        _sortBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f*kScale];
        [_sortBtn setImage:[UIImage imageNamed:@"fenlei"] forState:0];
        [_sortBtn addTarget:self action:@selector(sortBtnAction) forControlEvents:1];
    }
    return _sortBtn;
}


-(UIButton*)searchBtn{
    if (!_searchBtn) {
        _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _searchBtn.frame = CGRectMake(30*kScale, MaxY(self.selectAddressBtn), kWidth-60*kScale, 30*kScale);
        _searchBtn.backgroundColor = [UIColor whiteColor];
        [_searchBtn setImage:[UIImage imageNamed:@"sousuo"] forState:0];
        [_searchBtn setTitle:@"请输入商品名称" forState:0];
        [_searchBtn setTitleColor:RGB(185, 185, 185, 1) forState:0];
        _searchBtn.titleLabel.font = [UIFont systemFontOfSize:12.0*kScale];
        _searchBtn.layer.cornerRadius = 15*kScale;
        _searchBtn.layer.masksToBounds = YES;
        [_searchBtn addTarget:self action:@selector(searchBtnAction) forControlEvents:1];
        
    }
    return _searchBtn;
}


#pragma mark = 分类

-(void)sortBtnAction{
    if ([self respondsToSelector:@selector(sortBlock)]) {
        self.sortBlock();
    }
    
//    [self.window addSubview:self.shadeBtn];
//    [self.window addSubview:self.tableView];
}


-(void)shadeBtnAction{
    
    [UIView animateWithDuration:1.0 animations:^{
        [self.shadeBtn removeFromSuperview];
        [self.tableView removeFromSuperview];
    }];
   
}

-(UIButton*)shadeBtn{
    if (!_shadeBtn) {
        _shadeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _shadeBtn.frame = CGRectMake(0, 0, kWidth-125*kScale, kHeight-LL_TabbarSafeBottomMargin);
        _shadeBtn.backgroundColor = RGB(0, 0, 0, 0.5);
        [_shadeBtn setImage:[UIImage imageNamed:@"牛"] forState:0];
        _shadeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10*kScale, 0, 10*kScale);
        [_shadeBtn addTarget:self action:@selector(shadeBtnAction) forControlEvents:1];
    }
    return _shadeBtn;
}


-(UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(kWidth-125*kScale, kStatusBarHeight, 125*kScale, kHeight-kStatusBarHeight-LL_TabbarSafeBottomMargin) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.HomeArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 115*kScale;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 50*kScale;
    }
    return 0.01;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UILabel *sortTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.tableView), 50*kScale)];
        sortTitleLab.text = @"分类";
        sortTitleLab.textAlignment = NSTextAlignmentCenter;
        sortTitleLab.textColor = [UIColor whiteColor];
        sortTitleLab.font = [UIFont systemFontOfSize:15.0f];
        sortTitleLab.backgroundColor = RGB(236, 31, 35, 1);
        return sortTitleLab;
        
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 0.01)];
    view.backgroundColor = [UIColor whiteColor];
    return view;

}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 1)];
    view.backgroundColor = [UIColor whiteColor];
    UIView*lineView = [[UIView alloc] initWithFrame:CGRectMake(12.5*kScale, 0, 100*kScale, 1)];
    lineView.backgroundColor = RGB(236, 31, 35, 1 );
    [view addSubview:lineView];
    
    return view;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HomePageNavSortTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"sort_cell"];
    if (cell1 == nil) {
        cell1 = [[HomePageNavSortTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sort_cell"];
        
        [cell1 setSelectionStyle:UITableViewCellSelectionStyleNone]; //取消选中的阴影效果
        cell1.backgroundColor = [UIColor whiteColor];
        
    }
    if (self.HomeArray.count!=0) {
        [cell1 configCell:self.HomeArray[indexPath.section]];

    }
    return cell1;
}

#pragma mark  = 点击事件


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //隐藏tabBar
    if ([self respondsToSelector:@selector(selectSortIndexBlock)]) {
        
        self.selectSortIndexBlock(indexPath.section);
    }

}

//接收数据
-(void)getHomeArray:(NSArray *)homeArray
{
    self.HomeArray = homeArray;
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
