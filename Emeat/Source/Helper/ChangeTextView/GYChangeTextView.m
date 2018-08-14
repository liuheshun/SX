//
//  GYChangeTextView.m
//  Emeat
//
//  Created by liuheshun on 2018/8/4.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "GYChangeTextView.h"

#define DEALY_WHEN_TITLE_IN_MIDDLE  5.0
#define DEALY_WHEN_TITLE_IN_BOTTOM  0.0

typedef NS_ENUM(NSUInteger, GYTitlePosition) {
    GYTitlePositionTop    = 1,
    GYTitlePositionMiddle = 2,
    GYTitlePositionBottom = 3
};

@interface GYChangeTextView ()

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) NSArray *contentsAry;
@property (nonatomic, assign) CGPoint topPosition;
@property (nonatomic, assign) CGPoint middlePosition;
@property (nonatomic, assign) CGPoint bottomPosition;
/*
 *1.控制延迟时间，当文字在中间时，延时时间长一些，如5秒，这样可以让用户浏览清楚内容；
 *2.当文字隐藏在底部的时候，不需要延迟，这样衔接才流畅；
 *3.通过上面的宏定义去更改需要的值
 */
@property (nonatomic, assign) CGFloat needDealy;
@property (nonatomic, assign) NSInteger currentIndex;  /*当前播放到那个标题了*/
@property (nonatomic, assign) BOOL shouldStop;         /*是否停止*/

@end


@implementation GYChangeTextView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.topPosition    = CGPointMake(self.frame.size.width/2, -self.frame.size.height/2);
        self.middlePosition = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        self.bottomPosition = CGPointMake(self.frame.size.width/2, self.frame.size.height/2*3);
        self.shouldStop = NO;
        _textLabel = [[UILabel alloc] init];
        _textLabel.layer.bounds = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
        _textLabel.layer.position = self.middlePosition;
        _textLabel.textAlignment = NSTextAlignmentLeft;
        _textLabel.font = [UIFont systemFontOfSize:12.0f*kScale];
        _textLabel.numberOfLines = 0;
        _textLabel.textColor = RGB(51, 51, 51, 1);
        [self addSubview:_textLabel];
        self.clipsToBounds = YES;   /*保证文字不跑出视图*/
        self.needDealy = DEALY_WHEN_TITLE_IN_MIDDLE;    /*控制第一次显示时间*/
        self.currentIndex = 0;
    }
    return self;
}

- (void)animationWithTexts:(NSArray *)textAry {
    if (textAry.count != 0) {
        self.contentsAry = textAry;
        HomePageModel *model = [textAry objectAtIndex:0];
        //self.textLabel.text = [textAry objectAtIndex:0];
        self.textLabel.text = [NSString stringWithFormat:@"%@用户成功下单支付%.2f元购买%@等商品共%.2fkg",model.customerAccount , (CGFloat)model.price/100 , model.position ,(CGFloat)model.weight/100];
        
        //设置字体颜色
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.textLabel.text];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5];
        [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.textLabel.text length])];
        
        
        
        NSRange range1 = [[str string] rangeOfString:[NSString stringWithFormat:@"%.2f" ,(float)model.price/100]];
        [str addAttribute:NSForegroundColorAttributeName value:RGB(236, 31, 35, 1) range:range1];
        
        NSRange range2 = [[str string] rangeOfString:[NSString stringWithFormat:@"%.2f" ,(float)model.weight/100]];
        [str addAttribute:NSForegroundColorAttributeName value:RGB(236, 31, 35, 1) range:range2];
        
        self.textLabel.attributedText = str;
        
        
       [self startAnimation];
        
    }
   
    
    
    
}

