//
//  ShoppingCartEmptyHeadView.m
//  Emeat
//
//  Created by liuheshun on 2018/1/3.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "ShoppingCartEmptyHeadView.h"

@implementation ShoppingCartEmptyHeadView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.emptyImv];
        [self addSubview:self.emptyDescLab];
        [self setMainViewFrame];
    }
    return self;
}

-(UIImageView *)emptyImv{
    if (!_emptyImv) {
        _emptyImv = [UIImageView new];
        _emptyImv.image = [UIImage imageNamed:@"购物车空"];
    }
    return _emptyImv;
}

-(UILabel *)emptyDescLab{
    if (!_emptyDescLab) {
        _emptyDescLab = [[UILabel alloc] init];
        _emptyDescLab.font = [UIFont systemFontOfSize:15.0f];
        _emptyDescLab.textAlignment = NSTextAlignmentCenter;
        _emptyDescLab.textColor = RGB(138, 138, 138, 1);
        _emptyDescLab.text = @"您还没有添加任何商品,快去逛逛吧~";
    }
    return _emptyDescLab;
}

-(void)setMainViewFrame{
    [self.emptyImv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(50);
        make.height.equalTo(@48);
        make.left.equalTo(self.mas_left).with.offset((kWidth-50)/2);
        make.width.equalTo(@50);
    }];
    
    [self.emptyDescLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.emptyImv.mas_bottom).with.offset(25);
        make.height.equalTo(@15);
        make.left.equalTo(self.mas_left).with.offset(15);
        make.right.equalTo(self.mas_right).with.offset(-15);
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
