//
//  MapLocationHelper.h
//  TSMap
//
//  Created by tunsuy on 28/4/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

@interface MapLocationHelper : NSObject

+ (CLPlacemark *)getPlacemarkByAddress:(NSString *)address;
+ (CLPlacemark *)getPlacemarkByLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude;
+ (CLLocation *)getCoordinateByAddress:(NSString *)address;
+ (NSString *)getAddressByLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude;

+ (void)translationMapWithMapView:(MKMapView *)mapView offsetXPixel:(CGFloat)offsetXPixel offsetYPixel:(CGFloat)offsetYPixel;

@end
