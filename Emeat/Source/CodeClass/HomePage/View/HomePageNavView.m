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
        [self addSubview:self.scanBtn];
        [self addSubview:self.selectAddressBtn];
        [self addSubview:self.messageBtn];
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



-(UIButton*)scanBtn{
    if (!_scanBtn) {
        _scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _scanBtn.frame = CGRectMake(5*kScale, kStatusBarHeight, kTopBarHeight*kScale, kTopBarHeight);
        _scanBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f*kScale];
        [_scanBtn setImage:[UIImage imageNamed:@"saoma"] forState:0];
        [_scanBtn setTitle:@"  扫一扫" forState:0];
        [_scanBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:5];
        _scanBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f*kScale];
        [_scanBtn addTarget:self action:@selector(scanBtnAction) forControlEvents:1];
    }
    return _scanBtn;
}




-(UIButton*)selectAddressBtn{
    if (!_selectAddressBtn) {
        _selectAddressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectAddressBtn.frame = CGRectMake(MaxX(self.scanBtn)+5*kScale, kStatusBarHeight, kTopBarHeight, kTopBarHeight);
        _selectAddressBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f*kScale];
        [_selectAddressBtn setImage:[UIImage imageNamed:@"dingwei_white"] forState:0];
       [_selectAddressBtn setTitle:@"定位" forState:0];

        _selectAddressBtn.hidden = YES;
        [_selectAddressBtn addTarget:self action:@selector(selectAddressBtnAction) forControlEvents:1];

    }
    return _selectAddressBtn;
}

-(UIButton*)messageBtn{
    if (!_messageBtn) {
        _messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _messageBtn.frame = CGRectMake(kWidth-kTopBarHeight-5*kScale, kStatusBarHeight, kTopBarHeight, kTopBarHeight);
        _messageBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f*kScale];
        [_messageBtn setImage:[UIImage imageNamed:@"xiaoxi"] forState:0];
        [_messageBtn setTitle:@"  消息" forState:0];
        [_messageBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:5*kScale];
        _messageBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f*kScale];
        [_messageBtn addTarget:self action:@selector(sortBtnAction) forControlEvents:1];
    }
    return _messageBtn;
}


-(UIButton*)searchBtn{
    if (!_searchBtn) {
        _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _searchBtn.frame = CGRectMake(60*kScale,kStatusBarHeight+5, kWidth-110*kScale, 30*kScale);
        _searchBtn.backgroundColor = [UIColor whiteColor];
        [_searchBtn setImage:[UIImage imageNamed:@"sousuo"] forState:0];
        [_searchBtn setTitle:@"  请输入商品名称" forState:0];
        [_searchBtn setTitleColor:RGB(185, 185, 185, 1) forState:0];
        _searchBtn.titleLabel.font = [UIFont systemFontOfSize:12.0*kScale];
        _searchBtn.layer.cornerRadius = 15*kScale;
        _searchBtn.layer.masksToBounds = YES;
        _searchBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _searchBtn.imageEdgeInsets = UIEdgeInsetsMake(0, kWidth-140*kScale, 0, 0);
        [_searchBtn addTarget:self action:@selector(searchBtnAction) forControlEvents:1];
        
    }
    return _searchBtn;
}


#pragma mark = 消息

-(void)sortBtnAction{
    if ([self respondsToSelector:@selector(sortBlock)]) {
        self.sortBlock();
    }
    
}


-(void)scanBtnAction{
    
    [SVProgressHUD showErrorWithStatus:@"敬请期待"];
    
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
