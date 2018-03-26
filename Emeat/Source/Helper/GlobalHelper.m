//
//  GlobalHelper.m
//  Emeat
//
//  Created by liuheshun on 2017/12/25.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import "GlobalHelper.h"

@implementation GlobalHelper

+(GlobalHelper *)shareInstance{
    static GlobalHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[GlobalHelper alloc] init];
        helper.addShoppingCartMarray = [NSMutableArray array];
        helper.isLoginState = @"0";
        helper.isSelectFirstAllOrder = @"100";
        
    });
    return helper;
}

-(void)emptyViewNoticeText:(NSString*)noticeText NoticeImageString:(NSString*)noticeImageString viewWidth:(CGFloat)width viewHeight:(CGFloat)height UITableView:(UITableView*)tableView{


    UIImageView *emptyImv = [[UIImageView alloc] init];
    [tableView addSubview : emptyImv];
    [emptyImv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo([[UIApplication  sharedApplication ]keyWindow]);
        make.top.equalTo([[UIApplication  sharedApplication ]keyWindow]).with.offset(275);
        make.width.equalTo(@(width));
        make.height.equalTo(@(height));
        
    }];
    emptyImv.image = [UIImage imageNamed:noticeImageString];
    
    UILabel *emptyLable = [[UILabel alloc] init];
    emptyLable.font = [UIFont systemFontOfSize:15.0f];
    emptyLable.textColor = RGB(136, 136, 136, 1);
    emptyLable.text = noticeText;
    emptyLable.textAlignment = NSTextAlignmentCenter;
    [tableView addSubview:emptyLable];
    [emptyLable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo([[UIApplication  sharedApplication ]keyWindow]);
        make.top.equalTo(emptyImv.mas_bottom).with.offset(25);
        make.height.equalTo(@20);
        
    }];
    
    self.emptyLable = emptyLable;
    self.emptyImv = emptyImv;
}


-(void)removeEmptyView{
    [self.emptyLable removeFromSuperview];
    [self.emptyImv removeFromSuperview];
    
    
}



@end
