//
//  HomePageDetailsHeadView.m
//  Emeat
//
//  Created by liuheshun on 2017/11/20.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import "HomePageDetailsHeadView.h"


@implementation HomePageDetailsHeadView


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)setSDCycleScrollView:(NSArray*)imvURLArray{

    
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kWidth, 300*kScale) delegate:self placeholderImage:[UIImage imageNamed:@"dingdanxaingqingtu"]];   //placeholder
    cycleScrollView.imageURLStringsGroup = imvURLArray;
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView.showPageControl = YES;//是否显示分页控件
    cycleScrollView.currentPageDotColor = [UIColor orangeColor]; // 自定义分页控件小圆标颜色
    [self addSubview:cycleScrollView];
    self.cycleScrollView = cycleScrollView;
  
    [self addSubview:self.nameLab];
    [self addSubview:self.descLab];
    [self addSubview:self.pricelab];
    [self addSubview:self.weightLab];
    [self addSubview:self.noticeBtn];
    [self addSubview:self.lineView];
    [self addSubview:self.goodsDetailsBtn];
    
//    [self addSubview:self.pingjiaDetailsBtn];
//    [self addSubview:self.lineleftView];
//    [self addSubview:self.lineRightView];
    [self addSubview:self.countryLab];
    [self addSubview:self.partLab];
    [self addSubview:self.standardsLab];
    [self addSubview:self.breedLab];
    [self addSubview:self.environmentLab];
    [self addSubview:self.brandLab];
    
    [self setMainViewFrame];
    
}

-(void)configHeadViewWithModel:(HomePageModel*)model{
    
    self.nameLab.text = model.commodityName;
    self.descLab.text = model.commodityDesc;
    CGFloat hDesc =   [GetWidthAndHeightOfString getHeightForText:self.descLab width:(kWidth-30)];
    
    [self.descLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(hDesc));
    }];
    
    self.pricelab.text = [NSString stringWithFormat:@"¥%.2f元/kg" ,(float)model.unitPrice/100];

    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.pricelab.text];
    
    [string addAttribute:NSForegroundColorAttributeName value:RGB(236, 31, 35, 1) range:NSMakeRange(0, string.length-4)];
    
    [string addAttribute:NSForegroundColorAttributeName value:RGB(136, 136, 136, 1) range:NSMakeRange(string.length-4, string.length - (string.length-4))];
    self.pricelab.attributedText = string;

    self.weightLab.text = model.size2;
    
    CGFloat wPrice =   [GetWidthAndHeightOfString getWidthForText:self.weightLab height:20] +5;
    
    [self.weightLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(wPrice));
    }];
    
    
    [self.goodsDetailsBtn setTitle:@"商品详情" forState:0];
    //[self.pingjiaDetailsBtn setTitle:@"评价详情" forState:0];
    
    
    self.countryLab.text = [NSString stringWithFormat:@"原产地: %@" ,model.origin];
    self.partLab.text = [NSString stringWithFormat:@"部位: %@" , model.position];
    self.standardsLab.text = [NSString stringWithFormat:@"规格: %@" ,model.size];
    self.breedLab.text = [NSString stringWithFormat:@"品种: %@" ,model.varieties];
    self.environmentLab.text = [NSString stringWithFormat:@"存储条件: %@" ,model.storageConditions];
    self.brandLab.text = [NSString stringWithFormat:@"品牌: %@" ,model.brand];

    //model.headViewHeight = 426+55+150-13+hDesc;
}




