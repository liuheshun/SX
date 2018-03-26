//
//  EmptyStatusViews.m
//  Emeat
//
//  Created by liuheshun on 2018/3/13.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "EmptyStatusViews.h"

@implementation EmptyStatusViews
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
+(void)emptyViewNoticeText:(NSString*)noticeText NoticeImageString:(NSString*)noticeImageString viewWidth:(CGFloat)width viewHeight:(CGFloat)height UITableView:(UITableView*)tableView{
    
    
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
    
    

}


-(void)removeEmptyView{
    [self.emptyLable removeFromSuperview];
    [self.emptyImv removeFromSuperview];
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
