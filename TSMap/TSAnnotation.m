//
//  TSAnnotation.m
//  TSMap
//
//  Created by tunsuy on 27/4/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import "TSAnnotation.h"

@implementation TSAnnotation

- (instancetype)initWithLocationCoordinate2D:(CLLocationCoordinate2D)locationCoordinate2D title:(NSString *)title subtitle:(NSString *)subtitle image:(UIImage *)image{
    if (self = [super init]) {
        self.coordinate = locationCoordinate2D;
        self.title = title;
        self.subtitle = title;
        self.image = image;
    }
    return self;
}

//- (instancetype)initWithLocationCoordinate2D:(CLLocationCoordinate2D)locationCoordinate2D title:(NSString *)title subTitle:(NSString *)subTitle {
//    if (self = [super init]) {
//        self.coordinate = locationCoordinate2D;
//        self.title = title;
//        self.subTitle = title;
//    }
//    return self;
//}

@end