-(void)setMainViewFrame{
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15*kScale);
        make.top.equalTo(self.mas_top).with.offset(330*kScale);
        make.width.equalTo(@(kWidth -30));
        make.height.equalTo(@(17*kScale));
    }];
    
    [self.descLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15*kScale);
        make.top.equalTo(self.nameLab.mas_bottom).with.offset(10*kScale);
        make.width.equalTo(@(kWidth -30));
        make.height.equalTo(@(13*kScale));
    }];
    [self.pricelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15*kScale);
        make.top.equalTo(self.descLab.mas_bottom).with.offset(10*kScale);
        make.width.equalTo(@(kWidth -30*kScale));
        make.height.equalTo(@(20*kScale));
    }];
    [self.weightLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15*kScale);
        make.top.equalTo(self.pricelab.mas_bottom).with.offset(10*kScale);
        make.width.equalTo(@(65*kScale));
        make.height.equalTo(@(20*kScale));
    }];
    
    [self.noticeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.weightLab.mas_right).with.offset(5*kScale);
        make.top.equalTo(self.pricelab.mas_bottom).with.offset(0);
        make.width.equalTo(@(40*kScale));
        make.height.equalTo(@(40*kScale));
    }];
    
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self);
        make.top.equalTo(self.weightLab.mas_bottom).with.offset(20*kScale);
        make.height.equalTo(@(10*kScale));

    }];
    
    [self.goodsDetailsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self.lineView.mas_bottom).with.offset(0);
        //make.top.equalTo(self.weightLab.mas_bottom).with.offset(25);
       // make.width.equalTo(@(kWidth/2));
        make.width.equalTo(@(kWidth));

        make.height.equalTo(@(45*kScale));
    }];
    
//    [self.pingjiaDetailsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.goodsDetailsBtn.mas_right).with.offset(0);
//        make.top.equalTo(self.lineView.mas_bottom).with.offset(0);
//        make.width.equalTo(@(kWidth/2));
//        make.height.equalTo(@45);
//    }];
//
//    [self.lineleftView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self);
//        make.top.equalTo(self.goodsDetailsBtn.mas_bottom).with.offset(0);
//        make.width.equalTo(@(kWidth/2));
//        make.height.equalTo(@2);
//        
//    }];
//    
//    [self.lineRightView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(@(kWidth/2));
//        make.top.equalTo(self.goodsDetailsBtn.mas_bottom).with.offset(0);
//        make.width.equalTo(@(kWidth/2));
//        make.height.equalTo(@2);
//        
//    }];
    
//    [self.speDescLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left).with.offset(15);
//        make.top.equalTo(self.goodsDetailsBtn.mas_bottom).with.offset(10);
//        make.width.equalTo(@50);
//        make.height.equalTo(@12);
//    }];
    
    [self.countryLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15*kScale);
        make.top.equalTo(self.goodsDetailsBtn.mas_bottom).with.offset(10*kScale);
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
    
}


-(UILabel*)nameLab{
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] init];
        _nameLab.font = [UIFont systemFontOfSize:17.0f*kScale];
        
    }
    return _nameLab;
}


-(UILabel*)descLab{
    if (!_descLab) {
        _descLab = [[UILabel alloc] init];
        _descLab.font = [UIFont systemFontOfSize:12.0f*kScale];
        _descLab.numberOfLines = 0;
        _descLab.textColor = RGB(138, 138, 138, 1);
        
    }
    return _descLab;
}

-(UILabel*)pricelab{
    if (!_pricelab) {
        _pricelab = [[UILabel alloc] init];
        _pricelab.font = [UIFont systemFontOfSize:17.0f*kScale];
        _pricelab.textColor = RGB(236, 31, 35, 1);
        
    }
    return _pricelab;
}

-(UILabel*)weightLab{
    if (!_weightLab) {
        _weightLab = [[UILabel alloc] init];
        _weightLab.font = [UIFont systemFontOfSize:12.0f*kScale];
        _weightLab.textColor = RGB(236 , 32, 35, 1);
        _weightLab.backgroundColor = RGB(251, 210, 211, 1);
        _weightLab.textAlignment = NSTextAlignmentCenter;
    }
    return _weightLab;
}

-(UIButton *)noticeBtn{
    if (!_noticeBtn) {
        _noticeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_noticeBtn setImage:[UIImage imageNamed:@"注意"] forState:0];
    }
    return _noticeBtn;
}


-(UIView*)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor =  RGB(238, 238, 238, 1);
    }
    return _lineView;
}

-(UIButton*)goodsDetailsBtn{
    if (!_goodsDetailsBtn) {
        _goodsDetailsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _goodsDetailsBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f*kScale];
       // [_goodsDetailsBtn setTitleColor:RGB(236, 31, 35, 1) forState:0];
        [_goodsDetailsBtn setTitleColor:[UIColor blackColor] forState:0];

        _pingjiaDetailsBtn.tag = 0;

       // [_goodsDetailsBtn addTarget:self action:@selector(goodsDetailsBtnAction:) forControlEvents:1];
    }
    return _goodsDetailsBtn;
}


