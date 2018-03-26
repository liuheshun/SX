//
//  ConfirmOrderCommentViewController.m
//  Emeat
//
//  Created by liuheshun on 2017/11/10.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import "ConfirmOrderCommentViewController.h"

@interface ConfirmOrderCommentViewController ()<UITextViewDelegate>
@property(nonatomic,strong)UITextView *textView;
@property(nonatomic,strong)UILabel *placeHolderLabel;
@property(nonatomic,strong)UILabel *residueLabel;// 输入文本时剩余字数
@end

@implementation ConfirmOrderCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(238, 238, 238, 1);
    self.navItem.title = @"订单备注";
    self.rightButtonTitle = @"完成";

    [self showNavBarItemRight];
    [self.view addSubview: self.textView];
    [self.textView addSubview:self.placeHolderLabel];
    [self.textView addSubview:self.residueLabel];
    
  
}

-(void)rightItemAction{
    if ([self respondsToSelector:@selector(conmmentStringBlcok)]) {
        if (self.conmmentString.length == 0)
        {
//            SVProgressHUD.minimumDismissTimeInterval = 0.5;
//            SVProgressHUD.maximumDismissTimeInterval = 1;
//
//            [SVProgressHUD showImage:[UIImage imageNamed:@"02"] status:@"请填写备注"];
        }else{
            
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setValue:self.conmmentString forKey:@"conmmentString"];
            self.conmmentStringBlcok(self.conmmentString);
            [self.navigationController popViewControllerAnimated:YES];

        }
    }
}



-(UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(15, kBarHeight+15, kWidth-30, 120)]; //初始化大小并自动释放
        
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
        _textView.text = self.conmmentString;
    }
    
  
    return _textView;
}


-(UILabel *)placeHolderLabel{
    if (!_placeHolderLabel) {
        _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 200, 20)];
        _placeHolderLabel.numberOfLines = 0;
        _placeHolderLabel.font = [UIFont systemFontOfSize:12.0f];
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        if ([[user valueForKey:@"conmmentString"] length] != 0) {
            _placeHolderLabel.text = @"";

        }else{
            _placeHolderLabel.text = @"请输入你的订单备注";

        }
        _placeHolderLabel.textColor = RGB(136, 136, 136, 1);
        _placeHolderLabel.backgroundColor =[UIColor clearColor];
        
    }
    return _placeHolderLabel;
}


-(UILabel *)residueLabel{
    if (!_residueLabel) {
        
        //多余的一步不需要的可以不写  计算textview的输入字数
        _residueLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH(self.textView)-73, HEIGHT(self.textView)-30, 70, 30)];
        _residueLabel.backgroundColor = [UIColor clearColor];
        _residueLabel.font = [UIFont fontWithName:@"Arial" size:12.0f];
        _residueLabel.text =[NSString stringWithFormat:@"140/140"];
        _residueLabel.textColor = [[UIColor grayColor]colorWithAlphaComponent:0.5];
        _residueLabel.textAlignment = NSTextAlignmentRight;
        

    }
    return _residueLabel;
}



-(void)textViewDidChange:(UITextView *)textView

{
    if([textView.text length] == 0){
        self.placeHolderLabel.text = @"请输入你的订单备注";
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
