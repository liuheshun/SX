//
//  CardModel.h
//  CardSwitchDemo
//
//  Created by Apple on 2017/1/6.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLCardItem : NSObject

@property (nonatomic, copy) NSString *imageName;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *newsPrices;
@property (nonatomic, copy) NSString *oldPrices;

@end
