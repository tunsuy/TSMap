//
//  TSAnnotation.h
//  TSMap
//
//  Created by tunsuy on 27/4/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface TSAnnotation : NSObject<MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, strong) UIImage *image;

- (instancetype)initWithLocationCoordinate2D:(CLLocationCoordinate2D)locationCoordinate2D
                                       title:(NSString *)title
                                    subtitle:(NSString *)subtitle
                                       image:(UIImage *)image;
//- (instancetype)initWithLocationCoordinate2D:(CLLocationCoordinate2D)locationCoordinate2D
//                                       title:(NSString *)title
//                                    subtitle:(NSString *)subtitle;
@end
