//
//  HomePageDetailsViewController.h
//  Emeat
//
//  Created by liuheshun on 2017/11/20.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomePageDetailsViewController : SHLBaseViewController
///详情id
@property (nonatomic,strong) NSString *detailsId;
///是否来自banner图 1来自banner
@property (nonatomic,strong) NSString *fromBaner;


@end
