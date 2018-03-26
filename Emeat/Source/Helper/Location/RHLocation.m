//
//  RHLocation.m
//  selectAddressDemo
//
//  Created by liuheshun on 2017/12/1.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import "RHLocation.h"
@interface RHLocation () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager * locationManager;
@end
@implementation RHLocation

#pragma mark - public
- (void)beginUpdatingLocation {
    
    [self startLocation];
}

//开始定位
- (void)startLocation {
    
    if([CLLocationManager locationServicesEnabled]) {
        //定位初始化
        self.locationManager=[[CLLocationManager alloc] init];
        self.locationManager.delegate=self;
        self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        self.locationManager.distanceFilter=10;
//        if ([[UIDevice currentDevice].systemVersion intValue]>=8) {
            [ self.locationManager requestWhenInUseAuthorization];//使用程序其间允许访问位置数据（iOS8定位需要）
//        }
        [_locationManager startUpdatingLocation];//开启定位
    }else {
//        //提示用户无法进行定位操作
//        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"定位失败,请确认开启定位..." delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        [alertView show];
    }
    

}



#pragma mark - location delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    //获取新的位置
    CLLocation * newLocation = locations.lastObject;
    
    //创建自定制位置对象
    Location * location = [[Location alloc] init];
    
    //存储经度
    location.longitude = newLocation.coordinate.longitude;
    
    //存储纬度
    location.latitude = newLocation.coordinate.latitude;
 
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error){
        if (array.count > 0){
            CLPlacemark *placemark = [array objectAtIndex:0];
            
            //获取城市
            NSString *city = placemark.locality;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            
            //存储位置信息
            location.country = placemark.country;
            location.city = city;
            location.locality = placemark.locality;
            location.subLocality = placemark.subLocality;
            location.thoroughfare = placemark.thoroughfare;
            location.subThoroughfare = placemark.subThoroughfare;
            location.name = placemark.name;
            location.administrativeArea = placemark.administrativeArea;
            //设置代理方法
            if ([self.delegate respondsToSelector:@selector(locationDidEndUpdatingLocation:)]) {
                
                [self.delegate locationDidEndUpdatingLocation:location];
            }
            NSLog(@"city = %@", city);//石家庄市
            NSLog(@"--%@",placemark.name);//黄河大道221号
            NSLog(@"++++%@",placemark.subLocality); //裕华区
            NSLog(@"country == %@",placemark.country);//中国
            NSLog(@"administrativeArea == %@",placemark.administrativeArea); //河北省
        }
        else if (error == nil && [array count] == 0)
        {
            NSLog(@"No results were returned.");
        }
        else if (error != nil)
        {
            NSLog(@"An error occurred = %@", error);
        }
    }];
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];

}

#pragma mark - setter and getter
- (CLLocationManager *)locationManager {
    
    if (!_locationManager) {
        
        _locationManager = [[CLLocationManager alloc] init];
        
        _locationManager.delegate = self;
        
        // 设置定位精确度
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        // 设置过滤器为无
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        
        // 取得定位权限，有两个方法，取决于你的定位使用情况
        // 一个是 requestAlwaysAuthorization
        // 一个是 requestWhenInUseAuthorization
        [_locationManager requestAlwaysAuthorization];//ios8以上版本使用。
    }
    return _locationManager;
}




@end
