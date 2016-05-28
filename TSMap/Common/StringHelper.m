//
//  StringHelper.m
//  TSMap
//
//  Created by tunsuy on 27/4/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import "StringHelper.h"

@implementation StringHelper

//判断是否为整形：

+ (BOOL)isPureInt:(NSString *)string {
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为浮点形：

+ (BOOL)isPureFloat:(NSString *)string {
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

@end
