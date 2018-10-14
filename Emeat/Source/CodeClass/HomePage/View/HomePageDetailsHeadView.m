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
        [self addSubview:self.nameLab];
        [self addSubview:self.descLab];
        [self addSubview:self.newspriceBtnLab];
        [self addSubview:self.oldspriceBtnLab];
        [self addSubview:self.weightLab];
        [self addSubview:self.noticeBtn];
        [self addSubview:self.lineView];
        //[self addSubview:self.goodsDetailsBtn];
        
        //[self addSubview:self.pingjiaDetailsBtn];
        //[self addSubview:self.lineleftView];
        //[self addSubview:self.lineRightView];
//        [self addSubview:self.countryLab];
//        [self addSubview:self.partLab];
//        [self addSubview:self.standardsLab];
//        [self addSubview:self.breedLab];
//        [self addSubview:self.environmentLab];
//        [self addSubview:self.brandLab];
//
        [self setMainViewFrame];
    }
    return self;
}



-(void)configHeadViewWithModel:(HomePageModel*)model{
    
    self.nameLab.text = model.commodityName;
    self.descLab.text = model.commodityDesc;
    CGFloat hDesc =   [GetWidthAndHeightOfString getHeightForText:self.descLab width:(kWidth-30*kScale)];
    
    [self.descLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(hDesc));
    }];
   
    UIView*lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 7*kScale, 20*kScale, 1)];
    lineView.backgroundColor = RGB(136, 136, 136, 1);
    if (model.discountPrice == -1) {///只显示原价
        [lineView removeFromSuperview];
    }else{
        [self.oldspriceBtnLab addSubview:lineView];
        
    }
    
    if ([model.showType isEqualToString:@"SOGO"]){///b
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        
        if ([[user valueForKey:@"approve"] isEqualToString:@"1"]) {
            ///商户认证通过可看到价格可购买
            
            if ([model.priceTypes isEqualToString:@"WEIGHT"]) {
                if (model.discountPrice == -1) {///只显示原价
                    
                    [self.newspriceBtnLab setTitle:[NSString stringWithFormat:@"%.2f元/kg",(float)model.costPrice/100] forState:0];
                    [self.oldspriceBtnLab setTitle:@"" forState:0];

                }else{
                    [self.newspriceBtnLab setTitle:[NSString stringWithFormat:@"%.2f元/kg",(float)model.unitPrice/100] forState:0];
                    [self.oldspriceBtnLab setTitle:[NSString stringWithFormat:@"%.2f元/kg",(float)model.costPrice/100] forState:0];
                }
                
                
                
            }else{
                if (model.discountPrice == -1) {///只显示原价
                    
                    [self.newspriceBtnLab setTitle:[NSString stringWithFormat:@"%.2f元/件",(float)model.costPrice/100] forState:0];
                    [self.oldspriceBtnLab setTitle:@"" forState:0];

                }else{
                    [self.newspriceBtnLab setTitle:[NSString stringWithFormat:@"%.2f元/件",(float)model.unitPrice/100] forState:0];
                    [self.oldspriceBtnLab setTitle:[NSString stringWithFormat:@"%.2f元/件",(float)model.costPrice/100] forState:0];
                    
                }
                
            }
            
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.newspriceBtnLab.titleLabel.text];
            NSRange range1 = [[str string] rangeOfString:[NSString stringWithFormat:@"%.2f" ,(float)model.unitPrice/100]];
            [str addAttribute:NSForegroundColorAttributeName value:RGB(236, 31, 35, 1) range:range1];
            
            [self.newspriceBtnLab setAttributedTitle:str forState:UIControlStateNormal];
            
            
            
            
        }else if ([[user valueForKey:@"approve"] isEqualToString:@"0"] || [[user valueForKey:@"approve"] isEqualToString:@"2"]){
            
            
            if (model.discountPrice == -1) {///只显示原价
                
                [self.newspriceBtnLab setTitleColor:RGB(231, 35, 36, 1) forState:0];
                [self.newspriceBtnLab setTitle:@"查看价格" forState:0];
                [self.oldspriceBtnLab setTitle:@"" forState:0];

            }else{
                ///商户未认证或者认证未通过
                [self.newspriceBtnLab setTitleColor:RGB(231, 35, 36, 1) forState:0];
                [self.newspriceBtnLab setTitle:@"查看价格" forState:0];
                [self.oldspriceBtnLab setTitle:@"原价" forState:0];
                
            }
            
        }
        
            
        [self.goodsDetailsBtn setTitle:@"商品详情" forState:0];
        self.weightLab.text =[NSString stringWithFormat:@"非标商品默认按该规格下最大重量: %@计价后返差",model.size2] ;

    }else{///C端商品
        ///个人专区
        if (model.discountPrice == -1) {///只显示原价
            
            [self.newspriceBtnLab setTitle:[NSString stringWithFormat:@"%.2f元",(float)model.costPrice/100] forState:0];
            [self.oldspriceBtnLab setTitle:@"" forState:0];

        }else{
            
            [self.newspriceBtnLab setTitle:[NSString stringWithFormat:@"%.2f元",(float)model.unitPrice/100] forState:0];
            [self.oldspriceBtnLab setTitle:[NSString stringWithFormat:@"%.2f元",(float)model.costPrice/100] forState:0];
            
        }
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.newspriceBtnLab.titleLabel.text];
        NSRange range1 = [[str string] rangeOfString:[NSString stringWithFormat:@"%.2f元" ,(float)model.unitPrice/100]];
        [str addAttribute:NSForegroundColorAttributeName value:RGB(236, 31, 35, 1) range:range1];
        
        
        [self.newspriceBtnLab setAttributedTitle:str forState:UIControlStateNormal];
        
        
        [self.noticeBtn removeFromSuperview];
        [self.weightLab removeFromSuperview];
        
        [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self);
            make.top.equalTo(self.moreSpecificationsBgView.mas_bottom).with.offset(20*kScale);
            make.height.equalTo(@(10*kScale));
            
        }];
        
        
        
        
      
    }
    

