//
//  Card.m
//  CardSwitchDemo
//
//  Created by Apple on 2016/11/9.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "XLCard.h"
#import "XLCardItem.h"

@interface XLCard () 
@end

@implementation XLCard

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    return self;
}

- (void)buildUI {
    //self.layer.cornerRadius = 10.0f;
    //self.layer.masksToBounds = true;
    self.backgroundColor = [UIColor whiteColor];
    
//    CGFloat labelHeight = self.bounds.size.height * 0.20f;
//    CGFloat imageViewHeight = self.bounds.size.height - labelHeight;
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, self.bounds.size.width-30, 170)];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.layer.masksToBounds = true;
    [self addSubview:_imageView];
    
    _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, MaxY(_imageView)+10*kScale, self.bounds.size.width, 15*kScale)];
    _textLabel.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1];
    _textLabel.font = [UIFont systemFontOfSize:15.0f*kScale];
    _textLabel.textAlignment = NSTextAlignmentLeft;
    _textLabel.adjustsFontSizeToFitWidth = true;
    [self addSubview:_textLabel];
    
    
    _newsPricesLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, MaxY(_textLabel)+15*kScale, 50, 12*kScale)];
    _newsPricesLabel.textColor = RGB(231, 35, 36, 1);
    _newsPricesLabel.font = [UIFont systemFontOfSize:12.0f*kScale];
    _newsPricesLabel.textAlignment = NSTextAlignmentLeft;
    _newsPricesLabel.adjustsFontSizeToFitWidth = true;
    [self addSubview:_newsPricesLabel];
    
    
    _oldsPricesLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(_newsPricesLabel)+5*kScale, MaxY(_textLabel)+15*kScale, 100, 12*kScale)];
    _oldsPricesLabel.textColor = RGB(136, 136, 136, 1);
    _oldsPricesLabel.font = [UIFont systemFontOfSize:12.0f*kScale];
    _oldsPricesLabel.textAlignment = NSTextAlignmentLeft;
    _oldsPricesLabel.adjustsFontSizeToFitWidth = true;
    [self addSubview:_oldsPricesLabel];
//    _oldsPricesLabel.backgroundColor = [UIColor cyanColor];
//    _newsPricesLabel.backgroundColor = [UIColor cyanColor];
    _addShoppingCardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _addShoppingCardBtn.frame = CGRectMake(WIDTH(self)-50, MaxY(_imageView)+10*kScale, 40, 40);
    [self addSubview:_addShoppingCardBtn];
    [_addShoppingCardBtn setImage:[UIImage imageNamed:@"join_cart"] forState:0];
    
    
}

-(void)setItem:(HomePageModel *)item {
    [_imageView sd_setImageWithURL:[NSURL URLWithString:item.mainImage] placeholderImage:[UIImage imageNamed:@"small_placeholder"]];
    _textLabel.text = item.commodityName;
    
    
    if (item.discountPrice == -1) {///只显示原价
        
        self.newsPricesLabel.text = [NSString stringWithFormat:@"%.2f元" ,(CGFloat)item.costPrice/100];
    }else{
        self.newsPricesLabel.text = [NSString stringWithFormat:@"%.2f元" ,(CGFloat)item.unitPrice/100];
        self.oldsPricesLabel.text = [NSString stringWithFormat:@"%.2f元" ,(CGFloat)item.costPrice/100];
        
    }
   
    
    CGRect newsPricesRect = self.newsPricesLabel.frame;
    newsPricesRect.size.width = [GetWidthAndHeightOfString getWidthForText:self.newsPricesLabel height:12.0f*kScale];
    self.newsPricesLabel.frame = newsPricesRect;
    
    CGRect oldPricesRect = self.oldsPricesLabel.frame;
    oldPricesRect.size.width = [GetWidthAndHeightOfString getWidthForText:self.oldsPricesLabel height:12.0f*kScale];
    oldPricesRect.origin.x = MaxX(self.newsPricesLabel)+5*kScale;
    self.oldsPricesLabel.frame = oldPricesRect;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 5.5*kScale, WIDTH(self.oldsPricesLabel), 1*kScale)];
    lineView.backgroundColor = RGB(136, 136, 136, 1);
    
    if (item.discountPrice == -1) {///只显示原价
        [lineView removeFromSuperview];
    }else{
        [self.oldsPricesLabel addSubview:lineView];

    }
   
    
    
}

@end
