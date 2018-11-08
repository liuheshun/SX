//
//  HomePageDeatilsHeadSpecificationsView.m
//  Emeat
//
//  Created by liuheshun on 2018/10/12.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "HomePageDeatilsHeadSpecificationsView.h"

@implementation HomePageDeatilsHeadSpecificationsView



-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.countryLab];
        [self addSubview:self.partLab];
        [self addSubview:self.standardsLab];
        [self addSubview:self.breedLab];
        [self addSubview:self.environmentLab];
        [self addSubview:self.brandLab];
        [self addSubview:self.factoryNumLab];
        [self setMainViewFrame];
    }
    return self;
}


-(void)configSpecialHeadViewWithModel:(HomePageModel*)model{
   
    NSString *tempString;
    if ([model.isMeal isEqualToString:@"1"]) {
       // [self.goodsDetailsBtn setTitle:@"套餐详情" forState:0];
        tempString = @"等";
    }else{
        //[self.goodsDetailsBtn setTitle:@"商品详情" forState:0];
        tempString = @"";
    }
    
    
    self.countryLab.text = [NSString stringWithFormat:@"原产地: %@%@",model.origin ,tempString];
    self.partLab.text = [NSString stringWithFormat:@"部位: %@%@" , model.position ,tempString];
    self.standardsLab.text = [NSString stringWithFormat:@"规格: %@" ,model.size ];
    self.breedLab.text = [NSString stringWithFormat:@"品种: %@%@" ,model.varieties,tempString];
    self.environmentLab.text = [NSString stringWithFormat:@"存储条件: %@" ,model.storageConditions ];
    if ([model.brand isEqualToString:@"无"]) {
        self.brandLab.text = [NSString stringWithFormat:@"品牌: %@" ,model.brand];
    }else{
        self.brandLab.text = [NSString stringWithFormat:@"品牌: %@%@" ,model.brand ,tempString];
    }
    if (model.factoryNum.length == 0) {
        model.factoryNum = @"";
    }
    self.factoryNumLab.text = [NSString stringWithFormat:@"厂号: %@" ,model.factoryNum];

    
}



-(void)setMainViewFrame{
    
        [self.countryLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).with.offset(15*kScale);
            make.top.equalTo(self.mas_top).with.offset(10*kScale);
            make.width.equalTo(@((kWidth/2-15)*kScale));
            make.height.equalTo(@(12*kScale));
        }];
    
        [self.partLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).with.offset(-15*kScale);
            make.top.equalTo(self.countryLab);
            make.width.equalTo(@((kWidth/2-15)*kScale));
            make.height.equalTo(@(12*kScale));
        }];
    
    
        [self.standardsLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).with.offset(15*kScale);
            make.top.equalTo(self.countryLab.mas_bottom).with.offset(15*kScale);
            make.width.equalTo(@((kWidth/2-15)*kScale));
            make.height.equalTo(@(12*kScale));
        }];
    
        [self.breedLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).with.offset(-15*kScale);
            make.top.equalTo(self.partLab.mas_bottom).with.offset(15*kScale);
            make.width.equalTo(@((kWidth/2-15)*kScale));
            make.height.equalTo(@(12*kScale));
        }];
    
    
        [self.environmentLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).with.offset(15*kScale);
            make.top.equalTo(self.standardsLab.mas_bottom).with.offset(15*kScale);
            make.width.equalTo(@((kWidth/2-15)*kScale));
            make.height.equalTo(@(12*kScale));
        }];
    
        [self.brandLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).with.offset(-15*kScale);
            make.top.equalTo(self.breedLab.mas_bottom).with.offset(15*kScale);
            make.width.equalTo(@((kWidth/2-15)*kScale));
            make.height.equalTo(@(12*kScale));
        }];
    
    
    [self.factoryNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15*kScale);
        make.top.equalTo(self.brandLab.mas_bottom).with.offset(15*kScale);
        make.width.equalTo(@((kWidth/2-15)*kScale));
        make.height.equalTo(@(12*kScale));
    }];
    
    
}




-(UILabel*)countryLab{
    if (!_countryLab) {
        _countryLab = [[UILabel alloc] init];
        _countryLab.font = [UIFont systemFontOfSize:12.0f*kScale];
        _countryLab.textColor = RGB(51 , 51, 51, 51);
        _countryLab.textAlignment = NSTextAlignmentLeft;
    }
    return _countryLab;
}

-(UILabel*)partLab{
    if (!_partLab) {
        _partLab = [[UILabel alloc] init];
        _partLab.font = [UIFont systemFontOfSize:12.0f*kScale];
        _partLab.textColor = RGB(51 , 51, 51, 51);
        _partLab.textAlignment = NSTextAlignmentLeft;
    }
    return _partLab;
}


-(UILabel*)standardsLab{
    if (!_standardsLab) {
        _standardsLab = [[UILabel alloc] init];
        _standardsLab.font = [UIFont systemFontOfSize:12.0f*kScale];
        _standardsLab.textColor = RGB(51 , 51, 51, 51);
        _standardsLab.textAlignment = NSTextAlignmentLeft;
    }
    return _standardsLab;
}



-(UILabel*)breedLab{
    if (!_breedLab) {
        _breedLab = [[UILabel alloc] init];
        _breedLab.font = [UIFont systemFontOfSize:12.0f*kScale];
        _breedLab.textColor = RGB(51 , 51, 51, 51);
        _breedLab.textAlignment = NSTextAlignmentLeft;
    }
    return _breedLab;
}

-(UILabel*)environmentLab{
    if (!_environmentLab) {
        _environmentLab = [[UILabel alloc] init];
        _environmentLab.font = [UIFont systemFontOfSize:12.0f*kScale];
        _environmentLab.textColor = RGB(51 , 51, 51, 51);
        _environmentLab.textAlignment = NSTextAlignmentLeft;
    }
    return _environmentLab;
}

-(UILabel*)brandLab{
    if (!_brandLab) {
        _brandLab = [[UILabel alloc] init];
        _brandLab.font = [UIFont systemFontOfSize:12.0f*kScale];
        _brandLab.textColor = RGB(51 , 51, 51, 51);
        _brandLab.textAlignment = NSTextAlignmentLeft;
    }
    return _brandLab;
}

-(UILabel*)factoryNumLab{
    if (!_factoryNumLab) {
        _factoryNumLab = [[UILabel alloc] init];
        _factoryNumLab.font = [UIFont systemFontOfSize:12.0f*kScale];
        _factoryNumLab.textColor = RGB(51 , 51, 51, 51);
        _factoryNumLab.textAlignment = NSTextAlignmentLeft;
    }
    return _factoryNumLab;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
