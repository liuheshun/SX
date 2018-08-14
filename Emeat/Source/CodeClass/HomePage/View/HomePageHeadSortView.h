//
//  HomePageHeadSortView.h
//  Emeat
//
//  Created by liuheshun on 2018/8/1.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^ReturnClickSortTitleIndex)(NSInteger index ,NSString*sortTitle);

/////商户专区分类view
@interface HomePageHeadSortView : UIView

@property (nonatomic,strong) UIButton *sortBtn;

@property (nonatomic,copy) ReturnClickSortTitleIndex returnClickSortIndex;


-(void)setHomePageSortUIButtions:(NSMutableArray*)BtnMarray;


@end