//    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.newspriceBtnLab.titleLabel.text];
//    NSRange range1 = [[str string] rangeOfString:[NSString stringWithFormat:@"%.2f" ,(float)model.unitPrice/100]];
//    [str addAttribute:NSForegroundColorAttributeName value:RGB(236, 31, 35, 1) range:range1];
//
//    [self.newspriceBtnLab setAttributedTitle:str forState:UIControlStateNormal];

//
//    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:self.oldspriceBtnLab.titleLabel.text];
//    NSRange range2 = [[str2 string] rangeOfString:[NSString stringWithFormat:@"%.2f" ,(float)model.costPrice/100]];
//    [str2 addAttribute:NSForegroundColorAttributeName value:RGB(236, 31, 35, 1) range:range2];
//
//    [self.oldspriceBtnLab setAttributedTitle:str2 forState:UIControlStateNormal];
    
    
    ///
    [self.newspriceBtnLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@([self getOldPricesWidthText:self.newspriceBtnLab heights:20*kScale fontSizes:17*kScale]));
    }];
    [self.oldspriceBtnLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@([self getOldPricesWidthText:self.oldspriceBtnLab heights:20*kScale fontSizes:17*kScale]));
        
    }];
    
    CGRect rectlineView = lineView.frame;
    rectlineView.size.width = [self getOldPricesWidthText:self.oldspriceBtnLab heights:20*kScale fontSizes:17*kScale];
    lineView.frame = rectlineView;
    
    
    
    
//    CGRect moreSpecificationsBtnRect = self.moreSpecificationsBgView.frame;
//    moreSpecificationsBtnRect.origin.y = 408+hDesc;
//    self.moreSpecificationsBgView.frame = moreSpecificationsBtnRect;
//
    [self.moreSpecificationsBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.newspriceBtnLab.mas_bottom).with.offset(10*kScale);
    }];
    
    
    
    CGFloat wPrice =   [GetWidthAndHeightOfString getWidthForText:self.weightLab height:20*kScale] +5*kScale;
    [self.weightLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(wPrice));
    }];
    
    
   
    
    
    
    //[self.pingjiaDetailsBtn setTitle:@"评价详情" forState:0];
    NSString *tempString;
    if ([model.isMeal isEqualToString:@"1"]) {
        [self.goodsDetailsBtn setTitle:@"套餐详情" forState:0];
        tempString = @"等";
    }else{
        [self.goodsDetailsBtn setTitle:@"商品详情" forState:0];
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
    model.headViewHeight = (426+55+150-13)*kScale+hDesc;
   
    
}



#pragma mark ========计算原价宽度

