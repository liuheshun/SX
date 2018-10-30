//
//  HomePageCommentDetailsTableViewCell.m
//  Emeat
//
//  Created by liuheshun on 2017/11/21.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import "HomePageCommentDetailsTableViewCell.h"

@implementation HomePageCommentDetailsTableViewCell
{
    MASConstraint *_masHeight;

}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
        [self addSubview:self.commentUserImv];
        [self addSubview:self.commentNameLab];
        [self addSubview:self.commentTimeLab];
        [self addSubview:self.goodsLab];
        [self addSubview:self.commentDetailsLab];
        [self addSubview:self.isFoldingBtn];
        [self setMainFrame];
    }
    return self;
}

-(void)configWithModel:(HomePageCommentsModel*)model{

    if (model.headPic.length == 0) {
        _commentUserImv.image = [UIImage imageNamed:@"user_imv"];
    }else{
        [_commentUserImv sd_setImageWithURL:[NSURL URLWithString:model.headPic] placeholderImage:[UIImage imageNamed:@"user_imv"]];
    }
    _commentUserImv.backgroundColor = [UIColor redColor];
    _commentNameLab.text = model.nickname;
    _commentTimeLab.text = model.evaluationDate;
    _commentDetailsLab.text = model.evaluationDetail;
    
    
    CGSize r = [model.evaluationDetail boundingRectWithSize:CGSizeMake(kWidth-30*kScale, 1000*kScale) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.0f*kScale]} context:nil].size;
    NSArray *imageMarray = @[];
    if (model.picture.length != 0) {
        imageMarray = [model.picture componentsSeparatedByString:@","];
    }
    self.commentsImageArray = [NSArray arrayWithArray:imageMarray];
    
    NSArray *labelsMarray = @[];
    if (model.evaluationTable.length != 0) {
        labelsMarray = [model.evaluationTable componentsSeparatedByString:@","];
    }
