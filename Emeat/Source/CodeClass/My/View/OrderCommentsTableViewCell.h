//
//  OrderCommentsTableViewCell.h
//  Emeat
//
//  Created by liuheshun on 2018/10/11.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ReturnComments)(NSString *commets);

NS_ASSUME_NONNULL_BEGIN

@interface OrderCommentsTableViewCell : UITableViewCell<UITextViewDelegate>

@property (nonatomic,strong) UILabel *commentsPlaceholderLab;

@property (nonatomic,strong) NSMutableArray *starMarray;

@property (nonatomic,strong) UIButton *commentsLabBtn;

@property (nonatomic,strong) UITextView *commentsTextView;

@property(nonatomic,strong)UILabel *placeHolderLabel;
@property(nonatomic,strong)UILabel *residueLabel;// 输入文本时剩余字数
@property (nonatomic,strong) NSString *conmmentString;

@property (nonatomic,strong) UIButton *sendImageBtn;

@property (nonatomic,strong) UIButton *sendImageBtn2;
@property (nonatomic,strong) UIButton *sendImageBtn3;

@property (nonatomic,copy) ReturnComments returnCommentsLabels;

@property (nonatomic,copy) ReturnComments returnCommentsStarts;

@property (nonatomic,strong) UIButton *selectedBtn;

@property (nonatomic,strong) NSMutableArray *selectCommentsLabelsMarray;

///照片删除按钮
@property (nonatomic,strong) UIButton *deleteImvBtn;
@property (nonatomic,strong) UIButton *deleteImvBtn2;
@property (nonatomic,strong) UIButton *deleteImvBtn3;


@end

NS_ASSUME_NONNULL_END
