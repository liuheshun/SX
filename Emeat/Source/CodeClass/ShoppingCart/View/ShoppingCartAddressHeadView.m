//
//  ShoppingCartAddressHeadView.m
//  Emeat
//
//  Created by liuheshun on 2018/1/3.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "ShoppingCartAddressHeadView.h"

@implementation ShoppingCartAddressHeadView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.addressImv];
        [self addSubview:self.addressBtn];
        [self setMainViewFrame];
    }
    return self;
}

-(UIImageView *)addressImv{
    if (!_addressImv) {
        _addressImv = [[UIImageView alloc] init];
        _addressImv.image = [UIImage imageNamed:@"dingwei_red"];
    }
    return _addressImv;
}

-(UIButton *)addressBtn{
    if (!_addressBtn) {
        _addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addressBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [_addressBtn setTitleColor:RGB(138, 138, 138, 1) forState:0];
        _addressBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        _addressBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _addressBtn;
}

-(void)setMainViewFrame{
    [self.addressImv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15);
        make.top.equalTo(self.mas_top).with.offset(10);
        make.width.equalTo(@12);
        make.height.equalTo(@15);
        
    }];
    
    [self.addressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addressImv.mas_right).with.offset(10);
        make.top.equalTo(self.mas_top).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.height.equalTo(@35);
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
