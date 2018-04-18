//
//  AF_ScreeningViewController.m
//  差五个让步
//
//  Created by Elephant on 16/5/4.
//  Copyright © 2016年 Elephant. All rights reserved.
//

#import "AF_ScreeningViewController.h"

#import "AXPriceRangeCell.h"
#import "AF_BrandCell.h"

#define offset [UIScreen mainScreen].bounds.size.width - 50

@interface AF_ScreeningViewController () <UITableViewDataSource, UITableViewDelegate, AF_BrandCellDelegate>
{
    AXPriceRangeCell *priceRangeCell;
}
/** 重置按钮 */
@property (strong, nonatomic) UIButton * resetBut;
/** 确定按钮 */
@property (strong, nonatomic) UIButton * determineBut;
/** 展示tableView */
@property (strong, nonatomic) UITableView *tableV;
/** 选项标题数组 */
@property (strong, nonatomic) NSMutableArray *headerTitArr;
/** 选项数据数组 */
@property (strong, nonatomic) NSMutableArray *dataArr;
/** 是否展开状态数组 */
@property (strong, nonatomic) NSMutableArray *shrinkArr;
/** 是否选中状态字典 */
@property (strong, nonatomic) NSMutableDictionary *selectedDict;

@property (nonatomic,strong) NSMutableArray *selectMarray;

@property (nonatomic,strong) NSMutableArray *selectButtonMarray;

///

@property (nonatomic,strong)NSMutableArray *countryMarray;
@property (nonatomic,strong)NSMutableArray *weightMarray;
@property (nonatomic,strong)NSMutableArray *kindMarray;
@property (nonatomic,strong) NSString *countStr;
@property (nonatomic,strong) NSString *weightStr;
@property (nonatomic,strong) NSString *kindStr;

@property (nonatomic,strong) NSString *minPricesStr;
@property (nonatomic,strong) NSString *maxPricesStr;


@end

@implementation AF_ScreeningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.headerTitArr =self.headTieleMarray;
//    //[NSMutableArray arrayWithObjects:@"价格区间(自定义)"
//                                                         ,@"品牌(多选)"
//                                                         ,@"佩戴方式(多选)"
//                                                         , nil];
//    
    self.dataArr = self.itemButtonMarray;
    self.countryMarray = [NSMutableArray array];
    self.weightMarray = [NSMutableArray array];
    self.kindMarray = [NSMutableArray array];
    //[NSMutableArray arrayWithObjects:@[@"耳机",@"有线",@"充电插头",@"音频线"],@[@"苹果",@"三星",@"苹果1",@"三星",@"苹果2",@"三星"], nil];
    self.selectMarray = [NSMutableArray array];
    self.selectButtonMarray = [NSMutableArray array];
    
    [self.resetBut addTarget:self action:@selector(resetButClick) forControlEvents:UIControlEventTouchUpInside];
    [self.determineBut addTarget:self action:@selector(determineButClick) forControlEvents:UIControlEventTouchUpInside];

    [self.tableV reloadData];
}

#pragma mark - 按钮点击事件
//重置
- (void)resetButClick{
  
    AF_BrandCell *cell = [[AF_BrandCell alloc]init];
    [cell regiestButton:self.selectButtonMarray];
    [self.selectMarray removeAllObjects];
    [self.tableV reloadData];
}
//确定
- (void)determineButClick{
    
    NSMutableArray *strArr = [NSMutableArray array];//
    NSString *priceStr = [NSString stringWithFormat:@"%@-%@", priceRangeCell.priceText1.text, priceRangeCell.priceText2.text];

    [strArr addObject:priceStr];//
    NSLog(@"筛选条件 : \n%@", [self dictionaryToJson:self.selectMarray]);
    self.minPricesStr = priceRangeCell.priceText1.text;
    self.maxPricesStr = priceRangeCell.priceText2.text;
    
    if ([self.delegate respondsToSelector:@selector(determineButtonTouchEvent:maxPrice:countStr:weightStr:kindStr:)]) {
        
      [self.delegate determineButtonTouchEvent:self.minPricesStr maxPrice:self.maxPricesStr countStr:self.countStr weightStr:self.weightStr kindStr:self.kindStr];
    }
    
    
        NSLog(@"筛选条件 : \n%@", strArr);
}
/** 字典转json字符串 */
- (NSString*)dictionaryToJson:(id)data
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

/** 改变选项收缩状态 */
- (void)shrinkButClick:(UIButton *)button
{
 
}
#pragma mark -

