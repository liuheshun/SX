//
//  CardView.m
//  仿陌陌点点切换
//
//  Created by zjwang on 16/3/28.
//  Copyright © 2016年 Xsummerybc. All rights reserved.
//

#import "CardView.h"

@implementation CardView
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    // Shadow
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.33;
    self.layer.shadowOffset = CGSizeMake(0, 1.5);
    self.layer.shadowRadius = 4.0;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    // Corner Radius
    self.layer.cornerRadius = 10.0;
    
   
    // Custom view
    [self addSubview:self.imageView];
    _imageView.frame = CGRectMake(12*kScale, 12*kScale, self.frame.size.width -24*kScale, 165*kScale);
    _imageView.backgroundColor = [UIColor whiteColor];
    _imageView.layer.borderColor = RGB(231, 35, 36, 1).CGColor;
    _imageView.layer.borderWidth = 1;
    
    [self addSubview:self.labelTitle];
    _labelTitle.frame = CGRectMake(24*kScale, MaxY(_imageView)+15*kScale, 180*kScale, 15*kScale);
    _labelTitle.font = [UIFont systemFontOfSize:15.0f*kScale];
    _labelTitle.textColor = RGB(51, 51, 51, 1);
    
  
    [self addSubview:self.labelNewPrices];
    _labelNewPrices.frame = CGRectMake(24*kScale, MaxY(_labelTitle)+15*kScale, 60*kScale, 12*kScale);
    _labelNewPrices.font = [UIFont systemFontOfSize:12.0f*kScale];
    _labelNewPrices.textColor = RGB(231, 35, 36, 1);
    
    
    [self addSubview:self.labelOldPrices];
    _labelOldPrices.frame = CGRectMake(MaxX(_labelNewPrices)+10*kScale, MaxY(_labelTitle)+15*kScale, 60*kScale, 12*kScale);
    _labelOldPrices.font = [UIFont systemFontOfSize:12.0f*kScale];
    _labelOldPrices.textColor = RGB(136, 136, 136, 1);
    

    [self addSubview:self.addShoppingCardBtn];
    _addShoppingCardBtn.frame = CGRectMake(self.frame.size.width-30, MaxY(_imageView)+5*kScale, 40*kScale, 40*kScale);
    [_addShoppingCardBtn setImage:[UIImage imageNamed:@"搜索页购物车图标"] forState:0];
    
    
      
}


//-(void)setLabelsFrameWithArray:(NSMutableArray*)array{
//    for (int i = 0; i <array.count; i++) {
//
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 35*kScale+26*kScale*i, 80*kScale, 18*kScale)];
//        label.backgroundColor = RGB(0, 0, 0, 0.4);
//        label.font = [UIFont systemFontOfSize:10.0f];
//        label.textColor = [UIColor whiteColor];
//        label.text = [NSString stringWithFormat:@"  %@",array[i]];
//
//        [self.imageView addSubview:label];
//        self.labels = label;
//        self.labels.tag = i;
//        CGSize labelSize =  [label sizeThatFits:CGSizeMake(MAXFLOAT, HEIGHT(label))];
//        CGRect rect = label.frame;
//        rect.size.width = labelSize.width+5*kScale;
//        label.frame = rect;
//
//        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:label.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(10,10)];
//        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//        maskLayer.frame = label.bounds;
//        maskLayer.path = maskPath.CGPath;
//        label.layer.mask = maskLayer;
//
//
//    }
//
//}


//-(void)configDataWithModel:(ZhiKuListModel*)model{
//    
//    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.logo1]];
//    self.labelTitle.text = model.name;
//    self.introductionLab.text = model.introqyjb;
//
//    if (model.advUrl.length==0) {
//
//        self.lableJob.text = [NSString stringWithFormat:@"%@%@",model.companyName,model.job];
//    
//        CGSize labelTitleSize =  [self.labelTitle sizeThatFits:CGSizeMake(MAXFLOAT, HEIGHT(self.labelTitle))];
//        CGRect rect = self.labelTitle.frame;
//        
//        rect.size.width = labelTitleSize.width;
//        self.labelTitle.frame = rect;
//        
//        CGRect rectJob =self.lableJob.frame;
//        rectJob.origin.x = MaxX(self.labelTitle)+10*kScale;
//        rectJob.size.width = 204*kScale -rectJob.origin.x;
//        self.lableJob.frame = rectJob;
//        
//
//        
//    if (model.expertType == 1) {
//        [self.rightLabels setTitle:@"智享家" forState:0];
//    }else if (model.expertType == 2){
//        [self.rightLabels setTitle:@"咨询师" forState:0];
//    }
//    
//     
//    
//        
//    }else{//有广告 特殊处理
//        
//        [self.inviteBtn removeFromSuperview];
//        [self.rightLabels setBackgroundImage:[UIImage imageNamed:@" "] forState:0];
//        [self.rightLabels setTitle:@"" forState:0];
//        
//        CGSize labelTitleSize =  [self.labelTitle sizeThatFits:CGSizeMake(MAXFLOAT, HEIGHT(self.labelTitle))];
//        CGRect rect = self.labelTitle.frame;
//        if (labelTitleSize.width > WIDTH(self.imageView)) {
//            labelTitleSize.width = WIDTH(self.imageView);
//        }
//        rect.size.width = labelTitleSize.width;
//        self.labelTitle.frame = rect;
//       
//        }
//    
//    
//    
//
//    
//    
//    CGSize introduceSize =  [self.introductionLab sizeThatFits:CGSizeMake(WIDTH(self)-48*kScale, MAXFLOAT)];
//    if (kHeight == 568) {
//        if (introduceSize.height >100*kScale) {
//            introduceSize.height = 100*kScale;
//        }
//        
//    }else{
//        if (introduceSize.height >115*kScale) {
//            introduceSize.height = 115*kScale;
//        }
//    }
//    CGRect rectIntro = self.introductionLab.frame;
//    rectIntro.size.height = introduceSize.height;
//    self.introductionLab.frame = rectIntro;
//    //    self.introductionLab.backgroundColor = [UIColor cyanColor];
//    
//    ///
//    UILabel *tempLab = [[UILabel alloc] initWithFrame:CGRectMake(15*kScale, 0, kWidth-30*kScale, 18*kScale)];
//    tempLab.font = [UIFont systemFontOfSize:12.0f*kScale];
//    tempLab.textColor = RGB(102, 102, 102, 1);
//    tempLab.numberOfLines = 0;
//    tempLab.text = model.introqyjb;
//    
//    CGSize introduceSize1 =  [tempLab sizeThatFits:CGSizeMake(kWidth-30*kScale, MAXFLOAT)];
//    model.introduceHeight = introduceSize1.height;
//    
//}
//


- (UIImageView *)imageView
{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        
    }
    return _imageView;
}



- (UILabel *)labelTitle
{
    if (_labelTitle == nil) {
        _labelTitle = [[UILabel alloc] init];
    }
    return _labelTitle;
}


- (UILabel *)labelNewPrices
{
    if (_labelNewPrices == nil) {
        _labelNewPrices = [[UILabel alloc] init];
    }
    return _labelNewPrices;
}


- (UILabel *)labelOldPrices
{
    if (_labelOldPrices == nil) {
        _labelOldPrices = [[UILabel alloc] init];
    }
    return _labelOldPrices;
}



-(UIButton *)addShoppingCardBtn{
    if (_addShoppingCardBtn == nil) {
        _addShoppingCardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _addShoppingCardBtn;
}


@end
