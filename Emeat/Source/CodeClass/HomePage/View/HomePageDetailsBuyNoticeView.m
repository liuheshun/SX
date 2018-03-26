//
//  HomePageDetailsBuyNoticeView.m
//  Emeat
//
//  Created by liuheshun on 2018/1/17.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "HomePageDetailsBuyNoticeView.h"

@implementation HomePageDetailsBuyNoticeView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5f];
        
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.buyNoticeTieleLab];
        [self.bgView addSubview:self.descLab1];
        [self.bgView addSubview:self.descLab2];
        [self.bgView addSubview:self.cancleBtn];
        [self setMainViewFrame];
        
        self.buyNoticeTieleLab.text = @"购买说明";
        self.descLab1.text = @"·该商品为称重非标商品";
        self.descLab2.text = @"·我们会按照商品最大规格扣款，若您收到商品实际规格小于最大规格，我们会在您收到商品后，由系统退换差价给您";

       
        
        
    }
    return self;
}

// 展示弹窗
- (void)showBuyNotice
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    
    self.bgView.transform = CGAffineTransformMakeScale(1.21f, 1.21f);
    self.bgView.alpha = 0;
    
    [UIView animateWithDuration:1.0f delay:0.f usingSpringWithDamping:0.7f initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.bgView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        self.bgView.alpha = 1.0;
    } completion:nil];
}



// 点击其他区域关闭弹窗
- (void)handleTapBehind:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        CGPoint location = [sender locationInView:nil];
        
        if (![self.bgView pointInside:[self.bgView convertPoint:location fromView:self.bgView.window] withEvent:nil] || [self.cancleBtn pointInside:[self.cancleBtn convertPoint:location fromView:self.cancleBtn.window] withEvent:nil])
        {
            [self.bgView.window removeGestureRecognizer:sender];
            [self dismiss];
        }
        
        
        
    }
}

// 隐藏弹窗
- (void)dismiss {
    [UIView animateWithDuration:0.8f animations:^{
        self.bgView.transform = CGAffineTransformMakeScale(0.27f, 0.27f);
//        _bgView.alpha = 0;
//        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


//-(void)cancleBtnAction{
//    [UIView animateWithDuration:2.8f animations:^{
//        self.bgView.transform = CGAffineTransformMakeScale(0.27f, 0.27f);
//        //        _bgView.alpha = 0;
//        //        self.alpha = 0;
//    } completion:^(BOOL finished) {
//        [self removeFromSuperview];
//    }];
//    
//}

-(void)setMainViewFrame{
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.width.equalTo(@(kWidth));
        make.bottom.equalTo(self.mas_bottom).with.offset(-LL_TabbarSafeBottomMargin);
        make.height.equalTo(@195);
    }];
    
    [self.buyNoticeTieleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView);
        make.width.equalTo(@(kWidth));
        make.top.equalTo(self.bgView.mas_top).with.offset(30);
        make.height.equalTo(@15);
    }];
    [self.descLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).with.offset(15);
        make.right.equalTo(self.bgView.mas_right).with.offset(-15);
        make.top.equalTo(self.buyNoticeTieleLab.mas_bottom).with.offset(30);
        make.height.equalTo(@16);
    }];
    
    [self.descLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).with.offset(15);
        make.right.equalTo(self.bgView.mas_right).with.offset(-15);
        make.top.equalTo(self.descLab1.mas_bottom).with.offset(5);
        make.height.equalTo(@33);
    }];
    
    [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).with.offset(0);
        make.right.equalTo(self.bgView.mas_right).with.offset(0);
        make.bottom.equalTo(self.bgView.mas_bottom).with.offset(0);
        make.height.equalTo(@44);
    }];
    
    
    _recognizerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapBehind:)];
    [_recognizerTap setNumberOfTapsRequired:1];
    _recognizerTap.cancelsTouchesInView = NO;
    [self addGestureRecognizer:_recognizerTap];
    
}

-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor  whiteColor];
    }
    
    return _bgView;
}

-(UILabel *)buyNoticeTieleLab{
    if (!_buyNoticeTieleLab) {
        _buyNoticeTieleLab = [[UILabel alloc] init];
        _buyNoticeTieleLab.font = [UIFont systemFontOfSize:15.0f];
        _buyNoticeTieleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _buyNoticeTieleLab;
}

-(UILabel *)descLab1{
    if (!_descLab1) {
        _descLab1 = [[UILabel alloc] init];
        _descLab1.font = [UIFont systemFontOfSize:12.0f];
        _descLab1.textColor = RGB(51, 51, 51, 1);

    }
    return _descLab1;
}
-(UILabel *)descLab2{
    if (!_descLab2) {
        _descLab2 = [[UILabel alloc] init];
        _descLab2.font = [UIFont systemFontOfSize:12.0f];
        _descLab2.numberOfLines = 0;
        _descLab2.textColor = RGB(51, 51, 51, 1);
    }
    return _descLab2;
}

-(UIButton *)cancleBtn{
    if (!_cancleBtn) {
        _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancleBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [_cancleBtn setTitle:@"关闭" forState:0];
        _cancleBtn.backgroundColor = RGB(236, 31, 35, 1);
      //  [_cancleBtn addTarget:self action:@selector(cancleBtnAction) forControlEvents:1];
    }
    return _cancleBtn;
}


@end
