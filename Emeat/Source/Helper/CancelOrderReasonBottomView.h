//
//  CancelOrderReasonBottomView.h
//  Emeat
//
//  Created by liuheshun on 2018/11/15.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CancelOrderReasonBottomView : UIView<UITextViewDelegate>

@property(nonatomic,strong)UILabel *residueLabel;// 输入文本时剩余字数
@property (nonatomic,strong) NSString *conmmentString;
@property (nonatomic,strong) UITextView *textView;
@property (nonatomic,strong) UILabel *placeHolderLabel;

@property (nonatomic,strong) UIButton *cancelBtn;
@property (nonatomic,strong) UIButton *confirmBtn;


-(void)isShowOtherReason:(NSInteger)isShow;



@end

NS_ASSUME_NONNULL_END
