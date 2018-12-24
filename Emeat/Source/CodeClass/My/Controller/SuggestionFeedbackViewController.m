//
//  SuggestionFeedbackViewController.m
//  Emeat
//
//  Created by liuheshun on 2017/12/22.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import "SuggestionFeedbackViewController.h"

@interface SuggestionFeedbackViewController ()<UITextViewDelegate>
@property(nonatomic,strong)UITextView *textView;
@property(nonatomic,strong)UILabel *placeHolderLabel;
@property(nonatomic,strong)UILabel *residueLabel;// 输入文本时剩余字数
@property (nonatomic,strong) NSString *conmmentString;

@end

@implementation SuggestionFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(238, 238, 238, 1);
    self.navItem.title = @"意见反馈";
    self.rightButtonTitle = @"提交";
    
    [self showNavBarItemRight];
    [self.view addSubview: self.textView];
    [self.textView addSubview:self.placeHolderLabel];
    [self.textView addSubview:self.residueLabel];
    
    [self setmainFrame];
    
    
}

-(void)rightItemAction{
    if (self.self.conmmentString.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入您的意见反馈"];
    }else{
    [self  postSuggestData];
    }
}

-(void)postSuggestData{
    [SVProgressHUD show];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *ticket = [user valueForKey:@"ticket"];
    NSString *secret = @"UHnyKzP5sNmh2EV0Dflgl4VfzbaWc4crQ7JElfw1cuNCbcJUau";
    NSString *nonce = [self ret32bitString];//随机数
    NSString *curTime = [self dateTransformToTimeSp];
    NSString *checkSum = [self sha1:[NSString stringWithFormat:@"%@%@%@" ,secret ,  nonce ,curTime]];
    
    [dic setValue:secret forKey:@"secret"];
    [dic setValue:nonce forKey:@"nonce"];
    [dic setValue:curTime forKey:@"curTime"];
    [dic setValue:checkSum forKey:@"checkSum"];
    [dic setValue:ticket forKey:@"ticket"];
    [dic setValue:[user valueForKey:@"userId"] forKey:@"id"];
    [dic setValue:self.conmmentString forKey:@"feedBack"];
    [dic setValue:mTypeIOS forKey:@"mtype"];
    
    [dic setValue:[user valueForKey:@"appVersionNumber"] forKey:@"appVersionNumber"];
    [dic setValue:[user valueForKey:@"user"] forKey:@"user"];
   
    
    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/m/auth/user/feedback", baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        
      
        if ([[returnData[@"status"] stringValue] isEqualToString:@"200"]) {
            
            
            [SVProgressHUD dismiss];
            [self.navigationController popViewControllerAnimated:YES];

         
            
        }else{
            SVProgressHUD.minimumDismissTimeInterval = 1;
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"请登录重试%@",returnData[@"code"]]];
        }
        
    } failureBlock:^(NSError *error) {
 

        [SVProgressHUD showErrorWithStatus:@"请稍后重试"];
        
    } showHUD:NO];
    
    
}



-(void)setmainFrame{
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).with.offset(-15*kScale);
        make.left.equalTo(self.view.mas_left).with.offset(15*kScale);
        
        make.top.equalTo(self.view.mas_top).with.offset(kBarHeight+15*kScale);
        make.height.equalTo(@(125*kScale));
    }];
    
    [self.placeHolderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.textView.mas_right).with.offset(-10*kScale);
        make.left.equalTo(self.textView.mas_left).with.offset(10*kScale);
        make.top.equalTo(self.textView.mas_top).with.offset(8*kScale);
        make.height.equalTo(@(15*kScale));
    }];
    
    [self.residueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).with.offset(-25*kScale);
        make.top.equalTo(self.view.mas_top).with.offset(110*kScale+kBarHeight+15*kScale);
        make.height.equalTo(@(13*kScale));
        make.width.equalTo(@(65*kScale));

    }];
    
}




-(UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc]init]; //初始化大小并自动释放
        _textView.textColor = [UIColor blackColor];//设置textview里面的字体颜色
        _textView.layer.borderColor = RGB(138, 138, 138, 1).CGColor;
        _textView.layer.borderWidth = 0.5;
        _textView.font = [UIFont fontWithName:@"Arial" size:15.0];//设置字体名字和字体大小
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
        _placeHolderLabel = [[UILabel alloc] init];
        _placeHolderLabel.numberOfLines = 0;
        _placeHolderLabel.font = [UIFont systemFontOfSize:12.0f*kScale];
        _placeHolderLabel.text = @"请输入你的反馈意见...";
        _placeHolderLabel.textColor = RGB(136, 136, 136, 1);
        _placeHolderLabel.backgroundColor =[UIColor clearColor];
        
    }
    return _placeHolderLabel;
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



-(void)textViewDidChange:(UITextView *)textView

{
    if([textView.text length] == 0){
        self.placeHolderLabel.text = @"请输入你的反馈意见...";
    }else{
        self.placeHolderLabel.text = @"";//这里给空
    }
    //计算剩余字数   不需要的也可不写
    NSString *nsTextCotent = textView.text;
    NSInteger existTextNum = [nsTextCotent length];
    NSInteger remainTextNum = 140 - existTextNum;
    self.residueLabel.text = [NSString stringWithFormat:@"%ld/140",remainTextNum];
    self.conmmentString = textView.text;
    
}




//设置超出最大字数（140字）即不可输入 也是textview的代理方法
-(BOOL)textView:(UITextView*)textView shouldChangeTextInRange:(NSRange)range
replacementText:(NSString*)text
{
    NSString *str = [NSString stringWithFormat:@"%@%@", textView.text, text];
    
    if (str.length > 140)
    {
        NSRange rangeIndex = [str rangeOfComposedCharacterSequenceAtIndex:140];
        self.placeHolderLabel.text = @"";//这里给空
        
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