-(CGFloat)getOldPricesWidthText:(UIButton*)button heights:(CGFloat)heights fontSizes:(CGFloat)fontSizes{
    
    CGSize size=CGSizeMake(MAXFLOAT, heights);
    UIFont *font=[UIFont systemFontOfSize:fontSizes];
    NSDictionary *attrs=@{NSFontAttributeName:font};
    CGSize s=[button.titleLabel.text boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine |
              
              NSStringDrawingUsesLineFragmentOrigin |
              
              NSStringDrawingUsesFontLeading attributes:attrs context:nil].size;
    
    return s.width+5*kScale;
    
}

-(void)moreSpecificationsBtnAction:(UIButton*)btn{
    if ([self respondsToSelector:@selector(returnSelectIndex)]) {
       
        btn.selected = !btn.selected;
       
        if (btn.selected == YES) {
            self.moreSpecificationsBtn.layer.borderColor = RGB(236, 31, 35, 1).CGColor;
            self.moreSpecificationsBtn.layer.borderWidth = 1;
            self.moreSpecificationslabel1.textColor =  RGB(236, 31, 35, 1);
            self.moreSpecificationslabel2.textColor =  RGB(236, 31, 35, 1);
        }else{
            self.moreSpecificationslabel1.textColor =  RGB(136, 136, 136, 1);
            self.moreSpecificationslabel2.textColor =  RGB(136, 136, 136, 1);
            self.moreSpecificationsBtn.layer.borderColor = RGB(191, 191, 191, 1).CGColor;
            self.moreSpecificationsBtn.layer.borderWidth = 1;

        }
        self.returnSelectIndex(btn.tag);
    }
}



-(void)setMainViewFrame{
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15*kScale);
        make.top.equalTo(self.mas_top).with.offset(330*kScale);
        make.width.equalTo(@(kWidth -30*kScale));
        make.height.equalTo(@(17*kScale));
    }];
    
    [self.descLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15*kScale);
        make.top.equalTo(self.nameLab.mas_bottom).with.offset(10*kScale);
        make.width.equalTo(@(kWidth -30*kScale));
        make.height.equalTo(@(13*kScale));
    }];
    
    ////
    
    [self.newspriceBtnLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15*kScale);
        make.top.equalTo(self.descLab.mas_bottom).with.offset(10*kScale);
        make.width.equalTo(@(120*kScale));
        make.height.equalTo(@(20*kScale));
    }];
    
    [self.oldspriceBtnLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.newspriceBtnLab.mas_right).with.offset(5*kScale);
        make.top.equalTo(self.descLab.mas_bottom).with.offset(10*kScale);
        make.width.equalTo(@(120*kScale));
        make.height.equalTo(@(20*kScale));
    }];
    
    self.moreSpecificationsBgView = [[UIView alloc] init];
    [self addSubview:self.moreSpecificationsBgView];
    [self.moreSpecificationsBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(0*kScale);
        make.top.equalTo(self.newspriceBtnLab.mas_bottom).with.offset(10*kScale);
        make.width.equalTo(@(kWidth));
        make.height.equalTo(@(40*kScale));
    }];
    
    
    NSInteger arrayCount = [GlobalHelper shareInstance].specsListMarray.count ;
    if ([GlobalHelper shareInstance].specsListMarray.count >6) {
        arrayCount = 6;
    }
    
    UIButton *firstBtn = nil;
    UIButton *secondBtn = nil;
    NSInteger isfirst = 0;
    for (int i = 0; i < arrayCount; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.moreSpecificationsBgView addSubview:btn];

        HomePageModel *model = [GlobalHelper shareInstance].specsListMarray[i];
        
        [btn setTitle:model.specs forState:0];
        btn.tag = i;

        CGFloat btw = [self getOldPricesWidthText:btn heights:40*kScale fontSizes:11.0f*kScale];
        //DLog(@"bbb ==== %f        ccc== %f" ,MaxX(firstBtn) ,kWidth-15*kScale);

    
//        if (MaxX(firstBtn) <kWidth-15*kScale) {
        
        
            if (i == 0) {
                btn.frame = CGRectMake(15*kScale, 0, btw, 40*kScale);
                firstBtn = btn;
       
            }else{
                btn.frame = CGRectMake(MaxX(firstBtn)+15*kScale, 0, btw, 40*kScale);
                
                firstBtn = btn;
                if (secondBtn == nil) {
                    
                }else{
                    btn.frame = CGRectMake(MaxX(secondBtn)+15*kScale, 50*kScale, btw, 40*kScale);
                    secondBtn = btn;
                    isfirst = 50*kScale;
                }
                
                if (MaxX(firstBtn) >kWidth-15*kScale) {
                    
                    btn.frame = CGRectMake(15*kScale, 50*kScale, btw, 40*kScale);
                    secondBtn = btn;
                    
                }
            
        
            }
   

        btn.backgroundColor = [UIColor whiteColor];
        [btn addTarget:self action:@selector(moreSpecificationsBtnAction:) forControlEvents:1];

