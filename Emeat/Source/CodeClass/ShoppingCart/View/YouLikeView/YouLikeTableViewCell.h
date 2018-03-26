//
//  YouLikeTableViewCell.h
//  Emeat
//
//  Created by liuheshun on 2017/11/17.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  block，购物车点击事件
 */

typedef void(^collectionClickIndexBlock)(NSInteger index);




/**
 *  代理，用来传递点击的是第几行,当触CollectionView的时候
 */
@protocol  delegateColl <NSObject>

-(void)ClickCooRow :(NSInteger)CellRow;

@end

@interface YouLikeTableViewCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate>

/**
 *  数据源数组用来接受controller传过来的数据
 */
@property (strong, nonatomic) NSArray *HomeArray;


@property (strong, nonatomic)  UICollectionView *CollView;


@property (weak, nonatomic) id <delegateColl> delegateColl;


@property (nonatomic, copy) collectionClickIndexBlock clickIndexBlock;

@property (nonatomic,assign) CGFloat collViewHeight;



-(void)configHeight:(CGFloat)height;


@end
