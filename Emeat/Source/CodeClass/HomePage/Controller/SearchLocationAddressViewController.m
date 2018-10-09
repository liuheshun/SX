//
//  SearchLocationAddressViewController.m
//  Emeat
//
//  Created by liuheshun on 2017/12/12.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import "SearchLocationAddressViewController.h"
#import "RHLocation.h"
#import "DDSearchManager.h"
#import "AddNewAddressViewController.h"
#import "Location.h"
@interface SearchLocationAddressViewController ()<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,RHLocationDelegate , UISearchBarDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UISearchBar *searchBar;
@property (nonatomic,strong) UIButton *cancleBtn;
@property (nonatomic,strong) RHLocation *rhLocation;
//附近地址数据源
@property (nonatomic,strong) NSMutableArray *otherAddressArray;
//搜索地址数据源
@property (nonatomic,strong) NSMutableArray *searchMarray;

//当前定位地址信息
@property (nonatomic,strong) Location *currentLocation;

@property (nonatomic,strong) NSString *currenrLocationString;

@property (nonatomic,assign) BOOL isSearchController;


@end

@implementation SearchLocationAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(238, 238, 238, 1);
    self.navItem.title = @"搜索地址";
    self.otherAddressArray = [NSMutableArray array];
    self.searchMarray = [NSMutableArray array];
    [self loadinglocation];
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.tableView];
    _isSearchController = NO;
}

#pragma mark =定位点击事件

-(void)loadinglocation{
    [self setLocations];
}


#pragma mark = 定位

-(void)setLocations{
    self.rhLocation = [[RHLocation alloc] init];
    self.rhLocation.delegate = self;
    [self.rhLocation beginUpdatingLocation];
}

- (void)locationDidEndUpdatingLocation:(Location *)location{
    //self.currentAddressString = location.name;
    self.currenrLocationString = location.name;
    self.currentLocation = location;
    DLog(@"xxxxxxx==%@  %@" ,location.thoroughfare ,location.name);

    [self getAddresspoiWithLocation:location];
}

-(void)getAddresspoiWithLocation:(Location*)location{
    
    //逆地理编码，请求附近兴趣点数据
    [[DDSearchManager sharedManager] poiReGeocode:CLLocationCoordinate2DMake(location.latitude,location.longitude) returnBlock:^(NSArray<__kindof DDSearchPoi *> *pois) {
        
        [self.otherAddressArray removeAllObjects];
        for (DDSearchPoi *poi in pois) {
            if (![self.otherAddressArray containsObject:poi.name]) {
                [self.otherAddressArray addObject:poi.name];
            }
        }
        [self.otherAddressArray insertObject:self.currenrLocationString atIndex:0];
        [self.tableView reloadData];
        
    }];
    
}


-(void)searchAddressForSearchText:(NSString*)searchText{
    
    [[DDSearchManager sharedManager] keyWordsSearch:searchText city:@"" returnBlock:^(NSArray<__kindof DDSearchPointAnnotation *> *pointAnnotaions) {
        if (self.searchMarray.count > 0) {
            [self.searchMarray removeAllObjects];
        }
        for (DDSearchPointAnnotation *poi in pointAnnotaions) {
            
            [self.searchMarray addObject:poi];
        }
        [self.tableView reloadData];
        
    }];
    
}





-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length ==0) {
        
        _isSearchController = NO;
        [self.tableView reloadData];
    }else{
        _isSearchController = YES;
        [self searchAddressForSearchText:searchText];

    }
   
    
    
    
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    

}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    _isSearchController = YES;
    [searchBar resignFirstResponder];
    [self searchAddressForSearchText:searchBar.text];

}

- (UIImage*) GetImageWithColor:(UIColor*)color andHeight:(CGFloat)height
{
    CGRect r= CGRectMake(0.0f, 0.0f, 1.0f, height);
    UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, r);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}


-(UISearchBar*)searchBar{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake((kWidth-345)/2, kBarHeight+10, 345, 29)];
        _searchBar.placeholder = @"查找你的地址";
        _searchBar.delegate = self;
        // 样式
        _searchBar.searchBarStyle = UISearchBarStyleProminent;
        UIImage* searchBarBg = [self GetImageWithColor:[UIColor clearColor] andHeight:32.0f];

        //设置背景图片
        [_searchBar setBackgroundImage:searchBarBg];
        //设置背景色
       // [_searchBar setBackgroundColor:[UIColor clearColor]];
        //设置文本框背景
        [_searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"searchBgView"] forState:UIControlStateNormal];
 
        
    }
    return _searchBar;
}




-(UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MaxY(self.searchBar)+10, kWidth, kHeight-kBarHeight-49 - LL_TabbarSafeBottomMargin) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_isSearchController == NO) {
        return self.otherAddressArray.count;

    }else{
    return self.searchMarray.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
    return 0.01;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 0.01)];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 15)];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (_isSearchController == NO) {
        UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"NOSearch_cell"];
        if (cell1 == nil) {
            cell1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NOSearch_cell"];
           // [cell1 setSelectionStyle:UITableViewCellSelectionStyleNone]; //取消选中的阴影效果
        }
        
        cell1.backgroundColor = [UIColor whiteColor];
        cell1.textLabel.text = self.otherAddressArray[indexPath.row];
        return cell1;
        
    }else{
        
        UITableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"Search_cell"];
        if (cell2 == nil) {
            cell2 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Search_cell"];
          //  [cell2 setSelectionStyle:UITableViewCellSelectionStyleNone]; //取消选中的阴影效果
        }
        cell2.backgroundColor = [UIColor whiteColor];
        if (self.searchMarray.count!=0) {
            DDSearchPointAnnotation *poi = self.searchMarray[indexPath.row];
            cell2.textLabel.text = poi.name ;
        }
        
        
        return cell2;
    }
    
}

#pragma mark  = tableView点击事件


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_isSearchController == NO) {
        
        self.currentLocation.name = self.otherAddressArray[indexPath.row];
        if ([self respondsToSelector:@selector(returnSearchAddressBlock)]) {
            self.returnSearchAddressBlock(self.currentLocation);
            
        }
        

        
    }else{
        
        if (self.searchMarray.count != 0) {
            DDSearchPointAnnotation *poi = self.searchMarray[indexPath.row];
            Location *currentLocation = [[Location alloc] init];
            currentLocation.name = poi.name;
            currentLocation.administrativeArea = poi.province;
            currentLocation.city = poi.city;
            currentLocation.subLocality = poi.district;//区域名称
            currentLocation.thoroughfare = poi.address;
            if ([self respondsToSelector:@selector(returnSearchAddressBlock)]) {
                self.returnSearchAddressBlock(currentLocation);
                
            }
        }
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];

    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
