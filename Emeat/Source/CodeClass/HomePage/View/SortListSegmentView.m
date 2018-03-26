//
//  SortListSegmentView.m
//  Emeat
//
//  Created by liuheshun on 2017/11/29.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import "SortListSegmentView.h"
static NSInteger countSelectStated = 0;
static NSInteger priceSelectStated = 0;

@implementation SortListSegmentView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.countBtn];
        [self addSubview:self.priceBtn];
        [self addSubview:self.checkBtn];
        [self addclickAction];
//        countSelectStated = NO;
//        priceSelectStated = NO;
    }
    return self;
}

-(void)countBtnAction{
    if ([self respondsToSelector:@selector(countStatedBlock)]) {
        priceSelectStated = 0;
        [_priceBtn setImage:[UIImage imageNamed:@"huise"] forState:0];
        
        if (countSelectStated == 0) {
            [_countBtn setImage:[UIImage imageNamed:@"shengxu"] forState:0];
            countSelectStated = 1;
        }else{
            [_countBtn setImage:[UIImage imageNamed:@"jiangxu"] forState:0];
            countSelectStated = 0;
        }
        
        self.countStatedBlock(countSelectStated);

    }
   
}
-(void)priceBtnAction{
    if ([self respondsToSelector:@selector(priceStatedBlock)]) {
        countSelectStated = 0;
        [_countBtn setImage:[UIImage imageNamed:@"huise"] forState:0];
        
        if (priceSelectStated == 0) {
            [_priceBtn setImage:[UIImage imageNamed:@"shengxu"] forState:0];
            priceSelectStated = 1;
        }else{
            [_priceBtn setImage:[UIImage imageNamed:@"jiangxu"] forState:0];
            priceSelectStated = 0;
        }
        self.priceStatedBlock(priceSelectStated);

    }
   
}

-(void)checkBtnAction{
    if ([self respondsToSelector:@selector(checkStatedBlock)]) {
        self.checkStatedBlock(0);
    }
}

-(void)addclickAction{
    
    [self.countBtn addTarget:self action:@selector(countBtnAction) forControlEvents:1];
    [self.priceBtn addTarget:self action:@selector(priceBtnAction) forControlEvents:1];
    [self.checkBtn addTarget:self action:@selector(checkBtnAction) forControlEvents:1];
}



-(UIButton*)countBtn{
    if (!_countBtn) {
        _countBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _countBtn.frame = CGRectMake(0, 0, kWidth/3, HEIGHT(self));
        [_countBtn setTitle:@"销量" forState:0];
        [_countBtn setTitleColor:RGB(138, 138, 138, 1) forState:0];
        _countBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [_countBtn setImage:[UIImage imageNamed:@"jiangxu"] forState:0];
        [_countBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5*kScale];

    }
    return _countBtn;
}

-(UIButton*)priceBtn{
    if (!_priceBtn) {
        _priceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _priceBtn.frame = CGRectMake(MaxX(self.countBtn), 0, kWidth/3, HEIGHT(self));
        [_priceBtn setTitle:@"价格" forState:0];
        [_priceBtn setTitleColor:RGB(138, 138, 138, 1) forState:0];
        _priceBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [_priceBtn setImage:[UIImage imageNamed:@"huise"] forState:0];
        [_priceBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5*kScale];


    }
    return _priceBtn;
}



-(UIButton*)checkBtn{
    if (!_checkBtn) {
        _checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _checkBtn.frame = CGRectMake(MaxX(self.priceBtn), 0, kWidth/3, HEIGHT(self));
        [_checkBtn setTitle:@"筛选" forState:0];
        [_checkBtn setImage:[UIImage imageNamed:@"shaixuan"] forState:0];
        [_checkBtn setTitleColor:RGB(138, 138, 138, 1) forState:0];
        _checkBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [_checkBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5*kScale];

    }
    return _checkBtn;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
