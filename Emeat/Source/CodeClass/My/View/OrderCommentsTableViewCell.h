//
//  OrderCommentsTableViewCell.h
//  Emeat
//
//  Created by liuheshun on 2018/10/11.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderCommentsTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *commentsPlaceholderLab;

@property (nonatomic,strong) NSMutableArray *starMarray;

@property (nonatomic,strong) UIButton *commentsLabBtn;

@property (nonatomic,strong) UITextView *commentsTextView;

@property (nonatomic,strong) UIButton *sendImageBtn;


@property (nonatomic,strong) UIButton *selectedBtn;



@end

NS_ASSUME_NONNULL_END
