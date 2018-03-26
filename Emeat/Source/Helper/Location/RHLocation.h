//
//  RHLocation.h
//  selectAddressDemo
//
//  Created by liuheshun on 2017/12/1.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Location.h"
@protocol RHLocationDelegate;

@interface RHLocation : NSObject
@property (nonatomic, weak) id<RHLocationDelegate> delegate;

- (void)beginUpdatingLocation;

@end

@protocol RHLocationDelegate <NSObject>

- (void)locationDidEndUpdatingLocation:(Location *)location;


@end
