//
//  VersionUpdateView.m
//  Emeat
//
//  Created by liuheshun on 2018/5/7.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "VersionUpdateView.h"
#import "HWPopTool.h"
@implementation VersionUpdateView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setMainView];
    }
    return self;
}

-(void)setMainView{
    VersionUpdateViewConfig *config = [VersionUpdateViewConfig UpdateViewConfig];
    
    self.topImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:config.imageString]];
    [self addSubview:self.topImageView];
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.width.equalTo(self);
        make.height.equalTo(@(187*kScale));
        
    }];
    
    self.midBgView = [[UIView alloc] init];
    self.midBgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.midBgView];
    [self.midBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topImageView.mas_bottom).with.offset(0);
        make.left.equalTo(self);
        make.width.equalTo(self);
        make.height.equalTo(@(200*kScale));
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    [self.midBgView addSubview:self.titleLabel];
    self.titleLabel.font = [UIFont systemFontOfSize:15.0f*kScale];
    self.titleLabel.text = config.titleString;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textAlignment = NSTextAlignmentLeft;

    self.titleLabel.backgroundColor = [UIColor whiteColor];
    CGFloat titleHeight = [GetWidthAndHeightOfString getHeightForText:self.titleLabel width:WIDTH(self)-30*kScale]+5;
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.midBgView.mas_top).with.offset(5*kScale);
        make.left.equalTo(self.midBgView.mas_left).with.offset(15*kScale);
        make.right.equalTo(self.midBgView.mas_right).with.offset(-15*kScale);
        make.height.equalTo(@(titleHeight));
    }];
    [self.midBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topImageView.mas_bottom).with.offset(0);
        make.left.equalTo(self);
        make.width.equalTo(self);
        make.height.equalTo(@(titleHeight+5));
        
    }];
    
    
    
    
    self.bottomBgView = [[UIView alloc] init];
    [self addSubview:self.bottomBgView];
    self.bottomBgView.backgroundColor = [UIColor whiteColor];

    [self.bottomBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self.midBgView.mas_bottom).with.offset(0);
        make.width.equalTo(self);
        make.height.equalTo(@(80*kScale));
        
    }];
    [self.bottomBgView layoutIfNeeded];

    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bottomBgView.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bottomBgView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.bottomBgView.layer.mask = maskLayer;
    
   
    self.updateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bottomBgView addSubview:self.updateBtn];
    self.updateBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f*kScale];
    [self.updateBtn setTitle:@"马上更新" forState:0];
    self.updateBtn.backgroundColor = RGB(231, 35, 36, 1);
    self.updateBtn.layer.cornerRadius = 10;
    self.updateBtn.layer.masksToBounds = YES;
    [self.updateBtn addTarget:self action:@selector(updateBtnAction) forControlEvents:1];
    
    
    [self.updateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomBgView.mas_top).with.offset(20*kScale);
        make.width.equalTo(@(170*kScale));
        make.height.equalTo(@(38*kScale));
        make.centerX.equalTo(self);
    }];
    
    if ([config.isShowCancelBtn isEqualToString:@"false"]) {
        self.cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.cancleBtn];
        [self.cancleBtn setImage:[UIImage imageNamed:@"cancel_Version"] forState:0];
        [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bottomBgView.mas_bottom).with.offset(20*kScale);
            make.width.equalTo(@(40*kScale));
            make.height.equalTo(@(40*kScale));
            make.centerX.equalTo(self);
        }];
        [self.cancleBtn addTarget:self action:@selector(cancleBtnAction) forControlEvents:1];
        
    }else{
        
    }

    
}

-(void)cancleBtnAction{
    [[HWPopTool sharedInstance]closeWithBlcok:^{
        
    }];
}

-(void)updateBtnAction{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@" ,appStoreURL]]];
}



@end

@interface VersionUpdateViewConfig()

@end

@implementation VersionUpdateViewConfig

+ (VersionUpdateViewConfig *)UpdateViewConfig
{
    static VersionUpdateViewConfig *config1;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        config1 = [VersionUpdateViewConfig new];
        
    });
    
    return config1;
}

- (instancetype)init
{
    self = [super init];
    
    if ( self )
    {
       
    }
    
    return self;
}

@end





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

