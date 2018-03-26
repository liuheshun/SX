//
//  CurrentAddressView.m
//  Emeat
//
//  Created by liuheshun on 2017/12/4.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import "CurrentAddressView.h"
#import "GetWidthAndHeightOfString.h"

@implementation CurrentAddressView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.currentImv];
        [self addSubview:self.currentAddressLab];
        [self addSubview:self.placeholderLab];
        [self addSubview:self.locationBtn];
        [self setMainUI];
     

    }
    return self;
}

-(UIImageView*)currentImv{
    if (!_currentImv) {
        _currentImv = [[UIImageView alloc] init];
        _currentImv.image = [UIImage imageNamed:@"dingwei"];
    }
    return _currentImv;
}




-(UILabel*)currentAddressLab{
    if (!_currentAddressLab) {
        _currentAddressLab = [[UILabel alloc] init];
        _currentAddressLab.font = [UIFont systemFontOfSize:15.0f];
        
    }
    return _currentAddressLab;
}



-(UILabel*)placeholderLab{
    if (!_placeholderLab) {
        _placeholderLab = [[UILabel alloc] init];
        _placeholderLab.font = [UIFont systemFontOfSize:12.0f];
        _placeholderLab.textColor = RGB(138, 138, 138, 1);

    }
    return _placeholderLab;
}
-(void)setMainUI{
    [self.currentImv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15);
        make.top.equalTo(self.mas_top).with.offset(14);
        make.width.equalTo(@15);
        make.height.equalTo(@17);
    }];
    
    [self.locationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.height.equalTo(self);
        make.width.equalTo(@40);
    }];
    [self.placeholderLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.currentAddressLab.mas_right).with.offset(5);
        make.top.equalTo(self.mas_top).with.offset(0);
        make.right.equalTo(self.locationBtn.mas_left).with.offset(5);
        make.height.equalTo(self);
    }];
    [self.currentAddressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.currentImv.mas_right).with.offset(10);
        make.top.equalTo(self.mas_top).with.offset(0);
        make.right.equalTo(self.placeholderLab.mas_left).with.offset(5);
        make.height.equalTo(self);
    }];
    
   
   
    
}


-(UIButton*)locationBtn{
    if (!_locationBtn) {
        _locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_locationBtn setImage:[UIImage imageNamed:@"jiazai"] forState:0];
    }
    return _locationBtn;
}

-(void)setCurrentLabelTitle:(NSString *)text{
    self.currentAddressLab.text = text;
//    CGFloat width1=   [GetWidthAndHeightOfString getWidthForText:self.currentAddressLab height:45*kScale];
//    CGRect rect = self.currentAddressLab.frame;
//    rect.size.width = width1;
//    self.currentAddressLab.frame = rect;
//    CGRect rectPlaceHolder = self.placeholderLab.frame;
//    rectPlaceHolder.origin.x = MaxX(self.currentAddressLab)+10*kScale;
//    self.placeholderLab.frame = rectPlaceHolder;
//
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
