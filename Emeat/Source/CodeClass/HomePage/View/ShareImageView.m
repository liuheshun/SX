//
//  ShareImageView.m
//  Emeat
//
//  Created by liuheshun on 2018/7/16.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "ShareImageView.h"

@implementation ShareImageView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.logoImageView];
        [self addSubview:self.mainImageView];
        [self addSubview:self.titleLab];
        [self addSubview:self.descLab];
        [self addSubview:self.pricesLab];
        [self addSubview:self.lingView];
        [self addSubview:self.codeImageView];
        [self addSubview:self.codeDescLab1];
        [self addSubview:self.codeDescLab2];
        [self setMainFrame];
    }
    return self;
}

-(void)configShareViewMainimage:(NSString*)mainImage Title:(NSString*)title Desc:(NSString*)desc Prices:(NSString*)prices codeURL:(NSString*)codeUrl PriceTypes:(NSString *)priceTypes{
    
    [self.mainImageView sd_setImageWithURL:[NSURL URLWithString:mainImage]];
    self.titleLab.text = title;
    self.descLab.text = desc;
    
    [self.descLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@([GetWidthAndHeightOfString getHeightForText:self.descLab width:kWidth]+1));
    }];
    [self.pricesLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descLab.mas_bottom).with.offset(12*kScale);

    }];
    
    if ([priceTypes isEqualToString:@"WEIGHT"]) {
        self.pricesLab.text =[NSString stringWithFormat:@"%.2f元/kg",(float) [prices integerValue]/100];
    }else{
        self.pricesLab.text =[NSString stringWithFormat:@"%.2f元/件",(float) [prices integerValue]/100];
    }
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.pricesLab.text];
    NSRange range1 = [[str string] rangeOfString:[NSString stringWithFormat:@"%.2f" ,(float) [prices integerValue]/100]];
    [str addAttribute:NSForegroundColorAttributeName value:RGB(236, 31, 35, 1) range:range1];
    
    self.pricesLab.attributedText = str;
    
    
    
    
    
    self.codeDescLab1.text = @"长按图片,识别二维码";
    self.codeDescLab2.text = @"查看商品详情";
    // 1.创建过滤器
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2.恢复默认
    [filter setDefaults];
    // 3.给过滤器添加数据(正则表达式/账号和密码)
    NSString *dataString = codeUrl;//二维码链接
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    // 4.获取输出的二维码
    CIImage *outputImage = [filter outputImage];
    
    //因为生成的二维码模糊，所以通过createNonInterpolatedUIImageFormCIImage:outputImage来获得高清的二维码图片
    
    // 5.显示二维码
    UIImage *QRimage =[self createNonInterpolatedUIImageFormCIImage:outputImage withSize:147];
    self.codeImageView.image =QRimage;
    
    
    
}

#pragma mark===============生成二维码========================

/**
 *  根据CIImage生成指定大小的UIImage
 *
 *  @param image CIImage
 *  @param size  图片宽度
 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}



-(void)setMainFrame{
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.equalTo(@(90*kScale));
    }];
    [self.mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.logoImageView.mas_bottom);
        make.height.equalTo(@(300*kScale));
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.mainImageView.mas_bottom).with.offset(25*kScale);
        make.height.equalTo(@(15*kScale));
    }];
    [self.descLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.titleLab.mas_bottom).with.offset(15*kScale);
        make.height.equalTo(@(12*kScale));
    }];
    
    [self.pricesLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.descLab.mas_bottom).with.offset(12*kScale);
        make.height.equalTo(@(15*kScale));
    }];
    
    [self.lingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15*kScale);
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.top.equalTo(self.pricesLab.mas_bottom).with.offset(40*kScale);
        make.height.equalTo(@(1*kScale));
    }];
    
    [self.codeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(19*kScale);
        make.top.equalTo(self.lingView.mas_bottom).with.offset(18*kScale);
        make.height.width.equalTo(@(100*kScale));
        
    }];
    
    [self.codeDescLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.codeImageView.mas_right).with.offset(20*kScale);
        make.right.equalTo(self.mas_right).with.offset(-19*kScale);
        make.top.equalTo(self.lingView.mas_bottom).with.offset(45*kScale);
        make.height.equalTo(@(15*kScale));
        
    }];
    
    [self.codeDescLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.codeImageView.mas_right).with.offset(20*kScale);
        make.right.equalTo(self.mas_right).with.offset(-19*kScale);
        make.top.equalTo(self.codeDescLab1.mas_bottom).with.offset(15*kScale);
        make.height.equalTo(@(15*kScale));
        
    }];
}


- (UIImageView *)logoImageView{
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"share_logo"]];
    }
    return _logoImageView;
}

- (UIImageView *)mainImageView{
    if (!_mainImageView) {
        _mainImageView = [UIImageView new];
    }
    return _mainImageView;
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.font = [UIFont systemFontOfSize:15.0f*kScale];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.textColor = RGB(51, 51, 51, 1);

    }
    return _titleLab;
}


- (UILabel *)descLab{
    if (!_descLab) {
        _descLab = [UILabel new];
        _descLab.font = [UIFont systemFontOfSize:12.0f*kScale];
        _descLab.textAlignment = NSTextAlignmentCenter;
        _descLab.numberOfLines = 2;
        _descLab.textColor = RGB(136, 136, 136, 1);
    }
    return _descLab;
}

- (UILabel *)pricesLab{
    if (!_pricesLab) {
        _pricesLab = [UILabel new];
        _pricesLab.font = [UIFont systemFontOfSize:12.0f*kScale];
        _pricesLab.textAlignment = NSTextAlignmentCenter;
        _pricesLab.textColor = RGB(51, 51, 51, 1);
    }
    return _pricesLab;
}
- (UIView *)lingView{
    if (!_lingView) {
        _lingView = [UIView new];
        _lingView.backgroundColor = RGB(238, 238, 238, 1);
    }
    return _lingView;
}

- (UIImageView *)codeImageView{
    if (!_codeImageView) {
        _codeImageView = [UIImageView new];
        _codeImageView.backgroundColor = RGB(136, 136, 136, 1);
    }
    return _codeImageView;
}

- (UILabel *)codeDescLab1{
    if (!_codeDescLab1) {
        _codeDescLab1 = [UILabel new];
        _codeDescLab1.font = [UIFont systemFontOfSize:12.0f*kScale];
        _codeDescLab1.textAlignment = NSTextAlignmentLeft;
        _codeDescLab1.textColor = RGB(51, 51, 51, 1);
    }
    return _codeDescLab1;
}
- (UILabel *)codeDescLab2{
    if (!_codeDescLab2) {
        _codeDescLab2 = [UILabel new];
        _codeDescLab2.font = [UIFont systemFontOfSize:12.0f*kScale];
        _codeDescLab2.textAlignment = NSTextAlignmentLeft;
        _codeDescLab2.textColor = RGB(51, 51, 51, 1);
    }
    return _codeDescLab2;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
