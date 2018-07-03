//
//  InvoiceHistoryTableViewCell.m
//  Emeat
//
//  Created by liuheshun on 2018/6/26.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "InvoiceHistoryTableViewCell.h"

@implementation InvoiceHistoryTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.timeLab];
        
        [self addSubview:self.invoiceStatedLab];
        [self addSubview:self.lineView];
        [self addSubview:self.orderDescLab];
        [self addSubview:self.invoiceTypes];
        [self setMainFrame];
        
    }
    return self;
}

-(void)configCell:(InvoiceDetailsModel *)model{
    
//    // timeStampString 是服务器返回的13位时间戳
//    NSString *timeStampString  = model.createDate;
//    // iOS 生成的时间戳是10位
//    NSTimeInterval interval    =[timeStampString doubleValue] / 1000.0;
//    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSString *dateString       = [formatter stringFromDate: date];
//    NSLog(@"服务器返回的时间戳对应的时间是:%@",dateString);
//    
    self.timeLab.text =  model.createDate;
    // iOS 生成的时间戳是10位;
//    WaitedTicket(41,"待开票"),
//    FinishedTicket(42,"已开票"),
//    RefusedTicket(43,"开票拒绝");
    if (model.invoiceStatus == 41) {
         self.invoiceStatedLab.text =@"待开票";
    }else if (model.invoiceStatus == 42){
        self.invoiceStatedLab.text =@"已开票";

    }else if (model.invoiceStatus == 43){
        self.invoiceStatedLab.text =@"开票拒绝";

    }
   
    self.orderDescLab.text =[NSString stringWithFormat:@"含%ld个订单 ,开票金额%.2f元" ,model.orderNum ,[model.invoiceAmount floatValue]/100 ] ;
    self.invoiceTypes.text = @"纸质专票";
    
}

#pragma mark - 将某个时间戳转化成 时间

-(NSString *)timestampSwitchTime:(NSInteger)timestamp andFormatter:(NSString *)format{
    
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:format]; // （@"YYYY-MM-dd hh:mm:ss"）----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
    NSLog(@"1296035591  = %@",confromTimesp);
    
    
    
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    
    
    //NSLog(@"&&&&&&&confromTimespStr = : %@",confromTimespStr);
    
    
    
    return confromTimespStr;
    
}
////日期转换为时间字符串
- (NSString *)stringFromdate:(NSDate *)date {
    //实例化一个NSDateFormatter对象
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    // 设置时间格式的时区 东八区 北京时间
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    return [dateFormat stringFromDate:date];
}



-(void)setMainFrame{
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15*kScale);
        make.top.equalTo(self);
        make.width.equalTo(@(200*kScale));
        make.height.equalTo(@(30*kScale));
    }];
    
    
    [self.invoiceStatedLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.top.equalTo(self);
        make.width.equalTo(@(200*kScale));
        make.height.equalTo(@(30*kScale));
    }];
    
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15*kScale);
        make.top.equalTo(self.timeLab.mas_bottom).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.height.equalTo(@(1*kScale));
    }];
    
    
    
    [self.orderDescLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15*kScale);
        make.top.equalTo(self.lineView.mas_bottom).with.offset(10*kScale);
        make.width.equalTo(@(320*kScale));
        make.height.equalTo(@(15*kScale));
    }];
    
    
    [self.invoiceTypes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.bottom.equalTo(self.mas_bottom).with.offset(-10*kScale);
        make.width.equalTo(@(120*kScale));
        make.height.equalTo(@(15*kScale));
    }];
    
}



-(UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] init];
        _timeLab.font = [UIFont systemFontOfSize:12.0f*kScale];
        _timeLab.textAlignment = NSTextAlignmentLeft;
        _timeLab.textColor = RGB(136, 136, 136, 1);
        
    }
    return _timeLab;
}

-(UILabel *)invoiceStatedLab{
    if (!_invoiceStatedLab) {
        _invoiceStatedLab = [[UILabel alloc] init];
        _invoiceStatedLab.font = [UIFont systemFontOfSize:12.0f*kScale];
        _invoiceStatedLab.textAlignment = NSTextAlignmentRight;
        _invoiceStatedLab.textColor = RGB(51, 51, 51, 1);
        
    }
    return _invoiceStatedLab;
}




-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = RGB(238, 238, 238, 1);
    }
    return _lineView;
}

-(UILabel *)orderDescLab{
    if (!_orderDescLab) {
        _orderDescLab = [[UILabel alloc] init];
        _orderDescLab.font = [UIFont systemFontOfSize:15.0f*kScale];
        _orderDescLab.textAlignment = NSTextAlignmentLeft;
        _orderDescLab.textColor = RGB(51, 51, 51, 1);
        
    }
    return _orderDescLab;
}



-(UILabel *)invoiceTypes{
    if (!_invoiceTypes) {
        _invoiceTypes = [[UILabel alloc] init];
        _invoiceTypes.font = [UIFont systemFontOfSize:12.0f*kScale];
        _invoiceTypes.textAlignment = NSTextAlignmentRight;
        _invoiceTypes.textColor = RGB(51, 51, 51, 1);
        
    }
    return _invoiceTypes;
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
