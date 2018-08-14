//
//  FeedBackView.m
//  Emeat
//
//  Created by liuheshun on 2018/8/8.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "FeedBackView.h"
#import "HWPopTool.h"
@implementation FeedBackView


//- (instancetype)init
//{
//    if (self = [super init]) {
////        //点击半透明背景使界面自动消失
////        [MMPopupWindow sharedWindow].touchWildToHide = YES;
////        //设置类型
////        self.type = MMPopupTypeCustom;
////
//        //设置尺寸,self只需设置宽高,会根据类型来确定在屏幕中的位置
//#//请使用Masonry相关方法来设置宽高，否则会有问题
//        [self mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_equalTo(315*kScale);
//            make.height.mas_equalTo(250*kScale);
//            make.centerX.equalTo(self);
//            make.centerY.equalTo(self);
//        }];
//        self.backgroundColor = [UIColor whiteColor];
//        self.layer.cornerRadius = 10;
//        self.layer.masksToBounds = YES;
//        //使用[self addSubview:subview];来添加其他控件
//        [self addSubview:self.titleLabBtn];
//        [self addSubview:self.textView];
//        [self addSubview:self.submitBtn];
//        [self addSubview:self.cancelBtn];
//        [self setMainFrame];
//    }
//    return self;
//}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleLabBtn];
        [self addSubview:self.textView];
        [self addSubview:self.submitBtn];
        [self addSubview:self.cancelBtn];
        [self setMainFrame];
    }
    return self;
}

-(void)setMainFrame{
    [self.titleLabBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.right.equalTo(self);
        make.height.equalTo(@(55*kScale));
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15*kScale);
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.top.equalTo(self.titleLabBtn.mas_bottom).with.offset(0);
        make.height.equalTo(@(110*kScale));
    }];
    
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_bottom).with.offset(15*kScale);
        make.left.equalTo(self.mas_left).with.offset(15*kScale);
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.height.equalTo(@(40*kScale));
    }];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.right.equalTo(self);
        make.width.height.equalTo(@(40*kScale));
    }];
    
}

-(UIButton *)titleLabBtn{
    if (_titleLabBtn == nil) {
        _titleLabBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _titleLabBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f*kScale];
        [_titleLabBtn setTitleColor:RGB(51, 51, 51, 1) forState:0];
        [_titleLabBtn setTitle:@"你想买点啥" forState:0];
    }
    return _titleLabBtn;
}

-(UITextView *)textView{
    if (_textView == nil) {
        _textView = [[UITextView alloc] init];
        _textView.textColor = RGB(51, 51, 51, 1);
        _textView.font = [UIFont systemFontOfSize:12.0f*kScale];
        _textView.backgroundColor = RGB(244, 244, 244, 244);
        _textView.delegate = self;
        
    }
    return _textView;
}


-(UIButton *)submitBtn{
    if (_submitBtn == nil) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f*kScale];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:0];
        [_submitBtn setTitle:@"提交" forState:0];
        _submitBtn.layer.cornerRadius = 5;
        _submitBtn.layer.masksToBounds = YES;
        _submitBtn.backgroundColor = RGB(220, 220, 220, 1);
        self.submitBtn.userInteractionEnabled = NO;

    }
    return _submitBtn;
}


-(UIButton *)cancelBtn{
    if (_cancelBtn == nil) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setImage:[UIImage imageNamed:@"取消"] forState:0];
        [_cancelBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:1];
    }
    return _cancelBtn;
}

-(void)textViewDidChange:(UITextView *)textView{
    DLog(@"textView ===== %@" ,textView.text);
    if (textView.text.length == 0) {
        self.submitBtn.userInteractionEnabled = NO;
        _submitBtn.backgroundColor = RGB(220, 220, 220, 1);

    }else{
    
        self.submitBtn.userInteractionEnabled = YES;
        _submitBtn.backgroundColor = RGB(231, 35, 35, 1);

    }
}


-(void)cancelBtnAction{
   
    [[HWPopTool sharedInstance] closeWithBlcok:^{
        
        
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
