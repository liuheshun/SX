//
//  homePageHeadView.m
//  Emeat
//
//  Created by liuheshun on 2017/11/6.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import "homePageHeadView.h"

@implementation homePageHeadView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.recommendLab];
        [self setMainViewFrame];
    }
    return self;
}



//
//-(void)setMainView:(NSArray*)array{
//
//    for (int i = 0; i < array.count; i++) {
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.frame = CGRectMake(15*kScale+(kWidth - 30*kScale - 45 *(array.count))/(array.count-1) * i *kScale + 45*kScale*i, 16*kScale, 45*kScale, 67*kScale);
//
//        [btn setImage: [UIImage imageNamed:@"one"] forState:0];
//        [btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:10*kScale];
//        [btn setTitle:@"分类1" forState:0];
//        btn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
//        [btn setTitleColor:[UIColor blackColor] forState:0];
//        [self addSubview:btn];
//        self.classBtn = btn;
//    }
//
//
//    _recommendLab = [[UILabel alloc] initWithFrame:CGRectMake(15*kScale, MaxY(self.classBtn)+28*kScale, 200*kScale, 20*kScale)];
//    _recommendLab.font = [UIFont systemFontOfSize:15.0f];
//    _recommendLab.text =@"今日推荐";
//    [self addSubview:self.recommendLab];
//
//
//}

-(UILabel*)recommendLab{
    if (!_recommendLab) {
        _recommendLab = [[UILabel alloc] init];
        _recommendLab.font = [UIFont systemFontOfSize:15.0f*kScale];
        _recommendLab.text =@"今日推荐";
    }
    
    return _recommendLab;
}

-(void)setMainViewFrame{
    [self.recommendLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(10*kScale);
        make.top.equalTo(self.mas_top).with.offset(16*kScale);
        make.width.equalTo(@(200*kScale));
        make.height.equalTo(@(20*kScale));
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
