//
//  NSString+textFieldCategory.h
//  Emeat
//
//  Created by liuheshun on 2018/2/6.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (textFieldCategory)
- (NSInteger)getStringLenthOfBytes;

- (NSString *)subBytesOfstringToIndex:(NSInteger)index;

@end
