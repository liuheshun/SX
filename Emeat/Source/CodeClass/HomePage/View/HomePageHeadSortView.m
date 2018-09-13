//
//  HomePageHeadSortView.m
//  Emeat
//
//  Created by liuheshun on 2018/8/1.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "HomePageHeadSortView.h"

@implementation HomePageHeadSortView

-(instancetype)initWithFrame:(CGRect)frame{
    self= [super initWithFrame:frame];
    if (self) {
        
        
    }
    return self;
}


-(void)setHomePageSortUIButtions:(NSMutableArray*)BtnMarray{
//    [self.image removeFromSuperview];
//    [self.label removeFromSuperview];
//    for (UIView *v in self.sortBtn.subviews) {
//        [v removeFromSuperview];
//    }
    if (self.sortBtn) {
        for (int i = 0; i <BtnMarray.count; i++) {
            HomePageModel *model = BtnMarray[i];
            [self.image sd_setImageWithURL:[NSURL URLWithString:model.imageUrl]];
            self.label.text = model.classifyName;
            if (i==9) {
                self.image.image = [UIImage imageNamed:@"更多分类"];
            }
        }

    }else{
    for (int i = 0; i< BtnMarray.count; i++) {
        HomePageModel *model = BtnMarray[i];
        self.sortBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.sortBtn.frame = CGRectMake(10*kScale+63*i*kScale+(kWidth-20*kScale-63*5*kScale)/4*i, 25*kScale, 63*kScale, 63*kScale);
        [self addSubview:self.sortBtn];
        self.sortBtn.tag = i;
        if (i>4) {
            self.sortBtn.frame = CGRectMake(10*kScale+63*kScale*(i-5)+(kWidth-20*kScale-63*5*kScale)/4*(i-5), 100*kScale, 63*kScale, 63*kScale);
        }
        
       self.image = [[UIImageView alloc] initWithFrame:CGRectMake(10*kScale, 0, 44*kScale, 44*kScale)];
        [self.image sd_setImageWithURL:[NSURL URLWithString:model.imageUrl]];
        self.image.layer.cornerRadius = 22*kScale;
        self.image.layer.masksToBounds = YES;
        self.image.layer.borderColor = RGB(231, 35, 36, 1).CGColor;
        self.image.layer.borderWidth = 1;
        [self.sortBtn addSubview:self.image];
        
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 44*kScale, WIDTH(self.sortBtn), 20*kScale)];
        self.label.font = [UIFont systemFontOfSize:12.0f*kScale];
        self.label.textColor = RGB(136, 136, 136, 1);
        self.label.textAlignment = NSTextAlignmentCenter;
        [self.sortBtn addSubview:self.label];
        self.label.text = model.classifyName;
        
         [self.sortBtn addTarget:self action:@selector(sortBtnClickAction:) forControlEvents:1];
        if (i==9) {
            self.image.image = [UIImage imageNamed:@"更多分类"];
        }
    }
   
    }
    
}


-(void)sortBtnClickAction:(UIButton*)btn{
    if ([self respondsToSelector:@selector(returnClickSortIndex)]) {
        self.returnClickSortIndex(btn.tag, btn.titleLabel.text);
    }
}







@end
