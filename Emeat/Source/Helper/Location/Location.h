//
//  Location.h
//  Emeat
//
//  Created by liuheshun on 2017/12/4.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Location : NSObject
///国家
@property (nonatomic, copy) NSString * country;
///省
@property (nonatomic,strong) NSString *administrativeArea;

/// 直辖市
@property (nonatomic, copy) NSString * city;
/// 地级市 直辖市区
@property (nonatomic, copy) NSString * locality;
///县 区
@property (nonatomic, copy) NSString * subLocality;
///街道
@property (nonatomic, copy) NSString * thoroughfare;
///子街道
@property (nonatomic, copy) NSString * subThoroughfare;
///具体位置
@property (nonatomic,strong) NSString *name;

///经度
@property (nonatomic, assign) CLLocationDegrees longitude;
///纬度
@property (nonatomic, assign) CLLocationDegrees latitude;

@end
