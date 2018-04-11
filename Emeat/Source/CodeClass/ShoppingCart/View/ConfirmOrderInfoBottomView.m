//
//  ConfirmOrderInfoBottomView.m
//  Emeat
//
//  Created by liuheshun on 2017/11/10.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import "ConfirmOrderInfoBottomView.h"

@implementation ConfirmOrderInfoBottomView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.leftBottomBtn];
        [self addSubview:self.rightBottomBtn];
        [self setMainFrame];
    }
    return self;
}

-(UIButton*)leftBottomBtn{
    if (!_leftBottomBtn) {
        _leftBottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _leftBottomBtn.frame = CGRectMake(0, 0, kWidth/2, HEIGHT(self));
        [_leftBottomBtn setTitleColor:RGB(236, 31, 35, 1) forState:0];
        _leftBottomBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f*kScale];
    }
    return _leftBottomBtn;
}

-(UIButton*)rightBottomBtn{
    if (!_rightBottomBtn) {
        _rightBottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _rightBottomBtn.frame = CGRectMake(MaxX(self.leftBottomBtn), 0, kWidth/2, HEIGHT(self));
        [_rightBottomBtn setTitleColor:[UIColor whiteColor] forState:0];
        [_rightBottomBtn setBackgroundColor:RGB(236, 31, 35, 1)];
        _rightBottomBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f*kScale];

    }
    return _rightBottomBtn;
}



-(void)setMainFrame{
    [self.leftBottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.width.equalTo(@(kWidth/2));
        make.top.equalTo(self.mas_top).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
        
    }];
    
    [self.rightBottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftBottomBtn.mas_right).with.offset(0);
        make.width.equalTo(@(kWidth/2));
        make.top.equalTo(self.mas_top).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
        
    }];
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