#pragma mark - AF_BrandCellDelegate
//* 取得选中选项的值，改变选项状态，刷新列表
- (void)selectedValueChangeBlock:(NSInteger)section key:(NSInteger)index value:(NSString *)value button:(UIButton*)btn{


 
    if ([value isEqualToString:@"YES"]) {;
        if (section == 1) {
            [self.countryMarray addObject:self.dataArr[section-1][index][@"id"]];
        }else if (section == 2){
            [self.weightMarray addObject:self.dataArr[section-1][index][@"id"]];

        }else if (section == 3){
            [self.kindMarray addObject:self.dataArr[section-1][index][@"id"]];

        }
        
        
        [self.selectMarray addObject:self.dataArr[section-1][index]];
        
    }else{
        
        if (section == 1) {
            if ([self.countryMarray containsObject:self.dataArr[section-1][index][@"id"]]) {
                [self.countryMarray removeObject:self.dataArr[section-1][index][@"id"]];
            }

        
        
        
        }else if (section == 2){
            if ([self.weightMarray containsObject:self.dataArr[section-1][index][@"id"]]) {
                [self.weightMarray removeObject:self.dataArr[section-1][index][@"id"]];
            }
            
        }else if (section == 3){
            if ([self.kindMarray containsObject:self.dataArr[section-1][index][@"id"]]) {
                [self.kindMarray removeObject:self.dataArr[section-1][index][@"id"]];
            }
            
        }
        
        
        if ([self.selectMarray containsObject:self.dataArr[section-1][index]]) {
            [self.selectMarray removeObject:self.dataArr[section-1][index]];
        }
        
    }
    
  
     self.countStr = [self.countryMarray componentsJoinedByString:@","];
    self.weightStr = [self.weightMarray componentsJoinedByString:@","];

    self.kindStr = [self.kindMarray componentsJoinedByString:@","];

//    DLog(@"ssssssssss--------------%@" , string);

    [self.selectButtonMarray addObject:btn];
    
   
}
#pragma mark -

#pragma mark - tableView UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.headerTitArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArr.count !=0) {
        if (indexPath.section != 0) {
            AF_BrandCell *cell = [[AF_BrandCell alloc]init];
            cell.attributeArr = self.dataArr[indexPath.section-1];
            return cell.height;
    }
  
    }
    return 44;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, offset, 40)];
    
    UILabel *titLab = [[UILabel alloc]init];
    titLab.text = self.headerTitArr[section];
    titLab.font = [UIFont systemFontOfSize:13.0];
    CGSize titSize = [titLab.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0]}];
    titLab.textColor = [UIColor grayColor];
    titLab.frame = CGRectMake(5, 0, titSize.width, 40);
    [myView addSubview:titLab];
    

    return myView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *identifier = @"priceRangeCell";
        priceRangeCell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!priceRangeCell) {
            priceRangeCell = [[[NSBundle mainBundle] loadNibNamed:@"AXPriceRangeCell" owner:nil options:nil]lastObject];
            priceRangeCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        return priceRangeCell;
    }else {
        AF_BrandCell *cell = [AF_BrandCell cellWithTableView:tableView dataArr:self.dataArr[indexPath.section-1] indexPath:indexPath];
        /** 取消cell点击状态 */
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.tag = indexPath.section;
        cell.delegate = self;
 
        cell.attributeArr = self.dataArr[indexPath.section-1];
        
        return cell;
    }
}

#pragma mark -

#pragma mark - 懒加载
-(UITableView *)tableV
{
    if (!_tableV) {
        _tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.width, [UIScreen mainScreen].bounds.size.height- LL_TabbarSafeBottomMargin - 49) style:UITableViewStyleGrouped];
        _tableV.backgroundColor = [UIColor whiteColor];
        /** 隐藏cell分割线 */
        [_tableV setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableV.estimatedRowHeight = 0;
        _tableV.estimatedSectionHeaderHeight = 0;
        _tableV.estimatedSectionFooterHeight = 0;
        _tableV.delegate = self;
        _tableV.dataSource = self;
        [self.view addSubview:_tableV];
    }
    return _tableV;
}

- (UIButton *)resetBut//重置
{
    if (!_resetBut) {
        _resetBut = [[UIButton alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height -LL_TabbarSafeBottomMargin- 49, self.width/2, 49)];
        [_resetBut setBackgroundColor:[UIColor whiteColor]];
        [_resetBut setTitle:@"重置" forState:UIControlStateNormal];
        [_resetBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_resetBut setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [self.view addSubview:_resetBut];
    }
    return _resetBut;
}
- (UIButton *)determineBut//确定
{
    if (!_determineBut) {
        _determineBut = [[UIButton alloc]initWithFrame:CGRectMake(self.width/2, [UIScreen mainScreen].bounds.size.height -LL_TabbarSafeBottomMargin- 49, self.width/2, 49)];
        [_determineBut setBackgroundColor:[UIColor redColor]];
        [_determineBut setTitle:@"确定" forState:UIControlStateNormal];
        [_determineBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_determineBut setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [self.view addSubview:_determineBut];
    }
    return _determineBut;
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