//    NSArray *starsMarray = [model.evaluationStar componentsSeparatedByString:@","];


    DLog(@"rrrr======================%f" ,r.height);
    
    
    for (int i = 0; i < 5; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i < [model.evaluationStar integerValue]) {
            [btn setImage:[UIImage imageNamed:@"haoping"] forState:0];
            
        }else{
            [btn setImage:[UIImage imageNamed:@"pingjia"] forState:0];
        }
        [self addSubview:btn];
        self.goodsStarBtn = btn;
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.goodsLab.mas_right).with.offset(5*kScale+20*i*kScale);
            make.top.equalTo(self.goodsLab).with.offset(0);
            make.width.and.height.equalTo(@(15*kScale));
        }];
    }
    
    
    
        for (int i= 0; i<labelsMarray.count; i++) {
    
                UIButton *commentsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                commentsBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f*kScale];
                [commentsBtn setTitle:labelsMarray[i] forState:0];
    
            [self addSubview:commentsBtn];
            commentsBtn.backgroundColor = RGB(251,100,35, 1);
            commentsBtn.selected = YES;
    
            [commentsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    
                if (i < 4) {
                        make.top.equalTo(self.commentUserImv.mas_bottom).with.offset(10*kScale);
                        make.width.equalTo(@(65*kScale)); make.left.equalTo(self.mas_left).with.offset((15*kScale + 75*kScale * i));
    
    
                    }else{
                        make.top.equalTo(self.commentUserImv.mas_bottom).with.offset(40*kScale);
                        make.width.equalTo(@(65*kScale)); make.left.equalTo(self.mas_left).with.offset((15*kScale + 75*kScale * (i-4)));
    
                    }
    
    
                    make.height.equalTo(@(20*kScale));
    
                    commentsBtn.tag = i;
                    self.commentsLabBtn = commentsBtn;
                }];
    
    
        }
    

    
    
    ////cell是否折叠显示
    
    if (model.unfold) {
        //_contentLabel.numberOfLines = 0;
        [self.isFoldingBtn setTitle:@"收起" forState:0];

        [_masHeight uninstall];
        [self.commentDetailsLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            //_masHeight = make.height.lessThanOrEqualTo(@(45*kScale));
           
            if (imageMarray.count == 0 && r.height >43) {
                make.bottom.equalTo(self.mas_bottom).with.offset(-30*kScale);
                
            }else if (imageMarray.count != 0 && r.height >43){
                make.bottom.equalTo(self.mas_bottom).with.offset(-145*kScale);
                
            }else if (imageMarray.count == 0 && r.height <= 43){
                make.bottom.equalTo(self.mas_bottom).with.offset(-15*kScale);
                
            }
            else{
                make.bottom.equalTo(self.mas_bottom).with.offset(-120*kScale);
                
            }
            
            
            
            if (labelsMarray.count == 0) {//无标签
             make.top.equalTo(self.commentUserImv.mas_bottom).with.offset(10*kScale);

            }else{
              make.top.equalTo(self.commentsLabBtn.mas_bottom).with.offset(10*kScale);
            }
            make.left.equalTo(self.commentUserImv);
            make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        }];
    } else {
        [_masHeight install];
        [self.isFoldingBtn setTitle:@"展开" forState:0];

        //_contentLabel.numberOfLines = 3;
        [self.commentDetailsLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            _masHeight = make.height.lessThanOrEqualTo(@(45*kScale));
            
            if (imageMarray.count == 0 && r.height >43) {
                make.bottom.equalTo(self.mas_bottom).with.offset(-30*kScale);

            }else if (imageMarray.count != 0 && r.height >43){
                make.bottom.equalTo(self.mas_bottom).with.offset(-145*kScale);

            }else if (imageMarray.count == 0 && r.height <= 43){
                make.bottom.equalTo(self.mas_bottom).with.offset(-15*kScale);

            }
            else{
                make.bottom.equalTo(self.mas_bottom).with.offset(-120*kScale);

            }
            
            if (labelsMarray.count == 0) {//无标签
                make.top.equalTo(self.commentUserImv.mas_bottom).with.offset(10*kScale);
            }else{
                make.top.equalTo(self.commentsLabBtn.mas_bottom).with.offset(10*kScale);
            }
            make.left.equalTo(self.commentUserImv);
            make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        }];
    }
    
    if (r.height >43) {///显示展开按钮
        
        [self.isFoldingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.commentDetailsLab);
            make.bottom.equalTo(self.commentDetailsLab.mas_bottom).with.offset(25*kScale);
            make.height.equalTo(@(20*kScale));
            make.width.equalTo(@(40*kScale));
        }];
        
        if (imageMarray.count == 0) {
            
        } else {
            
        }
        
        
    }else{
        //[self.isFoldingBtn removeFromSuperview];
    }
  
    
    
    
    ///图片显示
        __block UIView *lastView = nil;

        for (int i = 0; i < imageMarray.count; i ++) {
            UIImageView *imv = [[UIImageView alloc] init];
            
            [imv sd_setImageWithURL:[NSURL URLWithString:imageMarray[i] ] ];
            [self addSubview:imv];


            [imv mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(100*kScale));
                make.width.equalTo(@(100*kScale));
                if (r.height >43) {
                    make.top.equalTo(self.isFoldingBtn.mas_bottom).with.offset(15*kScale);

                }else{
                    make.top.equalTo(self.commentDetailsLab.mas_bottom).with.offset(15*kScale);

                }
                
                if (i == 0) {
                    make.left.equalTo(self.mas_left).with.offset(15*kScale);
                }else{
                    make.left.equalTo(lastView.mas_right).with.offset(15*kScale);
                }
            }];
            imv.tag = i;
            imv.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage:)];
            [imv addGestureRecognizer:tapGesture];
            
        
            self.commentDescImv = imv;
            lastView = imv;
        }
   
   
   
}


-(void)clickImage:(UITapGestureRecognizer*)tap{
    
    DLog(@"cccclick === %ld" ,tap.view.tag);
    if ([self respondsToSelector:@selector(returnClickImaeTag)]) {
        
        self.returnClickImaeTag(tap.view.tag, self.commentsImageArray);
        
    }
}




-(void)setMainFrame{
    
    [self.commentUserImv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15*kScale);
        make.top.equalTo(self.mas_top).with.offset(20*kScale);
        make.height.equalTo(@(35*kScale));
        make.width.equalTo(@(35*kScale));
    }];
    
    [self.commentNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.commentUserImv.mas_right).with.offset(5*kScale);
        make.top.equalTo(self.commentUserImv);
        make.height.equalTo(@(12*kScale));
        make.width.equalTo(@(100*kScale));
    }];
    
    
    [self.commentTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.commentNameLab.mas_right).with.offset(10*kScale);
        make.top.equalTo(self.commentUserImv);
        make.height.equalTo(@(12*kScale));
