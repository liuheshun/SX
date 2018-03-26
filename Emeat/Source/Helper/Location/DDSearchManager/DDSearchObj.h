//
//  DDSearchObj.h
//  GDAddressSelected
//
//  Created by Dry on 2017/8/4.
//  Copyright © 2017年 Dry. All rights reserved.
//
//  该文件定义了搜索结果的基础数据类型。
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface DDSearchObj : NSObject



@end


///输入提示
@interface DDSearchTip : DDSearchObj

///名称
@property (nonatomic, copy) NSString   *name;
///区域编码
@property (nonatomic, copy) NSString   *adcode;
///所属区域
@property (nonatomic, copy) NSString   *district;
///地址
@property (nonatomic, copy) NSString   *address;
///经纬度
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end


///点标注数据
@interface DDSearchPointAnnotation : DDSearchObj

///经纬度
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
/////标题
//@property (nonatomic, copy) NSString *title;
/////副标题
//@property (nonatomic, copy) NSString *subtitle;


///详细地址名称
@property (nonatomic, copy)   NSString     *name;
///兴趣点类型
@property (nonatomic, copy)   NSString     *type;
///类型编码
@property (nonatomic, copy)   NSString     *typecode;
///地址
@property (nonatomic, copy)   NSString     *address;


///省
@property (nonatomic, copy)   NSString     *province;

///城市名称
@property (nonatomic, copy)   NSString     *city;
///城市编码
@property (nonatomic, copy)   NSString     *citycode;
///区域名称
@property (nonatomic, copy)   NSString     *district;

///是否有室内地图
@property (nonatomic, assign) BOOL          hasIndoorMap;
///所在商圈
@property (nonatomic, copy)   NSString     *businessArea;











@end


///POI点
@interface DDSearchPoi : DDSearchObj;

///详细地址名称
@property (nonatomic, copy) NSString               *name;
///地址
@property (nonatomic, copy) NSString               *address;
///经纬度
@property (nonatomic      ) CLLocationCoordinate2D coordinate;
///城市
@property (nonatomic, copy) NSString *city;
///城市编码
@property (nonatomic, copy) NSString *cityCode;
//省
@property (nonatomic,strong) NSString *province;
///区域名称
@property (nonatomic, copy)   NSString *district;


@end


