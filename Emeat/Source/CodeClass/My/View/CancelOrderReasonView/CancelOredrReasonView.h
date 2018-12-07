//
//  CancelOredrReasonView.h
//  Emeat
//
//  Created by liuheshun on 2018/11/14.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CancelOrderReasonBottomView.h"

typedef void(^ConfirmBtnAction)(NSString *reasonIndexString ,NSString *otherReasonString);

NS_ASSUME_NONNULL_BEGIN

@interface CancelOredrReasonView : UIView<UITableViewDelegate ,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataMarray;

@property (nonatomic,assign) NSInteger isShow;

@property (nonatomic,strong) CancelOrderReasonBottomView *cancelOrderBottomView;

@property (nonatomic,copy) ConfirmBtnAction confirmBtnActions;

@property (nonatomic,strong) NSString *reasonMarrayIndex;
@property (nonatomic,strong) NSString *otherReasonString;
@property (nonatomic,strong) NSMutableArray *titleMarray;

///单选，当前选中的行
@property (assign, nonatomic) NSIndexPath *selIndex;

-(void)hideAllView;

@end

NS_ASSUME_NONNULL_END