//        make.width.equalTo(@(120*kScale));
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
    
        
    }];
    
    [self.goodsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.commentNameLab);
        make.top.equalTo(self.commentNameLab.mas_bottom).with.offset(10*kScale);
        make.height.equalTo(@(12*kScale));
        make.width.equalTo(@(35*kScale));
    }];

    [self.commentDetailsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        _masHeight = make.height.lessThanOrEqualTo(@(45*kScale));

        make.left.equalTo(self.commentUserImv);
        make.right.equalTo(self.mas_right).with.offset(-15*kScale); make.top.equalTo(self.goodsLab.mas_bottom).with.offset(10*kScale);
        make.bottom.equalTo(self.mas_bottom).with.offset(-120*kScale);
        //make.height.equalTo(@(40*kScale));
    }];
    
    
   
    
    
    
    
}


-(UIImageView *)commentUserImv{
    if (_commentUserImv == nil) {
        _commentUserImv = [[UIImageView alloc] init];
        _commentUserImv.layer.masksToBounds = YES;
        _commentUserImv.layer.cornerRadius = 35*kScale/2;
    }
    return _commentUserImv;
}

-(UILabel *)commentNameLab{
    if (_commentNameLab == nil) {
        _commentNameLab = [[UILabel alloc] init];
        _commentNameLab.font = [UIFont systemFontOfSize:12.0f*kScale];
    }
    return _commentNameLab;
}

-(UILabel *)commentTimeLab{
    if (_commentTimeLab == nil) {
        _commentTimeLab = [[UILabel alloc] init];
        _commentTimeLab.font = [UIFont systemFontOfSize:12.0f*kScale];
        _commentTimeLab.textColor = RGB(136, 136, 136, 1);
        
    }
    return _commentTimeLab;
}

-(UILabel *)goodsLab{
    if (_goodsLab == nil) {
        
        _goodsLab = [[UILabel alloc] init];
        _goodsLab.font = [UIFont systemFontOfSize:12.0f*kScale];
        _goodsLab.textColor = RGB(136, 136, 136, 1);
        _goodsLab.text = @"评价";
    }
    return _goodsLab;
}


-(UILabel *)commentDetailsLab{
    if (_commentDetailsLab == nil) {
        
        _commentDetailsLab = [[UILabel alloc] init];
        _commentDetailsLab.font = [UIFont systemFontOfSize:12.0f*kScale];
        _commentDetailsLab.textColor = RGB(51, 51, 51, 1);
        _commentDetailsLab.numberOfLines = 0;
    }
    return _commentDetailsLab;
}


-(UIButton *)isFoldingBtn{
    if (_isFoldingBtn == nil) {
        _isFoldingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_isFoldingBtn setTitle:@"展开" forState:0];
        [_isFoldingBtn setTitleColor:RGB(90,108,133, 1) forState:0];
        _isFoldingBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f*kScale];
        _isFoldingBtn.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentLeft;
        //[_isFoldingBtn setImage:[UIImage imageNamed:@"isfold"] forState:0];
    }
    return _isFoldingBtn;
}



//
//-(void)setGoodsStartArray:(NSMutableArray*)goodsStatArray andCommentDescImvArray:(NSMutableArray*)descImvArray CommentsLabsMarray:(NSMutableArray*)commentsLabsMarray ConfigWithConmmentsModel:(HomePageCommentsModel*)commentsModel{

//    self.commentUserImv = [[UIImageView alloc] init];
//    self.commentUserImv.layer.masksToBounds = YES;
//    self.commentUserImv.layer.cornerRadius = 35*kScale/2;
//    [self addSubview:self.commentUserImv];
//
//    [self.commentUserImv mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left).with.offset(15*kScale);
//        make.top.equalTo(self.mas_top).with.offset(20*kScale);
//        make.height.equalTo(@(35*kScale));
//        make.width.equalTo(@(35*kScale));
//    }];

//    _commentNameLab = [[UILabel alloc] init];
//    _commentNameLab.font = [UIFont systemFontOfSize:12.0f*kScale];
//    [self addSubview:_commentNameLab];
//    [self.commentNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.commentUserImv.mas_right).with.offset(5*kScale);
//        make.top.equalTo(self.commentUserImv);
//        make.height.equalTo(@(12*kScale));
//        make.width.equalTo(@(50*kScale));
//    }];
//    _commentTimeLab = [[UILabel alloc] init];
//    _commentTimeLab.font = [UIFont systemFontOfSize:12.0f*kScale];
//    _commentTimeLab.textColor = RGB(136, 136, 136, 1);
//    [self addSubview:_commentTimeLab];
//    [self.commentTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.commentNameLab.mas_right).with.offset(10*kScale);
//        make.top.equalTo(self.commentUserImv);
//        make.height.equalTo(@(12*kScale));
//        make.width.equalTo(@(120*kScale));
//    }];

