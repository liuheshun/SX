//
//  OrderCommentsTableViewCell.m
//  Emeat
//
//  Created by liuheshun on 2018/10/11.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "OrderCommentsTableViewCell.h"

@implementation OrderCommentsTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.commentsPlaceholderLab];
        [self addSubview:self.commentsTextView];
        [self.commentsTextView addSubview:self.residueLabel];

        [self addSubview:self.sendImageBtn];
        [self addSubview:self.sendImageBtn2];
        [self addSubview:self.sendImageBtn3];
        [self.sendImageBtn addSubview:self.deleteImvBtn];
        [self.sendImageBtn2 addSubview:self.deleteImvBtn2];
        [self.sendImageBtn3 addSubview:self.deleteImvBtn3];

        

        [self setMainFrame];
    }
    return self;
}



-(UILabel *)commentsPlaceholderLab{
    if (_commentsPlaceholderLab == nil) {
        _commentsPlaceholderLab = [[UILabel alloc] init];
        _commentsPlaceholderLab.text = @"评价";
        _commentsPlaceholderLab.textColor = RGB(51, 51, 51, 1);
        _commentsPlaceholderLab.font = [UIFont systemFontOfSize:17.0f*kScale];
    }
    return _commentsPlaceholderLab;
}

-(void)setMainFrame{
    
    [self.commentsPlaceholderLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).with.offset(15*kScale);
        make.top.equalTo(self.mas_top).with.offset(16*kScale);
        make.width.equalTo(@(35*kScale));
        make.height.equalTo(@(17*kScale));
    }];
    
    [self setPingJiaStar];
    [self setCommentsLab];
    
    [self.commentsTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commentsLabBtn.mas_bottom).with.offset(20*kScale);
        make.left.equalTo(self.mas_left).with.offset(15*kScale);
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.height.equalTo(@(90*kScale));
        
    }];
    [self.commentsTextView addSubview:self.placeHolderLabel];
    
    [self.residueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-25*kScale);
        make.width.equalTo(@(60*kScale));
        make.bottom.equalTo(self.commentsLabBtn.mas_bottom).with.offset(110*kScale);
        make.height.equalTo(@(13*kScale));
    }];
    
    
    
    [self.sendImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commentsTextView.mas_bottom).with.offset(15*kScale);
        make.left.equalTo(self.mas_left).with.offset(15*kScale);
        make.height.width.equalTo(@(60*kScale));
    }];
    
    [self.sendImageBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commentsTextView.mas_bottom).with.offset(15*kScale);
        make.left.equalTo(self.sendImageBtn.mas_right).with.offset(15*kScale);
        make.height.width.equalTo(@(60*kScale));
    }];
    [self.sendImageBtn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commentsTextView.mas_bottom).with.offset(15*kScale);
        make.left.equalTo(self.sendImageBtn2.mas_right).with.offset(15*kScale);
        make.height.width.equalTo(@(60*kScale));
    }];
    
    
    [self.deleteImvBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sendImageBtn.mas_top).with.offset(0*kScale);
        make.right.equalTo(self.sendImageBtn.mas_right).with.offset(0*kScale);
        make.height.width.equalTo(@(20*kScale));
    }];
    
    
    [self.deleteImvBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sendImageBtn2.mas_top).with.offset(0*kScale);
        make.right.equalTo(self.sendImageBtn2.mas_right).with.offset(0*kScale);
        make.height.width.equalTo(@(20*kScale));
    }];
    [self.deleteImvBtn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sendImageBtn3.mas_top).with.offset(0*kScale);
        make.right.equalTo(self.sendImageBtn3.mas_right).with.offset(0*kScale);
        make.height.width.equalTo(@(20*kScale));
    }];
}



-(void)setPingJiaStar{
    
    self.starMarray = [NSMutableArray array];
    for (int i = 0; i<5; i++ ) {
        UIButton *pingjiaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [self addSubview:pingjiaBtn];
        //if (i == 0) {
            [pingjiaBtn setImage:[UIImage imageNamed:@"bigstart_sel"] forState:0];

//        }else{
//        [pingjiaBtn setImage:[UIImage imageNamed:@"bigstart_no_sel"] forState:0];
//        }
        [pingjiaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
          
            make.centerY.equalTo(self.commentsPlaceholderLab.mas_centerY);
            make.height.width.equalTo(@(30*kScale));
            make.left.equalTo(self.commentsPlaceholderLab.mas_right).with.offset((20*kScale + 40*kScale * i));
            
            pingjiaBtn.tag = i;
        }];
        
        
        [self.starMarray addObject:pingjiaBtn];
        [pingjiaBtn addTarget:self action:@selector(pingjiaBtnAction:) forControlEvents:1];
        
    }
}


