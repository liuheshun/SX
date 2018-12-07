//
//  VersionUpdateView.h
//  Emeat
//
//  Created by liuheshun on 2018/5/7.
//  Copyright © 2018年 liuheshun. All rights reserved.
//版本更新

#import <UIKit/UIKit.h>

@interface VersionUpdateView : UIView
@property (nonatomic,strong) UIImageView *topImageView;

@property (nonatomic,strong) UIView *midBgView;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UIView *bottomBgView;

@property (nonatomic,strong) UIButton *updateBtn;
@property (nonatomic,strong) UIButton *cancleBtn;



@end


@interface VersionUpdateViewConfig : NSObject
+ (VersionUpdateViewConfig*) UpdateViewConfig;

@property (nonatomic,strong) NSString *imageString;
@property (nonatomic,strong) NSString *titleString;
@property (nonatomic,strong) NSString *isShowCancelBtn;



@end



