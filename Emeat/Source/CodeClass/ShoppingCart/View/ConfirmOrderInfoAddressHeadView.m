//
//  ConfirmOrderInfoHeadView.m
//  Emeat
//
//  Created by liuheshun on 2017/11/13.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import "ConfirmOrderInfoAddressHeadView.h"

@implementation ConfirmOrderInfoAddressHeadView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.addressImv];
        [self addSubview:self.nameLab];
        [self addSubview:self.phoneLab];
        [self addSubview:self.addressLab];
        [self setUIMainFrame];
        
        self.nameLab.text = @"";
        self.phoneLab.text = [NSString stringWithFormat:@"%@" ,@""];
        self.addressLab.text = @"选择您的收货地址";
//        self.nameLab.backgroundColor = [UIColor orangeColor];
//        self.phoneLab.backgroundColor = [UIColor orangeColor];
//        self.addressLab.backgroundColor = [UIColor orangeColor];

    }
    return self;
}

-(void)configMyShippingAddressWithMyAddressModel:(MyAddressModel*)mdoel{
    
    self.nameLab.text = mdoel.receiverName;
    self.phoneLab.text = [NSString stringWithFormat:@"%ld" ,mdoel.receiverPhone];
    self.addressLab.text = [NSString stringWithFormat:@"%@%@" ,mdoel.receiverProvince ,mdoel.receiverAddress];
    
    CGFloat nameWidth = [GetWidthAndHeightOfString getWidthForText:self.nameLab height:15*kScale];
    [self.nameLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addressImv.mas_right).with.offset(10*kScale);
        make.top.equalTo(self.mas_top).with.offset(10*kScale);
        make.width.equalTo(@(nameWidth));
        make.height.equalTo(@(15*kScale));
    }];
    
    
    
    ///更改位置
    [self.addressLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addressImv.mas_right).with.offset(10*kScale);
        make.top.equalTo(self.nameLab.mas_bottom).with.offset(10*kScale);
        make.right.equalTo(self.mas_right).with.offset(-30*kScale);
        make.height.equalTo(@(15*kScale));
    }];
    
}






-(void)setUIMainFrame{
    
    [self.addressImv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(15*kScale);
        make.top.equalTo(self).with.offset(25*kScale);
        make.width.equalTo(@(13*kScale));
        make.height.equalTo(@(15*kScale));
    }];
    
    
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addressImv.mas_right).with.offset(10*kScale);
        make.top.equalTo(self.mas_top).with.offset(10*kScale);
        make.width.equalTo(@(115*kScale));
        make.height.equalTo(@(15*kScale));
    }];
    
    [self.phoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLab.mas_right).with.offset(10*kScale);
        make.top.equalTo(self).with.offset(10*kScale);
        make.right.equalTo(self.mas_right).with.offset(-30*kScale);
        make.height.equalTo(@(15*kScale));
    }];
    
    
    [self.addressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addressImv.mas_right).with.offset(10*kScale);
        make.top.equalTo(self.addressImv);
        make.right.equalTo(self.mas_right).with.offset(-30*kScale);
        make.height.equalTo(@(15*kScale));
    }];
}

-(UIImageView *)addressImv{
    if (!_addressImv) {
        _addressImv = [UIImageView new];
        _addressImv.image = [UIImage imageNamed:@"dingwei"];

    }
    return _addressImv;
}

-(UILabel *)nameLab{
    if (!_nameLab) {
        _nameLab = [UILabel new];
        _nameLab.font = [UIFont systemFontOfSize:15.0f*kScale];
        _nameLab.textColor = RGB(51, 51, 51, 1);
    }
    return _nameLab;
}

-(UILabel *)phoneLab{
    if (!_phoneLab) {
        _phoneLab = [UILabel new];
        _phoneLab.font = [UIFont systemFontOfSize:15.0f*kScale];
        _phoneLab.textColor = RGB(51, 51, 51, 1);
    }
    return _phoneLab;
}


-(UILabel *)addressLab{
    if (!_addressLab) {
        _addressLab = [UILabel new];
        _addressLab.font = [UIFont systemFontOfSize:15.0f*kScale];
        _addressLab.textColor = RGB(51, 51, 51, 1);
    }
    return _addressLab;
}


//-(void)setHeadView:(NSInteger )integer{
//    if (integer == 1) {
//        
//        UIImageView *addressImv = [[UIImageView alloc] initWithFrame:CGRectMake(15*kScale, 25*kScale, 13*kScale, 15*kScale)];
//        addressImv.image = [UIImage imageNamed:@"dingwei"];
//        [self addSubview:addressImv];
//        
//        UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(addressImv)+10*kScale, 10*kScale, 115*kScale, 15*kScale)];
//        nameLab.font = [UIFont systemFontOfSize:15.0f];
//        [self addSubview:nameLab];
//        
//        UILabel *phoneLab = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(nameLab)+10*kScale, Y(nameLab), 120*kScale, HEIGHT(nameLab))];
//        phoneLab.font = [UIFont systemFontOfSize:15.0f];
//        [self addSubview:phoneLab];
//        
//        UILabel *addressLab = [[UILabel alloc] initWithFrame:CGRectMake(X(nameLab), MaxY(nameLab)+10*kScale, 300*kScale, HEIGHT(nameLab))];
//        addressLab.font = [UIFont systemFontOfSize:15.0f];
//        [self addSubview:addressLab];
//        
//        nameLab.text = @"李明明";
//        phoneLab.text = @"18132435353";
//        addressLab.text = @"浙江省杭州市西湖区浙江中小企业大厦608室";
//        
//    }else{
//        
//        
//        
//        
//        
//        
//    }
//}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
