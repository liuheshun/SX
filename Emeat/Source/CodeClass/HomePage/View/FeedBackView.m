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



-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleLabBtn];
        [self addSubview:self.textView];
        [self.textView addSubview:self.residueLabel];
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
    
    
    [self.residueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-23*kScale);
        make.top.equalTo(self.mas_top).with.offset(147*kScale);
        make.width.equalTo(@(60*kScale));
        make.height.equalTo(@(15*kScale));
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



-(UILabel *)residueLabel{
    if (!_residueLabel) {
        
        //多余的一步不需要的可以不写  计算textview的输入字数
        _residueLabel = [[UILabel alloc] init];
        _residueLabel.backgroundColor = [UIColor clearColor];
        _residueLabel.font = [UIFont fontWithName:@"Arial" size:12.0f*kScale];
        _residueLabel.text =[NSString stringWithFormat:@"140/140"];
        _residueLabel.textColor = [[UIColor grayColor]colorWithAlphaComponent:0.5];
        _residueLabel.textAlignment = NSTextAlignmentRight;
        
        
    }
    return _residueLabel;
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
    if (textView.text.length == 0) {
        self.submitBtn.userInteractionEnabled = NO;
        _submitBtn.backgroundColor = RGB(220, 220, 220, 1);

    }else{
    
        self.submitBtn.userInteractionEnabled = YES;
        _submitBtn.backgroundColor = RGB(231, 35, 35, 1);
    }
 
    //计算剩余字数   不需要的也可不写
    NSString *nsTextCotent = textView.text;
    NSInteger existTextNum = [nsTextCotent length];
    NSInteger remainTextNum = 140 - existTextNum;
    self.residueLabel.text = [NSString stringWithFormat:@"%ld/140",remainTextNum];
    self.conmmentString = textView.text;
    
    
}


-(void)cancelBtnAction{
   
    [[HWPopTool sharedInstance] closeWithBlcok:^{
        
        
    }];
}








//设置超出最大字数（140字）即不可输入 也是textview的代理方法
-(BOOL)textView:(UITextView*)textView shouldChangeTextInRange:(NSRange)range
replacementText:(NSString*)text
{
    NSString *str = [NSString stringWithFormat:@"%@%@", textView.text, text];
    
    if (str.length > 140)
    {
        NSRange rangeIndex = [str rangeOfComposedCharacterSequenceAtIndex:140];
        
        if (rangeIndex.length == 1)//字数超限
        {
            textView.text = [str substringToIndex:140];
            //这里重新统计下字数，字数超限，我发现就不走textViewDidChange方法了，你若不统计字数，忽略这行
            self.residueLabel.text = [NSString stringWithFormat:@"%lu/%d", 140-(unsigned long)textView.text.length, 140];
        }else{
            NSRange rangeRange = [str rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 140)];
            textView.text = [str substringWithRange:rangeRange];
        }
        return NO;
    }
    
    
    if ([text isEqualToString:@"\n"]) {//这里"\n"对应的是键盘的 return 回收键盘之用
        
        [textView resignFirstResponder];
        
        return YES;
    }
    
    if (range.location >= 140){
        
        
        return  NO;
    }else{
        return YES;
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
