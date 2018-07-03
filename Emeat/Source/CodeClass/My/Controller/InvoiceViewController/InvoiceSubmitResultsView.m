//
//  InvoiceSubmitResultsView.m
//  Emeat
//
//  Created by liuheshun on 2018/6/26.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "InvoiceSubmitResultsView.h"

@implementation InvoiceSubmitResultsView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame: frame];
    if (self) {
        [self addSubview:self.successBtn];
        [self addSubview:self.tipsLab];
        [self addSubview:self.continueInvoiceBtn];
        [self addSubview:self.historyInvoiceBtn];
        [self setFrame];
    }
    return self;
}


-(void)setFrame{
    
    [self.successBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(85*kScale);
        make.height.equalTo(@(80*kScale));
        make.width.equalTo(@(80*kScale));
        make.left.equalTo(self.mas_left).with.offset((kWidth-80*kScale)/2);
    }];
    
    
    [self.tipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.successBtn.mas_bottom).with.offset(10*kScale);
        make.height.equalTo(@(15*kScale));
        make.left.right.equalTo(self);
    }];
    [self.continueInvoiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipsLab.mas_bottom).with.offset(25*kScale);
        make.height.equalTo(@(40*kScale));
        make.width.equalTo(@(145*kScale));
        make.left.equalTo(self.mas_left).with.offset((kWidth-145*kScale)/2);
    }];
    
    [self.historyInvoiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.continueInvoiceBtn.mas_bottom).with.offset(15*kScale);
        make.height.equalTo(@(40*kScale));
        make.width.equalTo(@(145*kScale));
        make.left.equalTo(self.mas_left).with.offset((kWidth-145*kScale)/2);
    }];
    
    [_successBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:20*kScale];

}


-(UIButton *)successBtn{
    if (!_successBtn) {
        _successBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_successBtn setTitle:@"提交成功" forState:0];
        [_successBtn setTitleColor:[UIColor blackColor] forState:0];

        _successBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f*kScale];
        [_successBtn setImage:[UIImage imageNamed:@"success"] forState:0];

    }
    return _successBtn;
}


-(UILabel *)tipsLab{
    if (!_tipsLab) {
        _tipsLab = [[UILabel alloc] init];
        _tipsLab.font = [UIFont systemFontOfSize:12.0f*kScale];
        _tipsLab.textColor = RGB(136, 136, 136, 1);
        _tipsLab.textAlignment = NSTextAlignmentCenter;
        _tipsLab.text = @"请等待工作人员与您确认相关信息";
        
    }
    return _tipsLab;
}

-(UIButton *)continueInvoiceBtn{
    if (!_continueInvoiceBtn) {
        _continueInvoiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _continueInvoiceBtn.backgroundColor = RGB(236, 31, 35, 1);
        [_continueInvoiceBtn setTitle:@"继续开票" forState:0];
        [_continueInvoiceBtn setTitleColor:[UIColor whiteColor] forState:0];
        _continueInvoiceBtn.layer.cornerRadius = 5;
        _continueInvoiceBtn.layer.masksToBounds = YES;
        _continueInvoiceBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f*kScale];

    }
    return _continueInvoiceBtn;
}



-(UIButton *)historyInvoiceBtn{
    if (!_historyInvoiceBtn) {
        _historyInvoiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _historyInvoiceBtn.backgroundColor = RGB(236, 31, 35, 1);
        [_historyInvoiceBtn setTitle:@"开票历史" forState:0];
        [_historyInvoiceBtn setTitleColor:[UIColor whiteColor] forState:0];
        _historyInvoiceBtn.layer.cornerRadius = 5;
        _historyInvoiceBtn.layer.masksToBounds = YES;
        _historyInvoiceBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f*kScale];
        
    }
    return _historyInvoiceBtn;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
