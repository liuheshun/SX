//
//  GetWidthAndHeightOfString.m
//  Emeat
//
//  Created by liuheshun on 2017/12/4.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import "GetWidthAndHeightOfString.h"

@implementation GetWidthAndHeightOfString

+ (CGFloat)getHeightForText:(UILabel *)label width:(CGFloat)width{
    
    CGSize sizePeopleLab = [label sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    return sizePeopleLab.height;
}

+ (CGFloat)getWidthForText:(id)label  height:(CGFloat)height{
    
    CGSize sizePeopleLab = [label sizeThatFits:CGSizeMake(MAXFLOAT, height)];
    return sizePeopleLab.width;
}




@end
