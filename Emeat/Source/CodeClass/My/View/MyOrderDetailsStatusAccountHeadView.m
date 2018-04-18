//
//  MyOrderDetailsStatusAccountHeadView.m
//  Emeat
//
//  Created by liuheshun on 2018/4/17.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "MyOrderDetailsStatusAccountHeadView.h"

@implementation MyOrderDetailsStatusAccountHeadView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.accountBgView];
        [self.accountBgView addSubview:self.accountLable];
        [self.accountBgView addSubview:self.accountWhere];
        [self.accountBgView addSubview:self.accountName];
        [self setMainView];
    }
    return self;
}

-(void)setMainView{
    
    [self.accountBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.top.equalTo(self.mas_top).with.offset(10*kScale);
        make.height.equalTo(@(94*kScale));
        
    }];
    
    [self.accountLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.accountBgView.mas_top).with.offset(10*kScale);
        make.left.equalTo(self.accountBgView.mas_left).with.offset(15*kScale);
        make.right.equalTo(self.accountBgView.mas_right).with.offset(-15*kScale);
        make.height.equalTo(@(15*kScale));

    }];

    [self.accountWhere mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.accountLable.mas_bottom).with.offset(10*kScale);
        make.left.equalTo(self.accountBgView.mas_left).with.offset(15*kScale);
        make.right.equalTo(self.accountBgView.mas_right).with.offset(-15*kScale);
        make.height.equalTo(@(15*kScale));

    }];

    [self.accountName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.accountWhere.mas_bottom).with.offset(10*kScale);
        make.left.equalTo(self.accountBgView.mas_left).with.offset(15*kScale);
        make.right.equalTo(self.accountBgView.mas_right).with.offset(-15*kScale);
        make.height.equalTo(@(15*kScale));

    }];
}

-(UIImageView *)accountBgView{
    if (!_accountBgView) {
        _accountBgView = [[UIImageView alloc] init];
        _accountBgView.backgroundColor = [UIColor whiteColor];
    }
    return _accountBgView;
}

-(UILabel *)accountLable{
    if (!_accountLable) {
        _accountLable = [[UILabel alloc] init];
        _accountLable.font = [UIFont systemFontOfSize:15.0f*kScale];
        _accountLable.textAlignment = NSTextAlignmentLeft;
        _accountLable.textColor = RGB(51, 51, 51, 1);
        _accountLable.text = @"请打款至账户: 3105 0177 4100 0000 0591";
        
        
        
        // 创建Attributed
        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:_accountLable.text];
//        // 需要改变的第一个文字的位置
//        NSUInteger firstLoc = [[noteStr string] rangeOfString:@"金"].location + 1;
//        // 需要改变的最后一个文字的位置
//        NSUInteger secondLoc = [[noteStr string] rangeOfString:@"元"].location;
//        // 需要改变的区间
//        NSRange range = NSMakeRange(firstLoc, secondLoc - firstLoc);
        // 改变颜色
         NSRange range = NSMakeRange(7, 25);
        [noteStr addAttribute:NSForegroundColorAttributeName value:RGB(236, 31, 35, 1) range:range];
        // 改变字体大小及类型
        [noteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0f*kScale] range:range];
        // 为label添加Attributed
        [_accountLable setAttributedText:noteStr];
        
        
        
        
        
        //236 31 35
    }
    return _accountLable;
}

-(UILabel *)accountWhere{
    if (!_accountWhere) {
        _accountWhere = [[UILabel alloc] init];
        _accountWhere.font = [UIFont systemFontOfSize:13.0f*kScale];
        _accountWhere.textAlignment = NSTextAlignmentLeft;
        _accountWhere.textColor = RGB(136, 136, 136, 1);
        _accountWhere.text = @"开户行: 中国建设银行股份有限公司上海光新路支行";
    }
    return _accountWhere;
}


-(UILabel *)accountName{
    if (!_accountName) {
        _accountName = [[UILabel alloc] init];
        _accountName.font = [UIFont systemFontOfSize:13.0f*kScale];
        _accountName.textAlignment = NSTextAlignmentLeft;
        _accountName.textColor = RGB(136, 136, 136, 1);
        _accountName.text = @"开户名: 上海优斌电子商务有限公司";
    }
    return _accountName;
}
















@end
