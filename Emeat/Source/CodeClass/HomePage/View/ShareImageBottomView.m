//
//  ShareImageBottomView.m
//  Emeat
//
//  Created by liuheshun on 2018/7/16.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "ShareImageBottomView.h"

@implementation ShareImageBottomView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.lineImageView];
        [self addSubview:self.shareToLab];
        [self addSubview:self.wechatBtn];
        [self addSubview:self.wechatTimeLineBtn];
        [self setFrame];
    }
    return self;
}

-(void)setFrame{
    [self.lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15*kScale);
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.top.equalTo(self.mas_top).with.offset(25*kScale);
        make.height.equalTo(@(10*kScale));
    }];
    [self.shareToLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15*kScale);
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.top.equalTo(self.mas_top).with.offset(20*kScale);
        make.height.equalTo(@(15*kScale));
    }];
    
    
    [self.wechatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset((kWidth-176*kScale)/3+20*kScale);
        make.top.equalTo(self.lineImageView.mas_bottom).with.offset(25*kScale);
        make.height.width.equalTo(@(80*kScale));
    }];
    
    [self.wechatTimeLineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-(kWidth-176*kScale)/3 - 20*kScale);
        make.top.equalTo(self.lineImageView.mas_bottom).with.offset(25*kScale);
        make.height.width.equalTo(@(80*kScale));
    }];
    
    [self.wechatBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:10*kScale];
    
     [self.wechatTimeLineBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:10*kScale];
    
   // self.wechatBtn.backgroundColor = [UIColor cyanColor];
    
}


-(UIImageView *)lineImageView{
    if (!_lineImageView) {
        _lineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"share_lineview"]];
    }
    return _lineImageView;
}

-(UILabel *)shareToLab{
    if (!_shareToLab) {
        _shareToLab = [[UILabel alloc] init];
        _shareToLab.textAlignment = NSTextAlignmentCenter;
        _shareToLab.font = [UIFont systemFontOfSize:15.0f*kScale];
        _shareToLab.text = @"分享到";
    }
    return _shareToLab;
}

-(UIButton *)wechatBtn{
    if (!_wechatBtn) {
        _wechatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_wechatBtn setImage:[UIImage imageNamed:@"微信"] forState:UIControlStateNormal];
        [_wechatBtn setTitle:@"微信好友" forState:UIControlStateNormal];
        [_wechatBtn setTitleColor:RGB(51, 51, 51, 1) forState:UIControlStateNormal];
        _wechatBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f*kScale];
        
    }
    return _wechatBtn;
}


-(UIButton *)wechatTimeLineBtn{
    if (!_wechatTimeLineBtn) {
        _wechatTimeLineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_wechatTimeLineBtn setImage:[UIImage imageNamed:@"朋友圈"] forState:UIControlStateNormal];
        [_wechatTimeLineBtn setTitle:@"微信朋友圈" forState:UIControlStateNormal];
        [_wechatTimeLineBtn setTitleColor:RGB(51, 51, 51, 1) forState:UIControlStateNormal];
        _wechatTimeLineBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f*kScale];
        
    }
    return _wechatTimeLineBtn;
}



@end