-(void)pingjiaBtnAction:(UIButton*)btn{
    
    DLog(@"评价");
    // 从左往右遍历每个小星星
    NSInteger startCount = 0;
    if (btn.selected == NO) {
        for (int i = 0; i <= btn.tag; i++) {
            UIButton *pingjiaBtn = [self.starMarray objectAtIndex:i];
            
            [pingjiaBtn setImage:[UIImage imageNamed:@"bigstart_sel"] forState:0];
            
            pingjiaBtn.selected = YES;
            
        }
        startCount = btn.tag + 1;
        
    }else if (btn.selected == YES) {
        
        for (int i = (int)btn.tag; i < self.starMarray.count; i++) {
            
            UIButton *pingjiaBtn = [self.starMarray objectAtIndex:i];
            if (i == 0) {
                [pingjiaBtn setImage:[UIImage imageNamed:@"bigstart_sel"] forState:0];
                startCount = btn.tag + 1;

                
            }else{
            
                [pingjiaBtn setImage:[UIImage imageNamed:@"bigstart_no_sel"] forState:0];
                startCount = btn.tag;

            }
            if (btn.tag == 0) {
                startCount = btn.tag + 1;

            }
            pingjiaBtn.selected = NO;
            
        }
        
    }
    
    //self.selectStarCounts(btn.tag+1);
    
    self.returnCommentsStarts([NSString stringWithFormat:@"%ld" ,(long)startCount]);
}


-(void)setCommentsLab{
    
    NSMutableArray *labMarray = [NSMutableArray arrayWithObjects:@"口感很棒",@"价格便宜",@"配送快",@"服务态度好",@"包装精美",@"正关行货",@"质量上乘",@"原切优品", nil];
    
    self.selectCommentsLabelsMarray  = [NSMutableArray arrayWithObjects:@"口感很棒",@"价格便宜", nil];
    for (int i = 0; i<labMarray.count; i++ ) {
        UIButton *commentsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        commentsBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f*kScale];
        [commentsBtn setTitle:labMarray[i] forState:0];
       

        [self addSubview:commentsBtn];
        if (i == 0 || i == 1) {
             commentsBtn.backgroundColor = RGB(251,100,35, 1);
            commentsBtn.selected = YES;
        }else{
             commentsBtn.backgroundColor = RGB(220, 220, 220, 1);
        }
        
        [commentsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            if (i < 4) {
                make.top.equalTo(self.commentsPlaceholderLab.mas_bottom).with.offset(20*kScale);
                make.width.equalTo(@(65*kScale)); make.left.equalTo(self.mas_left).with.offset((15*kScale + 75*kScale * i));


            }else{
                make.top.equalTo(self.commentsPlaceholderLab.mas_bottom).with.offset(50*kScale);
                make.width.equalTo(@(65*kScale)); make.left.equalTo(self.mas_left).with.offset((15*kScale + 75*kScale * (i-4)));

            }
            
            
            make.height.equalTo(@(20*kScale));
            
            commentsBtn.tag = i;
            self.commentsLabBtn = commentsBtn;
        }];
        
        //[self.starMarray addObject:pingjiaBtn];
        [commentsBtn addTarget:self action:@selector(commentsBtnAction:) forControlEvents:1];
        
    }
    
}

#pragma mark=====标签选中

-(void)commentsBtnAction:(UIButton*)btn{

    if (btn.selected == YES) {
    
        btn.backgroundColor = RGB(220, 220, 220, 1);
        btn.selected = NO;
        [self.selectCommentsLabelsMarray removeObject:btn.titleLabel.text];
    }else{
       
        btn.backgroundColor = RGB(251,100,35, 1);
        btn.selected = YES;
        
        [self.selectCommentsLabelsMarray addObject:btn.titleLabel.text];
        
    }
    DLog(@"bbbbbbbb=== %@" ,self.selectCommentsLabelsMarray);
    NSString *string = [self.selectCommentsLabelsMarray componentsJoinedByString:@","];
    

    self.returnCommentsLabels(string);
    //self.returnCommentsLabels(@"s");
}