//    _goodsLab = [[UILabel alloc] init];
//    _goodsLab.font = [UIFont systemFontOfSize:12.0f*kScale];
//    _goodsLab.textColor = RGB(136, 136, 136, 1);
//    [self addSubview:_goodsLab];
//    [self.goodsLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.commentNameLab);
//        make.top.equalTo(self.commentNameLab.mas_bottom).with.offset(10*kScale);
//        make.height.equalTo(@(12*kScale));
//        make.width.equalTo(@(35*kScale));
//    }];


//    for (int i = 0; i < 5; i++) {
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        if (i < goodsStatArray.count) {
//            [btn setImage:[UIImage imageNamed:@"haoping"] forState:0];
//
//        }else{
//        [btn setImage:[UIImage imageNamed:@"pingjia"] forState:0];
//        }
//        [self addSubview:btn];
//        self.goodsStarBtn = btn;
//        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.goodsLab.mas_right).with.offset(5*kScale+20*i*kScale);
//            make.top.equalTo(self.goodsLab).with.offset(0);
//            make.width.and.height.equalTo(@(15*kScale));
//        }];
//
//
//    }
//
//    for (int i= 0; i<commentsLabsMarray.count; i++) {
//
//            UIButton *commentsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//            commentsBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f*kScale];
//            [commentsBtn setTitle:commentsLabsMarray[i] forState:0];
//
//        [self addSubview:commentsBtn];
//        commentsBtn.backgroundColor = RGB(251,100,35, 1);
//        commentsBtn.selected = YES;
//
//        [commentsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            if (i < 4) {
//                    make.top.equalTo(self.commentUserImv.mas_bottom).with.offset(10*kScale);
//                    make.width.equalTo(@(65*kScale)); make.left.equalTo(self.mas_left).with.offset((15*kScale + 75*kScale * i));
//
//
//                }else{
//                    make.top.equalTo(self.commentUserImv.mas_bottom).with.offset(40*kScale);
//                    make.width.equalTo(@(65*kScale)); make.left.equalTo(self.mas_left).with.offset((15*kScale + 75*kScale * (i-4)));
//
//                }
//
//
//                make.height.equalTo(@(20*kScale));
//
//                commentsBtn.tag = i;
//                self.commentsLabBtn = commentsBtn;
//            }];
//
//
//    }
//
//
//
//    _commentDetailsLab = [[UILabel alloc] init];
//    _commentDetailsLab.font = [UIFont systemFontOfSize:12.0f*kScale];
//    _commentDetailsLab.textColor = RGB(51, 51, 51, 1);
//    _commentDetailsLab.numberOfLines = 0;
//    [self addSubview:_commentDetailsLab];
//    [self.commentDetailsLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.commentUserImv);
//        make.top.equalTo(self.commentsLabBtn.mas_bottom).with.offset(10*kScale);
//        make.width.equalTo(@(kWidth-30*kScale));
//        make.height.equalTo(@(40*kScale));
//    }];
//
//    __block UIView *lastView = nil;
//
//    for (int i = 0; i < descImvArray.count; i ++) {
//        UIImageView *imv = [[UIImageView alloc] init];
//        imv.backgroundColor = [UIColor redColor];
//        [self addSubview:imv];
//
//
//        [imv mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(@100);
//            make.width.equalTo(@100);
//            make.top.equalTo(self.commentDetailsLab.mas_bottom).with.offset(15);
//            if (i == 0) {
//                make.left.equalTo(self.mas_left).with.offset(15);
//            }else{
//                make.left.equalTo(lastView.mas_right).with.offset(15);
//            }
//        }];
//
//        self.commentDescImv = imv;
//        lastView = imv;
//    }
//
//
//    _commentUserImv.backgroundColor = [UIColor redColor];
//    _commentNameLab.text = @"黎明淑而热额热 而热热热 热而而而润肤乳 而呃呃呃呃,十多个热热热二个人让他忽然听到, ";
//    _commentTimeLab.text = @"2015.02.23";
//    _goodsLab.text = @"商品 :";
//    _sendLab.text = @"配送 :";
//    _commentDetailsLab.text = @"淑而热额热 而热热热 热而而而润肤乳 而呃呃呃呃,十多个热热热二个人让他忽然听到, 而扔个热热隔热管,hahhaha哈哈哈啊哈哈教科书的教科书的境况开始的恐惧第三节课施蒂利克的烧烤德生科技就开始的境况四大皆空计算宽度";
//
//
//}







@end
