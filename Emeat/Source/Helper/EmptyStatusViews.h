//
//  EmptyStatusViews.h
//  Emeat
//
//  Created by liuheshun on 2018/3/13.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmptyStatusViews : UIView
//空状态
+(void)emptyViewNoticeText:(NSString*)noticeText NoticeImageString:(NSString*)noticeImageString viewWidth:(CGFloat)width viewHeight:(CGFloat)height UITableView:(UITableView*)tableView;
-(void)removeEmptyView;
@property (nonatomic,strong) UIImageView *emptyImv;
@property (nonatomic,strong) UILabel *emptyLable;

@end
