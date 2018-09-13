//
//  YouLikeCollectionHeadView.m
//  Emeat
//
//  Created by liuheshun on 2017/11/17.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import "YouLikeCollectionHeadView.h"

@implementation YouLikeCollectionHeadView


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.topShadeView];
        [self addSubview:self.titleLab];
        [self addSubview:self.leftLineView];
        [self addSubview:self.rightLineView];
        [self setMainViewFrame];
    }
    return self;
}

-(UIView*)topShadeView{
    if (!_topShadeView) {
        _topShadeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 10*kScale)];
        _topShadeView.backgroundColor = RGB(238, 238, 238, 1);
    }
    return _topShadeView;
}

-(UILabel*)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = [UIFont systemFontOfSize:15.0f*kScale];
        _titleLab.textColor = RGB(138, 138, 138, 1);
        _titleLab.textAlignment = NSTextAlignmentCenter;
        
    }
    return _titleLab;
}

-(UIView*)leftLineView{
    if (!_leftLineView) {
        _leftLineView = [[UIView alloc] init];
        _leftLineView.backgroundColor = RGB(138, 138, 138, 1);
        
    }
    return _leftLineView;
}

-(UIView*)rightLineView{
    if (!_rightLineView) {
        _rightLineView = [[UIView alloc] init];
        _rightLineView.backgroundColor = RGB(138, 138, 138, 1);
        
    }
    return _rightLineView;
}

-(void)setMainViewFrame{
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
       // make.left.equalTo(self).offset(10);
        make.top.equalTo(self.topShadeView.mas_bottom).offset(10*kScale);
        make.height.equalTo(@(15*kScale));
        make.width.equalTo(@(80*kScale));
        make.left.equalTo(@((kWidth-80*kScale)/2));
    }];
    
    [self.leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.titleLab.mas_left).offset(-10*kScale);
       // make.top.equalTo(self.topShadeView.mas_bottom).offset(10);
        make.height.equalTo(@(1*kScale));
        make.width.equalTo(@(75*kScale));
        make.centerY.equalTo(self.titleLab);
    }];
    
    
    [self.rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLab.mas_right).offset(10);
        //make.top.equalTo(self.topShadeView.mas_bottom).offset(10);
        make.height.equalTo(@(1*kScale));
        make.width.equalTo(@(75*kScale));
        make.centerY.equalTo(self.titleLab);
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
