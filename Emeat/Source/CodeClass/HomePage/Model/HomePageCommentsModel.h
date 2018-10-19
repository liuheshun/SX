//
//  HomePageCommentsModel.h
//  Emeat
//
//  Created by liuheshun on 2018/10/13.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomePageCommentsModel : NSObject
///评价星级
@property (nonatomic,strong) NSString *evaluationStar;

///评价详情内容
@property (nonatomic,strong) NSString *evaluationDetail;
///评价标签
@property (nonatomic,strong) NSString *evaluationTable;
///评价图片
@property (nonatomic,strong) NSString *picture;
///评价时间
@property (nonatomic,strong) NSString *evaluationDate;
///名字
@property (nonatomic,strong) NSString *nickname;
///头像
@property (nonatomic,strong) NSString *headPic;

/**
 是否折叠，默认NO，折叠
 */
@property (nonatomic, assign) BOOL unfold;




@end

NS_ASSUME_NONNULL_END