//        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 3*kScale, WIDTH(btn), HEIGHT(btn)/2-3*kScale)];
//        [btn addSubview:label1];
//
//        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, HEIGHT(btn)/2, WIDTH(btn), HEIGHT(btn)/2)];
//        [btn addSubview:label2];
//        label1.font = [UIFont systemFontOfSize:10.0f*kScale];
//        label2.font = [UIFont systemFontOfSize:10.0f*kScale];
//        label1.textAlignment = NSTextAlignmentCenter;
//        label2.textAlignment = NSTextAlignmentCenter;
//        label1.textColor =  RGB(136, 136, 136, 1);
//        label2.textColor =  RGB(136, 136, 136, 1);
        btn.layer.borderColor = RGB(191, 191, 191, 1).CGColor;
        btn.layer.borderWidth = 1;
        //btn.titleLabel.numberOfLines = 0;
        
        
//        HomePageModel *model = [GlobalHelper shareInstance].specsListMarray[i];
        //3.分隔字符串
        //NSString *string = model.specs;
       
        [btn setTitleColor:RGB(136, 136, 136, 1) forState:0];
        btn.titleLabel.font = [UIFont systemFontOfSize:11.0f*kScale];
//        if ([model.isMeal isEqualToString:@"1"]) {
//            label1.text = @"组合";
//            label2.text = @"套餐";
//
//        }else{
//            NSArray *array = [string componentsSeparatedByString:@"/"]; //从字符A中分隔成2个元素的数组
//            label1.text =[NSString stringWithFormat:@"%@/" ,[array firstObject]];
//            label2.text = [NSString stringWithFormat:@"%@" ,[array lastObject]];
      //  }
       
       
        if (model.commodityId == [[GlobalHelper shareInstance].homePageDetailsId integerValue]) {
            btn.userInteractionEnabled = NO;
            btn.layer.borderColor = RGB(236, 31, 35, 1).CGColor;
            btn.layer.borderWidth = 1;
            [btn setTitleColor:RGB(236, 31, 35, 1) forState:0];

//            label1.textColor =  RGB(236, 31, 35, 1);
//            label2.textColor =  RGB(236, 31, 35, 1);
        }
        
        self.moreSpecificationsBtn = btn;
//        self.moreSpecificationslabel1 = label1;
//        self.moreSpecificationslabel2 = label2;
    }
    
   
    [self.moreSpecificationsBgView mas_updateConstraints:^(MASConstraintMaker *make) {
       
        make.height.equalTo(@(40*kScale + isfirst));
    }];
    
    
    [self.weightLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15*kScale);
        make.top.equalTo(self.moreSpecificationsBtn.mas_bottom).with.offset(15*kScale);
        make.width.equalTo(@(65*kScale));
        make.height.equalTo(@(20*kScale));
    }];
    
    [self.noticeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.weightLab.mas_right).with.offset(-5*kScale);
        make.top.equalTo(self.moreSpecificationsBtn.mas_bottom).with.offset(5*kScale);
        make.width.equalTo(@(40*kScale));
        make.height.equalTo(@(40*kScale));
    }];
    
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self);
        make.top.equalTo(self.weightLab.mas_bottom).with.offset(20*kScale);
        make.height.equalTo(@(10*kScale));

    }];
    
//    [self.goodsDetailsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self);
//        make.top.equalTo(self.lineView.mas_bottom).with.offset(0);
//        //make.top.equalTo(self.weightLab.mas_bottom).with.offset(25);
//       // make.width.equalTo(@(kWidth/2));
//        make.width.equalTo(@(kWidth));
//
//        make.height.equalTo(@(45*kScale));
//    }];
    
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
    