-(UIButton*)pingjiaDetailsBtn{
    if (!_pingjiaDetailsBtn) {
        _pingjiaDetailsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _pingjiaDetailsBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [_pingjiaDetailsBtn setTitleColor:[UIColor blackColor] forState:0];
        _pingjiaDetailsBtn.tag = 1;
        [_pingjiaDetailsBtn addTarget:self action:@selector(pingjiaDetailsBtnAction:) forControlEvents:1];


    }
    return _pingjiaDetailsBtn;
}

-(UIView*)lineleftView{
    if (!_lineleftView) {
        _lineleftView = [[UIView alloc] init];
        _lineleftView.backgroundColor = RGB(236, 31, 35, 1);
    }
    return _lineleftView;
}


-(UIView*)lineRightView{
    if (!_lineRightView) {
        _lineRightView = [[UIView alloc] init];
        _lineRightView.backgroundColor = RGB(238, 238, 238, 1);
    }
    return _lineRightView;
}





-(UILabel*)countryLab{
    if (!_countryLab) {
        _countryLab = [[UILabel alloc] init];
        _countryLab.font = [UIFont systemFontOfSize:12.0f];
        _countryLab.textColor = RGB(51 , 51, 51, 51);
        _countryLab.textAlignment = NSTextAlignmentLeft;
    }
    return _countryLab;
}

-(UILabel*)partLab{
    if (!_partLab) {
        _partLab = [[UILabel alloc] init];
        _partLab.font = [UIFont systemFontOfSize:12.0f];
        _partLab.textColor = RGB(51 , 51, 51, 51);
        _partLab.textAlignment = NSTextAlignmentLeft;
    }
    return _partLab;
}


-(UILabel*)standardsLab{
    if (!_standardsLab) {
        _standardsLab = [[UILabel alloc] init];
        _standardsLab.font = [UIFont systemFontOfSize:12.0f];
        _standardsLab.textColor = RGB(51 , 51, 51, 51);
        _standardsLab.textAlignment = NSTextAlignmentLeft;
    }
    return _standardsLab;
}



-(UILabel*)breedLab{
    if (!_breedLab) {
        _breedLab = [[UILabel alloc] init];
        _breedLab.font = [UIFont systemFontOfSize:12.0f];
        _breedLab.textColor = RGB(51 , 51, 51, 51);
        _breedLab.textAlignment = NSTextAlignmentLeft;
    }
    return _breedLab;
}

-(UILabel*)environmentLab{
    if (!_environmentLab) {
        _environmentLab = [[UILabel alloc] init];
        _environmentLab.font = [UIFont systemFontOfSize:12.0f];
        _environmentLab.textColor = RGB(51 , 51, 51, 51);
        _environmentLab.textAlignment = NSTextAlignmentLeft;
    }
    return _environmentLab;
}

-(UILabel*)brandLab{
    if (!_brandLab) {
        _brandLab = [[UILabel alloc] init];
        _brandLab.font = [UIFont systemFontOfSize:12.0f];
        _brandLab.textColor = RGB(51 , 51, 51, 51);
        _brandLab.textAlignment = NSTextAlignmentLeft;
    }
    return _brandLab;
}




-(void)goodsDetailsBtnAction:(UIButton*)btn{
    if ([self respondsToSelector:@selector(changeGoodsDetailsBlock)]) {
        [_goodsDetailsBtn setTitleColor:RGB(236, 31, 35, 1) forState:0];
        [_pingjiaDetailsBtn setTitleColor:[UIColor blackColor] forState:0];

        self.lineleftView.backgroundColor = RGB(236, 31, 35, 1);
        self.lineRightView.backgroundColor = RGB(238, 238, 238, 1);
        self.changeGoodsDetailsBlock();
       

    }
    
}


-(void)pingjiaDetailsBtnAction:(UIButton*)btn{
    
    if ([self respondsToSelector:@selector(changeCommentDetailsBlock)]) {
        [_goodsDetailsBtn setTitleColor:[UIColor blackColor] forState:0];
        [_pingjiaDetailsBtn setTitleColor:RGB(236, 31, 35, 1) forState:0];

        self.lineleftView.backgroundColor = RGB(238, 238, 238, 1);
        self.lineRightView.backgroundColor = RGB(236, 31, 35, 1);

        self.changeCommentDetailsBlock();
    }
    
    
}






/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