-(UITextView *)commentsTextView{
    if (_commentsTextView == nil) {
        _commentsTextView = [[UITextView alloc] init];
        _commentsTextView.layer.borderColor = RGB(220, 220, 220, 1).CGColor;
        _commentsTextView.layer.borderWidth = 0.5;
        _commentsTextView.delegate = self;
        _commentsTextView.font = [UIFont systemFontOfSize:12.0f*kScale];
    }
    return _commentsTextView;
}


-(UIButton *)sendImageBtn{
    if (_sendImageBtn == nil) {
        _sendImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_sendImageBtn setImage:[UIImage imageNamed:@"上传照片"] forState:0];
    }
    return _sendImageBtn;
}



-(UIButton *)sendImageBtn2{
    if (_sendImageBtn2 == nil) {
        _sendImageBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        
    }
    return _sendImageBtn2;
}
-(UIButton *)sendImageBtn3{
    if (_sendImageBtn3 == nil) {
        _sendImageBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
        
    }
    return _sendImageBtn3;
}







-(UIButton *)deleteImvBtn{
    if (_deleteImvBtn == nil) {
        _deleteImvBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
//        [_deleteImvBtn setImage:[UIImage imageNamed:@"评价删除"] forState:0];
    }
    return _deleteImvBtn;
}


-(UIButton *)deleteImvBtn2{
    if (_deleteImvBtn2 == nil) {
        _deleteImvBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        
//        [_deleteImvBtn2 setImage:[UIImage imageNamed:@"评价删除"] forState:0];
    }
    return _deleteImvBtn2;
}

-(UIButton *)deleteImvBtn3{
    if (_deleteImvBtn3 == nil) {
        _deleteImvBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
        
//        [_deleteImvBtn3 setImage:[UIImage imageNamed:@"评价删除"] forState:0];
    }
    return _deleteImvBtn3;
}







-(UILabel *)placeHolderLabel{
    if (!_placeHolderLabel) {
        _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10*kScale, 8*kScale, 240*kScale, 20*kScale)];
        _placeHolderLabel.numberOfLines = 0;
        _placeHolderLabel.font = [UIFont systemFontOfSize:12.0f*kScale];
        _placeHolderLabel.text = @"说说哪里满意,帮助大家选择";
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
        _residueLabel.text =[NSString stringWithFormat:@"0/300"];
        _residueLabel.textColor = [[UIColor grayColor]colorWithAlphaComponent:0.5];
        _residueLabel.textAlignment = NSTextAlignmentRight;
        
        
    }
    return _residueLabel;
}



-(void)textViewDidChange:(UITextView *)textView

{
    if([textView.text length] == 0){
        self.placeHolderLabel.text = @"说说哪里满意,帮助大家选择";;
    }else{
        self.placeHolderLabel.text = @"";//这里给空
    }
    //计算剩余字数   不需要的也可不写
    NSString *nsTextCotent = textView.text;
    NSInteger existTextNum = [nsTextCotent length];
    NSInteger remainTextNum = 300 - existTextNum;
    self.residueLabel.text = [NSString stringWithFormat:@"%ld/300",(long)existTextNum];
    self.conmmentString = textView.text;
    
}




//设置超出最大字数（140字）即不可输入 也是textview的代理方法
-(BOOL)textView:(UITextView*)textView shouldChangeTextInRange:(NSRange)range
replacementText:(NSString*)text
{
    
    NSString *str = [NSString stringWithFormat:@"%@%@", textView.text, text];
    
    if (str.length > 300)
    {
        NSRange rangeIndex = [str rangeOfComposedCharacterSequenceAtIndex:300];
        self.placeHolderLabel.text = @"";//这里给空

        if (rangeIndex.length == 1)//字数超限
        {
            textView.text = [str substringToIndex:300];
            //这里重新统计下字数，字数超限，我发现就不走textViewDidChange方法了，你若不统计字数，忽略这行
            self.residueLabel.text = [NSString stringWithFormat:@"%lu/%d", (unsigned long)textView.text.length, 300];
        }else{
            NSRange rangeRange = [str rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 300)];
            textView.text = [str substringWithRange:rangeRange];
        }
        return NO;
    }
    
    
    if ([text isEqualToString:@"\n"]) {//这里"\n"对应的是键盘的 return 回收键盘之用
        
        [textView resignFirstResponder];
        
        return YES;
    }
    
    if (range.location >= 300){


        return  NO;
    }else{
        return YES;
    }
    
}





- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
