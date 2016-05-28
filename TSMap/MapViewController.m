//
//  MapViewController.m
//  TSMap
//
//  Created by tunsuy on 27/4/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import "MapViewController.h"
#import "TSAnnotation.h"
#import "MapLocationHelper.h"

@interface MapViewController ()<MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate>

@property (nonatomic, strong) TSAnnotation *annotation;
@property (nonatomic, strong) MKPointAnnotation *pointAnnotation;
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) UISearchBar *addressSearchBar;

@property (nonatomic, copy) NSString *userAddress;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setUpMap];
//    [self addAnnotation];
    [self setUpSearchBar];
//    [self showWholeChina];
    
//    [self translationMapView];
    
}

#pragma mark - View lifeStyle
- (void)viewDidAppear:(BOOL)animated {
    _locationManager = [[CLLocationManager alloc] init];
    if (![CLLocationManager locationServicesEnabled]) {
        [self showAlertWithAlertControllerTitle:@"定位" message:@"定位服务不可用" alertActionTitle:@"好的"];
        return;
    }
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = 0.1;
        self.locationManager.delegate = self;
        [self.locationManager startUpdatingLocation];
//        [self.mapView showAnnotations:@[self.annotation] animated:YES];
//        [self.mapView showAnnotations:@[self.annotation, self.pointAnnotation] animated:YES];
    }
}

#pragma mark - Init SEL
- (void)setUpMap {
    _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    _mapView.userTrackingMode = MKUserTrackingModeFollow;
    _mapView.mapType = MKMapTypeStandard;
    _mapView.delegate = self;
    [self.view addSubview:self.mapView];
}

- (void)addAnnotation {
    CLLocationCoordinate2D locationCoordinate2D = CLLocationCoordinate2DMake(22.56, 113.23);
    UIImage *image = [UIImage imageNamed:@"icon_mark1"];
//    _annotation = [[TSAnnotation alloc] initWithLocationCoordinate2D:locationCoordinate2D title:@"TS测试" subTitle:@"副标题" image:image];
    _annotation = [[TSAnnotation alloc] init];
    _annotation.coordinate = locationCoordinate2D;
    _annotation.title = @"annotation";
    _annotation.subtitle = @"副标题";
    _annotation.image = image;
//    [self.mapView addAnnotation:self.annotation];
    
    _pointAnnotation = [[MKPointAnnotation alloc] init];
    _pointAnnotation.coordinate = CLLocationCoordinate2DMake(22.57, 113.94);
    _pointAnnotation.title = @"TS测试";
    _pointAnnotation.subtitle = @"副标题";
//    [self.mapView addAnnotation:_pointAnnotation];
    
    MKUserLocation *userLocation = _mapView.userLocation;
    userLocation.title = @"当前位置";
    
    [self.mapView addAnnotations:@[self.annotation, self.pointAnnotation]];
}

- (void)setUpSearchBar {
    _addressSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(20, 70, [UIScreen mainScreen].bounds.size.width-40, 30)];
    _addressSearchBar.returnKeyType = UIReturnKeySearch;
    _addressSearchBar.placeholder = @"搜索地址";
    _addressSearchBar.showsCancelButton = YES;
    _addressSearchBar.delegate = self;
    [self.mapView addSubview:self.addressSearchBar];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.view endEditing:YES];
    self.userAddress = self.addressSearchBar.text;
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:self.userAddress completionHandler:^(NSArray<CLPlacemark *> *placemarks, NSError *error){
        for (CLPlacemark *placemark in placemarks) {
            CLLocation *location = placemark.location;
            MKCoordinateSpan coordinateSpan = MKCoordinateSpanMake(1, 1);
            MKCoordinateRegion region = MKCoordinateRegionMake(location.coordinate, coordinateSpan);
            [self.mapView setRegion:region animated:YES];
            
            MKPointAnnotation * pointAnnotation = [[MKPointAnnotation alloc] init];
            pointAnnotation.coordinate = location.coordinate;
            pointAnnotation.title = @"TS测试";
            pointAnnotation.subtitle = @"副标题";
            [self.mapView addAnnotation:pointAnnotation];
        }
    }];

}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.view endEditing:YES];
}

#pragma mark - Private SEL
- (void)showAlertWithAlertControllerTitle:(NSString *)title message:(NSString *)message alertActionTitle:(NSString *)alertActionTitle {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:alertActionTitle style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[TSAnnotation class]]) {
        static NSString *const annotationViewID = @"annotationViewKey";
        MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:annotationViewID];
        if (!annotationView) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationViewID];
            annotationView.canShowCallout = true;
            annotationView.leftCalloutAccessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_mark1"]];
            annotationView.image = [UIImage imageNamed:@"icon_mark1"];
            annotationView.draggable = YES;
        }
        annotationView.annotation = annotation;
        return annotationView;
    }
    return nil;
}

/** 隐藏用户位置 */
//- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray<MKAnnotationView *> *)views {
//    MKAnnotationView *userAnnotation = [mapView viewForAnnotation:mapView.userLocation];
//    userAnnotation.hidden = YES;
//}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    NSLog(@"location: %@", [locations firstObject]);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
}

#pragma mark - span和region的作用
//中国中心点的纬度是（3 + 53）/ 2 = 北纬28度
//中国中心点的经度是（73 + 135）/ 2 = 东经104度
//中国纬度跨度是53 - 3 = 50度
//中国经度跨度是135 - 73 = 62度
- (void)showWholeChina {
    MKCoordinateSpan span = MKCoordinateSpanMake(50.0, 62.0);
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(28.0, 104.0);
    MKCoordinateRegion region = MKCoordinateRegionMake(centerCoordinate, span);
    [self.mapView setRegion:region animated:YES];
}

/** 移动mapView */
- (void)translationMapView {
    [MapLocationHelper translationMapWithMapView:self.mapView offsetXPixel:-50 offsetYPixel:100];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
