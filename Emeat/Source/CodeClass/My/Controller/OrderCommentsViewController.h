//
//  OrderCommentsViewController.h
//  Emeat
//
//  Created by liuheshun on 2018/10/11.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "SHLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderCommentsViewController : SHLBaseViewController


/////orderNo    Long    Y    订单编号
@property (nonatomic,strong) NSString *orderNo;
///evaluationStar    Integer    Y    评价星级（1,2,3,4,5）
@property (nonatomic,strong) NSString *evaluationStar;
///evaluationTable    String    N    评价标签（字符串，用逗号隔开传入）
@property (nonatomic,strong) NSString *evaluationTable;
///evaluationDetail    String    Y    评价详情（超过300直接截取前300个字）
@property (nonatomic,strong) NSString *evaluationDetail;
///picture    String    N    评价图片（字符串）
@property (nonatomic,strong) NSString *picture;


@end

NS_ASSUME_NONNULL_END
