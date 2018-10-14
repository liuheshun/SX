//
//  HomePageCommentDetailsTableViewCell.h
//  Emeat
//
//  Created by liuheshun on 2017/11/21.
//  Copyright © 2017年 liuheshun. All rights reserved.
//评价详情cell

#import <UIKit/UIKit.h>
#import "HomePageCommentsModel.h"

@interface HomePageCommentDetailsTableViewCell : UITableViewCell
//头像
@property (nonatomic,strong) UIImageView *commentUserImv;
//名字
@property (nonatomic,strong) UILabel *commentNameLab;
//时间
@property (nonatomic,strong) UILabel *commentTimeLab;
//商品
@property (nonatomic,strong) UILabel *goodsLab;
//商品星星评价
@property (nonatomic,strong) UIButton *goodsStarBtn;
//配送
@property (nonatomic,strong) UILabel *sendLab;
//配送星星评价
@property (nonatomic,strong) UIButton *sendStarBtn;
//评论详情
@property (nonatomic,strong) UILabel *commentDetailsLab;
//评论图片
@property (nonatomic,strong) UIImageView *commentDescImv;

///标签
@property (nonatomic,strong) UIButton *commentsLabBtn;


-(void)setGoodsStartArray:(NSMutableArray*)goodsStatArray andCommentDescImvArray:(NSMutableArray*)descImvArray CommentsLabsMarray:(NSMutableArray*)commentsLabsMarray ConfigWithConmmentsModel:(HomePageCommentsModel*)commentsModel;

//@property (nonatomic,strong) NSArray *goodsStarArray;
//
//@property (nonatomic,strong) NSArray *sendStarArray;
//





@end
