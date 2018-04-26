//
//  MMMyCustomView.m
//  Emeat
//
//  Created by liuheshun on 2018/4/23.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "MMMyCustomView.h"
#import "MMPopupItem.h"
#import "MMPopupCategory.h"
#import "MMPopupDefine.h"
#import <Masonry/Masonry.h>


@interface MMMyCustomView ()

@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UILabel     *detailLabel;
@property (nonatomic, strong) UITextField *inputView;
@property (nonatomic, strong) UIView      *buttonView;

@property (nonatomic, strong) NSArray     *actionItems;

@property (nonatomic, copy) MMPopupInputHandler inputHandler;

@end

@implementation MMMyCustomView

- (instancetype) initWithInputTitle:(NSString *)title
detail:(NSString *)detail
                        placeholder:(NSString *)inputPlaceholder
                            handler:(MMPopupInputHandler)inputHandler
{
    MMAlertViewConfig1 *config = [MMAlertViewConfig1 globalConfig1];
    
    NSArray *items =@[
                      MMItemMake(config.defaultTextCancel, MMItemTypeHighlight, nil),
                      MMItemMake(config.defaultTextConfirm, MMItemTypeHighlight, nil)
                      ];
    return [self initWithTitle:title detail:detail items:items inputPlaceholder:inputPlaceholder inputHandler:inputHandler];
}

- (instancetype) initWithConfirmTitle:(NSString*)title
                               detail:(NSString*)detail
{
    MMAlertViewConfig1 *config = [MMAlertViewConfig1 globalConfig1];
    
    NSArray *items =@[
                      MMItemMake(config.defaultTextOK, MMItemTypeHighlight, nil)
                      ];
    
    return [self initWithTitle:title detail:detail items:items];
}

- (instancetype) initWithTitle:(NSString*)title
                        detail:(NSString*)detail
                         items:(NSArray*)items
{
    return [self initWithTitle:title detail:detail items:items inputPlaceholder:nil inputHandler:nil];
}

