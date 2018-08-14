//
//  GYChangeTextView.h
//  Emeat
//
//  Created by liuheshun on 2018/8/4.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GYChangeTextView;

@protocol GYChangeTextViewDelegate <NSObject>

- (void)gyChangeTextView:(GYChangeTextView *)textView didTapedAtIndex:(NSInteger)index;

@end

@interface GYChangeTextView : UIView

@property (nonatomic, assign) id<GYChangeTextViewDelegate> delegate;

- (void)animationWithTexts:(NSArray *)textAry;
- (void)stopAnimation;


@end
