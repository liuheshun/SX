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
        [self addSubview:self.sendImageBtn];
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
    
    [self.sendImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commentsTextView.mas_bottom).with.offset(15*kScale);
        make.left.equalTo(self.mas_left).with.offset(15*kScale);
        make.height.width.equalTo(@(60*kScale));
    }];
    
}

-(void)setPingJiaStar{
    
    self.starMarray = [NSMutableArray array];
    for (int i = 0; i<5; i++ ) {
        UIButton *pingjiaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [self addSubview:pingjiaBtn];
        
        [pingjiaBtn setImage:[UIImage imageNamed:@"bigstart_no_sel"] forState:0];
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
    if (btn.selected == NO) {
        for (int i = 0; i <= btn.tag; i++) {
            UIButton *pingjiaBtn = [self.starMarray objectAtIndex:i];
            
            [pingjiaBtn setImage:[UIImage imageNamed:@"bigstart_sel"] forState:0];
            
            pingjiaBtn.selected = YES;
            
        }
        
    }else if (btn.selected == YES) {
        
        for (int i = (int)btn.tag; i < self.starMarray.count; i++) {
            UIButton *pingjiaBtn = [self.starMarray objectAtIndex:i];
            
            [pingjiaBtn setImage:[UIImage imageNamed:@"bigstart_no_sel"] forState:0];
            
            pingjiaBtn.selected = NO;
            
        }
        
    }
    
    //self.selectStarCounts(btn.tag+1);
    
    
}


-(void)setCommentsLab{
    
    NSMutableArray *labMarray = [NSMutableArray arrayWithObjects:@"口感很好",@"口感很好",@"口感很好",@"口感很好",@"口感很好",@"口感很好",@"口感很好",@"口感很好", nil];
    
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

-(void)commentsBtnAction:(UIButton*)btn{
    
    if (btn.selected == YES) {
    
        btn.backgroundColor = RGB(220, 220, 220, 1);
        btn.selected = NO;
    }else{
       
        btn.backgroundColor = RGB(251,100,35, 1);
        btn.selected = YES;
    }
    
}


-(UITextView *)commentsTextView{
    if (_commentsTextView == nil) {
        _commentsTextView = [[UITextView alloc] init];
        _commentsTextView.layer.borderColor = RGB(220, 220, 220, 1).CGColor;
        _commentsTextView.layer.borderWidth = 0.5;
        _commentsTextView.toolbarPlaceholder = @"说说哪里满意,帮助大家选择";
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



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