- (instancetype)initWithTitle:(NSString *)title
                       detail:(NSString *)detail
                        items:(NSArray *)items
             inputPlaceholder:(NSString *)inputPlaceholder
                 inputHandler:(MMPopupInputHandler)inputHandler
{
    self = [super init];
    
    if ( self )
    {
        NSAssert(items.count>0, @"Could not find any items.");
        
        MMAlertViewConfig1 *config = [MMAlertViewConfig1 globalConfig1];
        
        self.type = MMPopupTypeAlert;
        self.withKeyboard = (inputHandler!=nil);
        
        self.inputHandler = inputHandler;
        self.actionItems = items;
        
        self.layer.cornerRadius = config.cornerRadius;
        self.clipsToBounds = YES;
        self.backgroundColor = config.backgroundColor;
        self.layer.borderWidth = MM_SPLIT_WIDTH;
        self.layer.borderColor = config.splitColor.CGColor;
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(config.width);
        }];
        [self setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];
        
        MASViewAttribute *lastAttribute = self.mas_top;
        if ( title.length > 0 )
        {
            self.titleLabel = [UILabel new];
            [self addSubview:self.titleLabel];
            [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastAttribute).offset(config.innerMargin);
                make.left.right.equalTo(self).insets(UIEdgeInsetsMake(0, config.innerMargin, 0, config.innerMargin));
            }];
            self.titleLabel.textColor = config.titleColor;
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            self.titleLabel.font = [UIFont boldSystemFontOfSize:config.titleFontSize];
            self.titleLabel.numberOfLines = 0;
            self.titleLabel.backgroundColor = self.backgroundColor;
            self.titleLabel.text = title;
            
            lastAttribute = self.titleLabel.mas_bottom;
        }
        
        if ( detail.length > 0 )
        {
            self.detailLabel = [UILabel new];
            [self addSubview:self.detailLabel];
            [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastAttribute).offset(5);
                make.left.right.equalTo(self).insets(UIEdgeInsetsMake(0, config.innerMargin, 0, config.innerMargin));
            }];
            self.detailLabel.textColor = config.detailColor;
            self.detailLabel.font = [UIFont systemFontOfSize:config.detailFontSize];
            self.detailLabel.numberOfLines = 0;
            self.detailLabel.backgroundColor = self.backgroundColor;
            self.detailLabel.text = detail;
            lastAttribute = self.detailLabel.mas_bottom;
            
            ///拨打电话设置
            
            NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
            paraStyle.lineSpacing = 6;
            NSDictionary *dict = @{NSParagraphStyleAttributeName : paraStyle};
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:self.detailLabel.text attributes:dict];
            NSRange range = [self.detailLabel.text rangeOfString:@"4001106111"];
            [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
            [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0] range:NSMakeRange(0, self.detailLabel.text.length)];
            self.detailLabel.attributedText = attr;
            
            
            self.detailLabel.userInteractionEnabled = YES;
            [self layoutIfNeeded];
            NSRange range1 = [self.detailLabel.text rangeOfString:@"4001106111"];
            UIControl *phoneControl = [[UIControl alloc] initWithFrame:[self boundingRectForCharacterRange:range1 andLable:self.detailLabel lableSize:self.detailLabel.frame.size]];
            phoneControl.tag = 1234;
            [phoneControl addTarget:self action:@selector(phoneLink) forControlEvents:UIControlEventTouchUpInside];
            [self.detailLabel addSubview:phoneControl];
            
            self.detailLabel.textAlignment = NSTextAlignmentCenter;

        }
        
        if ( self.inputHandler )
        {
            self.inputView = [UITextField new];
            [self addSubview:self.inputView];
            [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastAttribute).offset(10);
                make.left.right.equalTo(self).insets(UIEdgeInsetsMake(0, config.innerMargin, 0, config.innerMargin));
                make.height.mas_equalTo(40);
            }];
            self.inputView.backgroundColor = self.backgroundColor;
            self.inputView.layer.borderWidth = MM_SPLIT_WIDTH;
            self.inputView.layer.borderColor = config.splitColor.CGColor;
            self.inputView.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
            self.inputView.leftViewMode = UITextFieldViewModeAlways;
            self.inputView.clearButtonMode = UITextFieldViewModeWhileEditing;
            self.inputView.placeholder = inputPlaceholder;
            
            lastAttribute = self.inputView.mas_bottom;
        }
        
        self.buttonView = [UIView new];
        [self addSubview:self.buttonView];
        [self.buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastAttribute).offset(config.innerMargin);
            make.left.right.equalTo(self);
        }];
        
        __block UIButton *firstButton = nil;
        __block UIButton *lastButton = nil;
        for ( NSInteger i = 0 ; i < items.count; ++i )
        {
            MMPopupItem *item = items[i];
            
            UIButton *btn = [UIButton mm_buttonWithTarget:self action:@selector(actionButton:)];
            [self.buttonView addSubview:btn];
            btn.tag = i;
            btn.layer.cornerRadius = config.cornerRadius;
            btn.layer.masksToBounds = YES;
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                
                if (items.count == 1) {
                    make.top.bottom.equalTo(self.buttonView);
                    make.height.mas_equalTo(config.buttonHeight);
                    make.left.equalTo(self.buttonView.mas_left).offset(85*kScale);
                    make.right.equalTo(self.buttonView.mas_right).offset(-85*kScale);
                    
                    btn.backgroundColor = config.buttonBackgroundColor;

                    
                }else if ( items.count == 2 )
                {
                    make.top.bottom.equalTo(self.buttonView);
                    make.height.mas_equalTo(config.buttonHeight);
                    
                    if ( !firstButton )
                    {
                        firstButton = btn;
                        make.left.equalTo(self.buttonView.mas_left).offset(-MM_SPLIT_WIDTH);
                    }
                    else
                    {
                        make.left.equalTo(lastButton.mas_right).offset(-MM_SPLIT_WIDTH);
                        make.width.equalTo(firstButton);
                    }
                    [btn setBackgroundImage:[UIImage mm_imageWithColor:self.backgroundColor] forState:UIControlStateNormal];
                    [btn setBackgroundImage:[UIImage mm_imageWithColor:config.itemPressedColor] forState:UIControlStateHighlighted];

                }
                else
                {
                    make.left.right.equalTo(self.buttonView);
                    make.height.mas_equalTo(config.buttonHeight);
                    
                    if ( !firstButton )
                    {
                        firstButton = btn;
                        make.top.equalTo(self.buttonView.mas_top).offset(-MM_SPLIT_WIDTH);
                    }
                    else
                    {
                        make.top.equalTo(lastButton.mas_bottom).offset(-MM_SPLIT_WIDTH);
                        make.width.equalTo(firstButton);
                    }
                    
                    [btn setBackgroundImage:[UIImage mm_imageWithColor:self.backgroundColor] forState:UIControlStateNormal];
                    [btn setBackgroundImage:[UIImage mm_imageWithColor:config.itemPressedColor] forState:UIControlStateHighlighted];

                }
                
                lastButton = btn;
            }];

            [btn setTitle:item.title forState:UIControlStateNormal];
           // [btn setTitleColor:item.highlight?config.itemHighlightColor:config.itemNormalColor forState:UIControlStateNormal];
            [btn setTitleColor:config.itemNormalColor forState:UIControlStateNormal];

            btn.layer.borderWidth = MM_SPLIT_WIDTH;
            btn.layer.borderColor = config.splitColor.CGColor;
            btn.titleLabel.font = (item==items.lastObject)?[UIFont boldSystemFontOfSize:config.buttonFontSize]:[UIFont systemFontOfSize:config.buttonFontSize];
        }
        [lastButton mas_updateConstraints:^(MASConstraintMaker *make) {
            
            if (items.count == 1) {
                make.right.equalTo(self.buttonView.mas_right).offset(-85*kScale);
            }else if ( items.count == 2 )
            {
                make.right.equalTo(self.buttonView.mas_right).offset(MM_SPLIT_WIDTH);
            }
            else
            {
                make.bottom.equalTo(self.buttonView.mas_bottom).offset(MM_SPLIT_WIDTH);
            }
            
        }];
        
        if (items.count == 1) {
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                
                make.bottom.equalTo(self.buttonView.mas_bottom).with.offset(22*kScale);
            }];
        }else{
            
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.equalTo(self.buttonView.mas_bottom);
            
        }];
        }
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyTextChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    return self;
}



