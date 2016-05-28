//
//  MapLocationHelper.m
//  TSMap
//
//  Created by tunsuy on 28/4/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import "MapLocationHelper.h"

@interface MapLocationHelper ()

@property (nonatomic, strong) CLGeocoder *geocoder;

@end

@implementation MapLocationHelper

#pragma mark - 位置坐标编码与逆编码
+ (CLPlacemark *)getPlacemarkByAddress:(NSString *)address {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    __block CLPlacemark *placemark;
    [geocoder geocodeAddressString:address completionHandler:^(NSArray<CLPlacemark *> *placemarks, NSError *error){
        placemark = [placemarks firstObject];
    }];
    return placemark;
}

+ (CLPlacemark *)getPlacemarkByLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    __block CLPlacemark *placemark;
    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> *placemarks, NSError *error){
        placemark = [placemarks firstObject];

    }];
    return placemark;
}

+ (CLLocation *)getCoordinateByAddress:(NSString *)address {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    __block CLLocation *location = [[CLLocation alloc] init];
    [geocoder geocodeAddressString:address completionHandler:^(NSArray<CLPlacemark *> *placemarks, NSError *error){
        CLPlacemark *placemark = [placemarks firstObject];
        location = placemark.location;
    }];
    return location;
}

+ (NSString *)getAddressByLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    __block NSString *address;
    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> *placemarks, NSError *error){
        CLPlacemark *placemark = [placemarks firstObject];
        address = placemark.addressDictionary[@"Name"];
    }];
    return address;
}

+ (void)translationMapWithMapView:(MKMapView *)mapView offsetXPixel:(CGFloat)offsetXPixel offsetYPixel:(CGFloat)offsetYPixel {
    /** 一个纬度包含的像素数 */
    CGFloat pixelsPerDegreeLat = mapView.frame.size.height / mapView.region.span.latitudeDelta;
    /** 一个经度包含的像素数 */
    CGFloat pixelsPerDegreeLon = mapView.frame.size.width / mapView.region.span.longitudeDelta;
    /** 将需要移动的像素转换成度数 */
    CLLocationDegrees offsetLatDegree = offsetYPixel / pixelsPerDegreeLat;
    CLLocationDegrees offsetLonDegree = offsetXPixel / pixelsPerDegreeLon;
    
    CLLocationCoordinate2D coordinate = {
        mapView.centerCoordinate.latitude + offsetLatDegree,
        mapView.centerCoordinate.longitude + offsetLonDegree
    };
    
    mapView.centerCoordinate = coordinate;
}

@end