- (void)startAnimation {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 delay:self.needDealy options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if ([weakSelf currentTitlePosition] == GYTitlePositionMiddle) {
            weakSelf.textLabel.layer.position = weakSelf.topPosition;
        } else if ([weakSelf currentTitlePosition] == GYTitlePositionBottom) {
            weakSelf.textLabel.layer.position = weakSelf.middlePosition;
        }
    } completion:^(BOOL finished) {
        if ([weakSelf currentTitlePosition] == GYTitlePositionTop) {
            weakSelf.textLabel.layer.position = weakSelf.bottomPosition;
            weakSelf.needDealy = DEALY_WHEN_TITLE_IN_BOTTOM;
            weakSelf.currentIndex ++;
            
            HomePageModel *model = [weakSelf.contentsAry objectAtIndex:[weakSelf realCurrentIndex]];
            //self.textLabel.text = [textAry objectAtIndex:0];
            weakSelf.textLabel.text = [NSString stringWithFormat:@"%@用户成功下单支付%.2f元购买%@等商品共%.2fKG",model.customerAccount , (CGFloat)model.price/100 , model.position ,(CGFloat)model.weight/100];
            
            //设置字体颜色
            //设置字体颜色
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:weakSelf.textLabel.text];
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:5];
            [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.textLabel.text length])];
            
            
            
            NSRange range1 = [[str string] rangeOfString:[NSString stringWithFormat:@"%.2f" ,(float)model.price/100]];
            [str addAttribute:NSForegroundColorAttributeName value:RGB(236, 31, 35, 1) range:range1];
            
            NSRange range2 = [[str string] rangeOfString:[NSString stringWithFormat:@"%.2f" ,(float)model.weight/100]];
            [str addAttribute:NSForegroundColorAttributeName value:RGB(236, 31, 35, 1) range:range2];
            weakSelf.textLabel.attributedText = str;
            
            
            //weakSelf.textLabel.text = [weakSelf.contentsAry objectAtIndex:[weakSelf realCurrentIndex]];
        } else {
            weakSelf.needDealy = DEALY_WHEN_TITLE_IN_MIDDLE;
        }
        if (!weakSelf.shouldStop) {
            [weakSelf startAnimation];
        } else { //停止动画后，要设置label位置和label显示内容
            weakSelf.textLabel.layer.position = weakSelf.middlePosition;
            
            
            HomePageModel *model = [weakSelf.contentsAry objectAtIndex:[weakSelf realCurrentIndex]];
            //self.textLabel.text = [textAry objectAtIndex:0];
            weakSelf.textLabel.text = [NSString stringWithFormat:@"%@用户成功下单支付%.2f元购买%@等商品共%.2fKG",model.customerAccount , (CGFloat)model.price/100 , model.position ,(CGFloat)model.weight/100];
            
            //设置字体颜色
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.textLabel.text];
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:5];
            [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.textLabel.text length])];
            
            
            
            NSRange range1 = [[str string] rangeOfString:[NSString stringWithFormat:@"%.2f" ,(float)model.price/100]];
            [str addAttribute:NSForegroundColorAttributeName value:RGB(236, 31, 35, 1) range:range1];
            
            NSRange range2 = [[str string] rangeOfString:[NSString stringWithFormat:@"%.2f" ,(float)model.weight/100]];
            [str addAttribute:NSForegroundColorAttributeName value:RGB(236, 31, 35, 1) range:range2];
            
            weakSelf.textLabel.attributedText = str;
            
            //weakSelf.textLabel.text = [weakSelf.contentsAry objectAtIndex:[weakSelf realCurrentIndex]];
        }
    }];
    
    
    
//    NSString *labelText = self.textLabel.text;
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle setLineSpacing:5];
//    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
//    self.textLabel.attributedText = attributedString;
    // [self.textLabel sizeToFit];
    
}

- (void)stopAnimation {
    self.shouldStop = YES;
}

- (NSInteger)realCurrentIndex {
    return self.currentIndex % [self.contentsAry count];
}

- (GYTitlePosition)currentTitlePosition {
    if (self.textLabel.layer.position.y == self.topPosition.y) {
        return GYTitlePositionTop;
    } else if (self.textLabel.layer.position.y == self.middlePosition.y) {
        return GYTitlePositionMiddle;
    }
    return GYTitlePositionBottom;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([self.delegate respondsToSelector:@selector(gyChangeTextView:didTapedAtIndex:)]) {
        [self.delegate gyChangeTextView:self didTapedAtIndex:[self realCurrentIndex]];
    }
}

//
//-(NSArray *)getLinesArrayOfStringInLabel:(NSString *)str
//{
//    NSString *text = str;
//    UIFont   *font = [UIFont systemFontOfSize:12.0f*kScale] ;
//    CGRect    rect = CGRectMake(ScreenWidth*0.25, 0, ScreenWidth*0.7, ScreenWidth);
//
//
//    CTFontRef myFont = CTFontCreateWithName((CFStringRef)font.fontName,
//                                            font.pointSize,
//                                            NULL);
//
//    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
//    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)myFont range:NSMakeRange(0, attStr.length)];
//
//    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attStr);
//
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathAddRect(path, NULL, CGRectMake(0,0,rect.size.width,100000));
//
//    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
//
//    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
//    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
//
//    for (id line in lines)
//    {
//        CTLineRef lineRef = (__bridge CTLineRef )line;
//        CFRange lineRange = CTLineGetStringRange(lineRef);
//        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
//
//        NSString *lineString = [text substringWithRange:range];
//        [linesArray addObject:lineString];
//    }
//
//    return (NSArray *)linesArray;
//}

@end