#pragma mark-<获取电话号码的坐标>
-(CGRect)boundingRectForCharacterRange:(NSRange)range andLable:(UILabel *)lable lableSize:(CGSize)lableSize{
    
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:lable.attributedText];
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    [textStorage addLayoutManager:layoutManager];
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:lableSize];
    textContainer.lineFragmentPadding = 0;
    [layoutManager addTextContainer:textContainer];
    
    NSRange glyphRange;
    
    [layoutManager characterRangeForGlyphRange:range actualGlyphRange:&glyphRange];
    
    CGRect rect = [layoutManager boundingRectForGlyphRange:glyphRange inTextContainer:textContainer];
    //    CGFloat yOfset =  rect.origin.y;
    //    rect.origin.y = yOfset + 3;
    
    return rect;
}



#pragma mark-点击拨打电话
- (void)phoneLink{
    NSString *str = [NSString stringWithFormat:@"tel:%@",@"4006668800"];
    dispatch_async(dispatch_get_main_queue(), ^(){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    });
    
}




- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)actionButton:(UIButton*)btn
{
    MMPopupItem *item = self.actionItems[btn.tag];
    
    if ( item.disabled )
    {
        return;
    }
    
    if ( self.withKeyboard && (btn.tag==1) )
    {
        if ( self.inputView.text.length > 0 )
        {
            [self hide];
        }
    }
    else
    {
        [self hide];
    }
    
    if ( self.inputHandler && (btn.tag>0) )
    {
        self.inputHandler(self.inputView.text);
    }
    else
    {
        if ( item.handler )
        {
            item.handler(btn.tag);
        }
    }
}

- (void)notifyTextChange:(NSNotification *)n
{
    if ( self.maxInputLength == 0 )
    {
        return;
    }
    
    if ( n.object != self.inputView )
    {
        return;
    }
    
    UITextField *textField = self.inputView;
    
    NSString *toBeString = textField.text;
    
    UITextRange *selectedRange = [textField markedTextRange];
    //获取高亮部分
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position) {
        if (toBeString.length > self.maxInputLength) {
            textField.text = [toBeString mm_truncateByCharLength:self.maxInputLength];
        }
    }
}

- (void)showKeyboard
{
    [self.inputView becomeFirstResponder];
}

- (void)hideKeyboard
{
    [self.inputView resignFirstResponder];
}

@end


@interface MMAlertViewConfig1()

@end

@implementation MMAlertViewConfig1

+ (MMAlertViewConfig1 *)globalConfig1
{
    static MMAlertViewConfig1 *config1;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        config1 = [MMAlertViewConfig1 new];
        
    });
    
    return config1;
}

- (instancetype)init
{
    self = [super init];
    
    if ( self )
    {
        self.width          = 275.0f;
        self.buttonHeight   = 50.0f;
        self.innerMargin    = 25.0f;
        self.cornerRadius   = 5.0f;
        
        self.titleFontSize  = 18.0f;
        self.detailFontSize = 14.0f;
        self.buttonFontSize = 17.0f;
        
        self.backgroundColor    = MMHexColor(0xFFFFFFFF);
        self.titleColor         = MMHexColor(0x333333FF);
        self.detailColor        = MMHexColor(0x333333FF);
        self.splitColor         = MMHexColor(0xCCCCCCFF);
        
        self.itemNormalColor    = MMHexColor(0x333333FF);
        self.itemHighlightColor = MMHexColor(0xE76153FF);
        self.itemPressedColor   = MMHexColor(0xEFEDE7FF);
        
        self.defaultTextOK      = @"好";
        self.defaultTextCancel  = @"取消";
        self.defaultTextConfirm = @"确定";
    }
    
    return self;
}

@end






