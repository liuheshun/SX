//
//  CancelOrderReasonBottomView.m
//  Emeat
//
//  Created by liuheshun on 2018/11/15.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "CancelOrderReasonBottomView.h"

@implementation CancelOrderReasonBottomView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.cancelBtn];
        [self addSubview:self.confirmBtn];
        [self setMainFrame];
        
    }
    return self;
}

-(void)isShowOtherReason:(NSInteger)isShow{
    
    if (isShow == 0) {
        [self.textView removeFromSuperview];
        [self.placeHolderLabel removeFromSuperview];
        [self.residueLabel removeFromSuperview];

        
    }else if (isShow == 1){
        
        
        [self addSubview: self.textView];
        [self.textView addSubview:self.placeHolderLabel];
        [self.textView addSubview:self.residueLabel];
        
        
    }
    
}


-(UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(15*kScale, 10*kScale, WIDTH(self)-30*kScale, 81*kScale)]; //初始化大小并自动释放
        
        _textView.textColor = RGB(138, 138, 138, 1);//设置textview里面的字体颜色
        _textView.layer.borderColor = RGB(138, 138, 138, 1).CGColor;
        _textView.layer.borderWidth = 0.5;
        _textView.font = [UIFont fontWithName:@"Arial" size:12.0];//设置字体名字和字体大小
        
        _textView.delegate = self;//设置它的委托方法
        
        _textView.backgroundColor = [UIColor whiteColor];//设置它的背景颜色
        
        _textView.returnKeyType = UIReturnKeyDefault;//返回键的类型
        
        _textView.keyboardType = UIKeyboardTypeDefault;//键盘类型
        
        _textView.scrollEnabled = YES;//是否可以拖动
        
        _textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
        
    }
    return _textView;
}


-(UILabel *)placeHolderLabel{
    if (!_placeHolderLabel) {
        _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10*kScale, 8*kScale, 240*kScale, 20*kScale)];
        _placeHolderLabel.numberOfLines = 0;
        _placeHolderLabel.font = [UIFont systemFontOfSize:12.0f*kScale];
        _placeHolderLabel.text = @"请填写其它取消订单的原因";
        _placeHolderLabel.textColor = RGB(136, 136, 136, 1);
        _placeHolderLabel.backgroundColor =[UIColor clearColor];
        
    }
    return _placeHolderLabel;
}


-(UILabel *)residueLabel{
    if (!_residueLabel) {
        
        //多余的一步不需要的可以不写  计算textview的输入字数
        _residueLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH(self.textView)-73*kScale, HEIGHT(self.textView)-30*kScale, 70*kScale, 30*kScale)];
        _residueLabel.backgroundColor = [UIColor clearColor];
        _residueLabel.font = [UIFont fontWithName:@"Arial" size:12.0f];
        _residueLabel.text =[NSString stringWithFormat:@"0/120"];
        _residueLabel.textColor = [[UIColor grayColor]colorWithAlphaComponent:0.5];
        _residueLabel.textAlignment = NSTextAlignmentRight;
        
        
    }
    return _residueLabel;
}



-(void)textViewDidChange:(UITextView *)textView

{
    if([textView.text length] == 0){
        self.placeHolderLabel.text = @"请填写其它取消订单的原因";
    }else{
        self.placeHolderLabel.text = @"";//这里给空
    }
    //计算剩余字数   不需要的也可不写
    NSString *nsTextCotent = textView.text;
    NSInteger existTextNum = [nsTextCotent length];
    NSInteger remainTextNum = 140 - existTextNum;
    self.residueLabel.text = [NSString stringWithFormat:@"%ld/120",existTextNum];
    self.conmmentString = textView.text;
    
}




//设置超出最大字数（140字）即不可输入 也是textview的代理方法
-(BOOL)textView:(UITextView*)textView shouldChangeTextInRange:(NSRange)range
replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {//这里"\n"对应的是键盘的 return 回收键盘之用
        
        [textView resignFirstResponder];
        
        return YES;
    }
    NSString *str = [NSString stringWithFormat:@"%@%@", textView.text, text];
    if([str length] == 0){
        self.placeHolderLabel.text = @"请填写其它取消订单的原因";
    }else{
        self.placeHolderLabel.text = @"";//这里给空
    }

    if (str.length > 120)
    {
        NSRange rangeIndex = [str rangeOfComposedCharacterSequenceAtIndex:120];
        
        if (rangeIndex.length == 1)//字数超限
        {
            textView.text = [str substringToIndex:120];
            //这里重新统计下字数，字数超限，我发现就不走textViewDidChange方法了，你若不统计字数，忽略这行
            self.residueLabel.text = [NSString stringWithFormat:@"%lu/%d", (unsigned long)textView.text.length, 120];
        }else{
            NSRange rangeRange = [str rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 120)];
            textView.text = [str substringWithRange:rangeRange];
        }
        return NO;
    }
    return YES;
    
   
    
}



-(void)setMainFrame{
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15*kScale);
        make.bottom.equalTo(self.mas_bottom).with.offset(-15*kScale);
        make.height.equalTo(@(40*kScale));
        make.width.equalTo(@(145*kScale));
        
    }];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.bottom.equalTo(self.mas_bottom).with.offset(-15*kScale);
        make.height.equalTo(@(40*kScale));
        make.width.equalTo(@(145*kScale));
        
    }];
}


-(UIButton *)cancelBtn{
    if (_cancelBtn == nil) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.layer.borderColor = RGB(231, 35, 36, 1).CGColor;
        _cancelBtn.layer.borderWidth = 1;
        _cancelBtn.backgroundColor = [UIColor whiteColor];
        [_cancelBtn setTitle:@"取消" forState:0];
        [_cancelBtn setTitleColor:RGB(231, 35, 36, 1) forState:0];
        _cancelBtn.titleLabel.font =  [UIFont systemFontOfSize:15.0f*kScale];
        _cancelBtn.layer.cornerRadius = 5;
        _cancelBtn.layer.masksToBounds = YES;
    }
    return _cancelBtn;
}

-(UIButton *)confirmBtn{
    if (_confirmBtn == nil) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _confirmBtn.layer.borderColor = RGB(231, 35, 36, 1).CGColor;
//        _confirmBtn.layer.borderWidth = 1;
        _confirmBtn.backgroundColor = RGB(231, 35, 36, 1);
        [_confirmBtn setTitle:@"确认" forState:0];
        [_confirmBtn setTitleColor:[UIColor whiteColor] forState:0];
        _confirmBtn.titleLabel.font =  [UIFont systemFontOfSize:15.0f*kScale];
        _confirmBtn.layer.cornerRadius = 5;
        _confirmBtn.layer.masksToBounds = YES;
    }
    return _confirmBtn;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