//    [self.countryLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left).with.offset(15*kScale);
//        make.top.equalTo(self.goodsDetailsBtn.mas_bottom).with.offset(10*kScale);
//        make.width.equalTo(@((kWidth/2-15)*kScale));
//        make.height.equalTo(@(12*kScale));
//    }];
//    
//    [self.partLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
//        make.top.equalTo(self.countryLab);
//        make.width.equalTo(@((kWidth/2-15)*kScale));
//        make.height.equalTo(@(12*kScale));
//    }];
//    
//    
//    [self.standardsLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left).with.offset(15*kScale);
//        make.top.equalTo(self.countryLab.mas_bottom).with.offset(15*kScale);
//        make.width.equalTo(@((kWidth/2-15)*kScale));
//        make.height.equalTo(@(12*kScale));
//    }];
//    
//    [self.breedLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
//        make.top.equalTo(self.partLab.mas_bottom).with.offset(15*kScale);
//        make.width.equalTo(@((kWidth/2-15)*kScale));
//        make.height.equalTo(@(12*kScale));
//    }];
//    
//    
//    [self.environmentLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left).with.offset(15*kScale);
//        make.top.equalTo(self.standardsLab.mas_bottom).with.offset(15*kScale);
//        make.width.equalTo(@((kWidth/2-15)*kScale));
//        make.height.equalTo(@(12*kScale));
//    }];
//    
//    [self.brandLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
//        make.top.equalTo(self.breedLab.mas_bottom).with.offset(15*kScale);
//        make.width.equalTo(@((kWidth/2-15)*kScale));
//        make.height.equalTo(@(12*kScale));
//    }];
//    
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

-(UIButton*)newspriceBtnLab{
    if (!_newspriceBtnLab) {
        _newspriceBtnLab = [UIButton buttonWithType:UIButtonTypeCustom];
        _newspriceBtnLab.titleLabel.font = [UIFont systemFontOfSize:17.0f*kScale];
        [_newspriceBtnLab setTitleColor:RGB(136, 136, 136, 1) forState:0];
        _newspriceBtnLab.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentLeft;
    }
    return _newspriceBtnLab;
}

-(UIButton*)oldspriceBtnLab{
    if (!_oldspriceBtnLab) {
        _oldspriceBtnLab = [UIButton buttonWithType:UIButtonTypeCustom];
        _oldspriceBtnLab.titleLabel.font = [UIFont systemFontOfSize:17.0f*kScale];
        [_oldspriceBtnLab setTitleColor:RGB(136, 136, 136, 1) forState:0];
        _oldspriceBtnLab.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentCenter;
    }
    return _oldspriceBtnLab;
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




//
//-(UILabel*)countryLab{
//    if (!_countryLab) {
//        _countryLab = [[UILabel alloc] init];
//        _countryLab.font = [UIFont systemFontOfSize:12.0f];
//        _countryLab.textColor = RGB(51 , 51, 51, 51);
//        _countryLab.textAlignment = NSTextAlignmentLeft;
//    }
//    return _countryLab;
//}
//
//-(UILabel*)partLab{
//    if (!_partLab) {
//        _partLab = [[UILabel alloc] init];
//        _partLab.font = [UIFont systemFontOfSize:12.0f];
//        _partLab.textColor = RGB(51 , 51, 51, 51);
//        _partLab.textAlignment = NSTextAlignmentLeft;
//    }
//    return _partLab;
//}
//
//
//-(UILabel*)standardsLab{
//    if (!_standardsLab) {
//        _standardsLab = [[UILabel alloc] init];
//        _standardsLab.font = [UIFont systemFontOfSize:12.0f];
//        _standardsLab.textColor = RGB(51 , 51, 51, 51);
//        _standardsLab.textAlignment = NSTextAlignmentLeft;
//    }
//    return _standardsLab;
//}
//
//
//
//-(UILabel*)breedLab{
//    if (!_breedLab) {
//        _breedLab = [[UILabel alloc] init];
//        _breedLab.font = [UIFont systemFontOfSize:12.0f];
//        _breedLab.textColor = RGB(51 , 51, 51, 51);
//        _breedLab.textAlignment = NSTextAlignmentLeft;
//    }
//    return _breedLab;
//}
//
//-(UILabel*)environmentLab{
//    if (!_environmentLab) {
//        _environmentLab = [[UILabel alloc] init];
//        _environmentLab.font = [UIFont systemFontOfSize:12.0f];
//        _environmentLab.textColor = RGB(51 , 51, 51, 51);
//        _environmentLab.textAlignment = NSTextAlignmentLeft;
//    }
//    return _environmentLab;
//}
//
//-(UILabel*)brandLab{
//    if (!_brandLab) {
//        _brandLab = [[UILabel alloc] init];
//        _brandLab.font = [UIFont systemFontOfSize:12.0f];
//        _brandLab.textColor = RGB(51 , 51, 51, 51);
//        _brandLab.textAlignment = NSTextAlignmentLeft;
//    }
//    return _brandLab;
//}




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
