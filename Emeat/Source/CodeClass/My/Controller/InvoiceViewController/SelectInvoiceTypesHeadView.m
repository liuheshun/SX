//
//  SelectInvoiceTypesHeadView.m
//  Emeat
//
//  Created by liuheshun on 2018/6/22.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "SelectInvoiceTypesHeadView.h"

@implementation SelectInvoiceTypesHeadView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.selectInvoceTypesLabel];
        [self addSubview:self.invoiceTypesBgView];
        [self.invoiceTypesBgView addSubview:self.invoiceTypesBtn];
        [self addSubview:self.selectInvoceKindLabel];
        [self addSubview:self.invoiceKindBgView];
        
        [self.invoiceKindBgView addSubview:self.ordinaryInvoiceKindBtn];
        [self.invoiceKindBgView addSubview:self.specialInvoiceKindBtn];
        [self addSubview:self.invoiceDetailsLabel];
        [self setMainFrame];
    }
    return self;
}

-(void)ordinaryInvoiceKindBtnAction{
  
    self.selectInvoiceKindsBlock(1);
}

-(void)specialInvoiceKindBtnAction{
   
    self.selectInvoiceKindsBlock(0);

}

-(void)setMainFrame{
    [self.selectInvoceTypesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self);
        make.height.equalTo(@(30*kScale));
    }];
    [self.invoiceTypesBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.selectInvoceTypesLabel.mas_bottom).with.offset(0);
        make.height.equalTo(@(72*kScale));
    }];
    
    
    [self.invoiceTypesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.invoiceTypesBgView.mas_left).with.offset(30*kScale);
        make.top.equalTo(self.invoiceTypesBgView.mas_top).with.offset(16*kScale);
        make.height.equalTo(@(40*kScale));
        make.width.equalTo(@(145*kScale));
    }];
    
    [self.selectInvoceKindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.invoiceTypesBgView.mas_bottom).with.offset(0);
        make.height.equalTo(@(30*kScale));
    }];
    
    
    [self.invoiceKindBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.selectInvoceKindLabel.mas_bottom).with.offset(0);
        make.height.equalTo(@(72*kScale));

    }];
    
    
    
    [self.ordinaryInvoiceKindBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.invoiceKindBgView.mas_left).with.offset(30*kScale);
        make.top.equalTo(self.invoiceKindBgView.mas_top).with.offset(16*kScale);
        make.height.equalTo(@(40*kScale));
        make.width.equalTo(@(145*kScale));

    }];
    
    
    [self.specialInvoiceKindBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.invoiceKindBgView.mas_right).with.offset(-30*kScale);
        make.top.equalTo(self.invoiceKindBgView.mas_top).with.offset(16*kScale);
        make.height.equalTo(@(40*kScale));
        make.width.equalTo(@(145*kScale));
        
    }];
    
    [self.invoiceDetailsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.invoiceKindBgView.mas_bottom).with.offset(0);
        make.height.equalTo(@(30*kScale));
    }];
    
    
    
    
}


///发票类型
-(UILabel *)selectInvoceTypesLabel{
    if (!_selectInvoceTypesLabel) {
        _selectInvoceTypesLabel = [[UILabel alloc] init];
        _selectInvoceTypesLabel.font = [UIFont systemFontOfSize:12.0f*kScale];
        _selectInvoceTypesLabel.text = @"    请选择发票类型";
        _selectInvoceTypesLabel.textColor = RGB(136, 136, 136, 1);
        _selectInvoceTypesLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _selectInvoceTypesLabel;
}

-(UIButton *)invoiceTypesBtn{
    if (!_invoiceTypesBtn) {
        _invoiceTypesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _invoiceTypesBtn.layer.borderColor = RGB(236, 31, 35, 1).CGColor;
        _invoiceTypesBtn.layer.borderWidth = 1;
        _invoiceTypesBtn.layer.cornerRadius = 5;
        [_invoiceTypesBtn setTitle:@"纸质发票" forState:0];
        [_invoiceTypesBtn setTitleColor:RGB(236, 31, 35, 1) forState:0];
        _invoiceTypesBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f*kScale];
        
    }
    return _invoiceTypesBtn;
}

///发票种类
-(UILabel *)selectInvoceKindLabel{
    if (!_selectInvoceKindLabel) {
        _selectInvoceKindLabel = [[UILabel alloc] init];
        _selectInvoceKindLabel.font = [UIFont systemFontOfSize:12.0f*kScale];
        _selectInvoceKindLabel.textColor = RGB(136, 136, 136, 1);
        _selectInvoceKindLabel.textAlignment = NSTextAlignmentLeft;
        _selectInvoceKindLabel.text = @"    请选择发票种类";
    }
    return _selectInvoceKindLabel;
}


-(UIButton *)ordinaryInvoiceKindBtn{
    if (!_ordinaryInvoiceKindBtn) {
        _ordinaryInvoiceKindBtn = [UIButton buttonWithType:UIButtonTypeCustom];

        [_ordinaryInvoiceKindBtn setTitle:@"普通发票" forState:0];
        _ordinaryInvoiceKindBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f*kScale];
        [_ordinaryInvoiceKindBtn addTarget:self action:@selector(ordinaryInvoiceKindBtnAction) forControlEvents:1];

        
    }
    return _ordinaryInvoiceKindBtn;
}

-(UIButton *)specialInvoiceKindBtn{
    if (!_specialInvoiceKindBtn) {
        _specialInvoiceKindBtn = [UIButton buttonWithType:UIButtonTypeCustom];

        [_specialInvoiceKindBtn setTitle:@"专用发票" forState:0];
        _specialInvoiceKindBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f*kScale];

        [_specialInvoiceKindBtn addTarget:self action:@selector(specialInvoiceKindBtnAction) forControlEvents:1];

    }
    return _specialInvoiceKindBtn;
}

-(UILabel *)invoiceDetailsLabel{
    if (!_invoiceDetailsLabel) {
        _invoiceDetailsLabel = [[UILabel alloc] init];
        _invoiceDetailsLabel.font = [UIFont systemFontOfSize:12.0f*kScale];
        _invoiceDetailsLabel.textColor = RGB(136, 136, 136, 1);
        _invoiceDetailsLabel.textAlignment = NSTextAlignmentLeft;
        _invoiceDetailsLabel.text = @"    发票详情";
    }
    return _invoiceDetailsLabel;
}


-(UIView *)invoiceTypesBgView{
    if (!_invoiceTypesBgView) {
        _invoiceTypesBgView = [[UIView alloc] init];
        _invoiceTypesBgView.backgroundColor = [UIColor whiteColor];
        
    }
    return _invoiceTypesBgView;
}

-(UIView *)invoiceKindBgView{
    if (!_invoiceKindBgView) {
        _invoiceKindBgView = [[UIView alloc] init];
        _invoiceKindBgView.backgroundColor = [UIColor whiteColor];
        
    }
    return _invoiceKindBgView;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
