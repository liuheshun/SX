//
//  HomePageNavSortTableViewCell.m
//  Emeat
//
//  Created by liuheshun on 2017/11/24.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import "HomePageNavSortTableViewCell.h"

@implementation HomePageNavSortTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.imv];
        [self addSubview:self.titleLab];
        [self setMainViewFrame];
       
    }
    return self;
}

-(void)configCell:(NSMutableDictionary*)dic{
    [_imv sd_setImageWithURL:[NSURL URLWithString:dic[@"pic"]]];
    self.titleLab.text = dic[@"dataName"];
}



-(void)setMainViewFrame{
    [self.imv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(22*kScale);
        make.top.equalTo(self.mas_top).with.offset(25*kScale);
        make.width.equalTo(@(80*kScale));
        make.height.equalTo(@(50*kScale));
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self.imv.mas_bottom).with.offset(14*kScale);
        make.width.equalTo(@(125*kScale));
        make.height.equalTo(@(12*kScale));
        
    }];
    
}



-(UIImageView*)imv{
    if (!_imv) {
        _imv = [[UIImageView alloc] init];
    }
    return _imv;
}

-(UILabel*)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = [UIFont systemFontOfSize:12.0f*kScale];
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
