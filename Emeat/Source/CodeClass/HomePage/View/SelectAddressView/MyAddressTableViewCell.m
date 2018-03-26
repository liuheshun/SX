//
//  MyAddressTableViewCell.m
//  Emeat
//
//  Created by liuheshun on 2018/3/5.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "MyAddressTableViewCell.h"

@implementation MyAddressTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.nameLab];
        [self addSubview:self.phoneNumLab];
        [self addSubview:self.addressType];
        [self addSubview:self.addressLab];
        [self addSubview:self.editBtn];
        [self setMainFrame];
    }
    return self;
}




-(UILabel *)nameLab{
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] init];
        _nameLab.font = [UIFont systemFontOfSize:12.0f];
        _nameLab.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLab;
}



-(UILabel *)phoneNumLab{
    if (!_phoneNumLab) {
        _phoneNumLab = [[UILabel alloc] init];
        _phoneNumLab.font = [UIFont systemFontOfSize:12.0f];
        _phoneNumLab.textAlignment = NSTextAlignmentLeft;
    }
    return _phoneNumLab;
}


-(UILabel *)addressType{
    if (!_addressType) {
        _addressType = [[UILabel alloc] init];
        _addressType.font = [UIFont systemFontOfSize:12.0f];
        _addressType.backgroundColor = RGB(231, 35, 36, 1);
        _addressType.layer.cornerRadius = 5;
        _addressType.layer.masksToBounds = YES;
        _addressType.textAlignment = NSTextAlignmentCenter;
        _addressType.textColor = [UIColor whiteColor];
    }
    return _addressType;
}


-(UILabel *)addressLab{
    if (!_addressLab) {
        _addressLab = [[UILabel alloc] init];
        _addressLab.font = [UIFont systemFontOfSize:12.0f];
        _addressLab.textAlignment = NSTextAlignmentLeft;
        
    }
    return _addressLab;
}

-(UIButton*)editBtn{
    if (!_editBtn) {
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editBtn setImage:[UIImage imageNamed:@"bianji"] forState:0];
        
    }
    return _editBtn;
}

-(void)setMainFrame{
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15);
        make.top.equalTo(self.mas_top).with.offset(15);
        make.width.equalTo(@55);
        make.height.equalTo(@15);
    }];
    [self.phoneNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLab.mas_right).with.offset(0);
        make.top.equalTo(self.nameLab);
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.height.equalTo(@15);
    }];
    
    [self.addressType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLab);
        make.top.equalTo(self.nameLab.mas_bottom).with.offset(13);
        make.width.equalTo(@35);
        make.height.equalTo(@19);
    }];
    
    [self.addressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneNumLab);
        make.top.equalTo(self.addressType);
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.height.equalTo(@15);
    }];
    
    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.top.equalTo(self.mas_top).with.offset(10);
        make.width.height.equalTo(@30);
        
    }];
}

-(void)setConfigAddressInfo:(MyAddressModel*)addressModel isEdit:(BOOL)isEdit fromConfirmVC:(NSString*)fromConfirmVC{
    
    if (isEdit == NO) {
        [self.editBtn removeFromSuperview];
    }
    self.nameLab.text = addressModel.receiverName;
    self.phoneNumLab.text =[NSString stringWithFormat:@"%ld" ,addressModel.receiverPhone];
    self.addressLab.text = [NSString stringWithFormat:@"%@%@",[addressModel.receiverProvince stringByReplacingOccurrencesOfString:@"," withString:@""] , addressModel.receiverAddress];
    if ([fromConfirmVC isEqualToString:@"1"]) {//确认订单的时候 点击进来, 进行地址判断,不在配送区域的字体颜色变浅色
        
        if ([addressModel.receiverProvince containsString:@"上海市"] && ![addressModel.receiverProvince containsString:@"崇明区"]) {
            DLog(@"在范围内");
            self.nameLab.textColor = RGB(51, 51, 51, 1);
            self.phoneNumLab.textColor = RGB(51, 51, 51, 1);
            self.addressLab.textColor = RGB(51, 51, 51, 1);
            
        }else{
            DLog(@"-------------不在");
            self.nameLab.textColor = RGB(153, 153, 153, 1);
            self.phoneNumLab.textColor = RGB(153, 153, 153, 1);
            self.addressLab.textColor = RGB(153, 153, 153, 1);
            
        }
        
    }
    else
    {
        self.nameLab.textColor = RGB(51, 51, 51, 1);
        self.phoneNumLab.textColor = RGB(51, 51, 51, 1);
        self.addressLab.textColor = RGB(51, 51, 51, 1);
    }
    
    
    if (addressModel.shippingCategory == 1) {
        self.addressType.text = @"公司";
    }else if (addressModel.shippingCategory == 2){
        self.addressType.text = @"住宅";
        
    }else{
        self.addressType.text = @"其它";
        
    }
    
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
