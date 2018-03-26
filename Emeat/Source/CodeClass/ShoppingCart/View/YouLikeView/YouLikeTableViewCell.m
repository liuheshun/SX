//
//  YouLikeTableViewCell.m
//  Emeat
//
//  Created by liuheshun on 2017/11/17.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import "YouLikeTableViewCell.h"
#import "YouLikeCollectionViewCell.h"

@implementation YouLikeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        DLog(@"==xxxxxxxxxxx============= %f" , self.collViewHeight);
        [self setCollectViews];
    }
    return self;
}


//-(void)setCollViewHeight:(CGFloat)collViewHeight{
//    self.collViewHeight = collViewHeight;
//}

-(void)configHeight:(CGFloat)height{
    
    CGRect rect = self.CollView.frame;
    rect.size.height = self.collViewHeight;
    self.CollView.frame = rect;
    
}

-(void)setCollectViews{
    DLog(@"=============== %f" , self.collViewHeight);

    
    //1.初始化layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //2.初始化collectionView
    self.CollView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 100) collectionViewLayout:layout];
    [self addSubview:self.CollView];
    self.CollView.backgroundColor = [UIColor clearColor];
    //防止出现collerview滚动
    self.CollView.scrollEnabled = NO;
    //        cell.CollView.bounces = NO;
    //3.注册collectionViewCell
    //注意，此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致 均为 cellId
    [self.CollView registerClass:[YouLikeCollectionViewCell class] forCellWithReuseIdentifier:@"CollCell_like"];
    
    //注册headerView  此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致  均为reusableView
    [self.CollView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView"];
    
    //4.设置代理
    self.CollView.delegate = self;
    self.CollView.dataSource = self;
    
    
}


//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.HomeArray.count;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomePageModel *HModel = [self.HomeArray objectAtIndex:indexPath.row];
    
    YouLikeCollectionViewCell *collcell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollCell_like" forIndexPath:indexPath];    
//    collcell.backgroundColor = [UIColor orangeColor];
  //  [collcell setUI];

    [collcell SetCollCellData:HModel];
    [collcell.joinCartBtn addTarget:self action:@selector(joinCartBtnAction:) forControlEvents:1];
    collcell.joinCartBtn.tag = indexPath.row;
    
    return collcell;
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    return CGSizeMake(135, 160);
    return CGSizeMake(135*kScale, 180*kScale);


}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 30*kScale, 0, 30*kScale);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10*kScale;
}


//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 20*kScale;
}


#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    //代理传值
    if([self.delegateColl respondsToSelector:@selector(ClickCooRow:)])
    {
        [self.delegateColl ClickCooRow:indexPath.row];
    }
    
}

//接收数据
-(void)getHomeArray:(NSArray *)homeArray
{
    self.HomeArray = homeArray;
}





-(void)joinCartBtnAction:(UIButton*)btn{
    if ([self respondsToSelector:@selector(joinCartBtnAction:)]) {
        self.clickIndexBlock(btn.tag);
    }
    
}




@end
