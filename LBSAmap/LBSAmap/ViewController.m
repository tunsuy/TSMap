//
//  ViewController.m
//  LBSAmap
//
//  Created by tunsuy on 30/4/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import "ViewController.h"
#import "CustomAnnotationView.h"

@interface ViewController ()<MAMapViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setUpMapView];
    
    [self addAnnotation];
}

//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    
//    [self setUpMapView];
//    [self addAnnotation];
//}

#pragma mark - init view
- (void)setUpMapView {
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    _mapView.delegate = self;
    _mapView.language = MAMapLanguageZhCN;
    _mapView.showsUserLocation = YES;
    [_mapView setUserTrackingMode:MAUserTrackingModeFollowWithHeading animated:YES];
    
    [self.view addSubview:self.mapView];
    

}

- (void)addAnnotation {
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(22.64, 113.96);
    pointAnnotation.title = @"深圳";
    pointAnnotation.subtitle = @"大学城";
    
    [self.mapView addAnnotation:pointAnnotation];
}

#pragma mark - MAMapViewDelegate
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    if (updatingLocation) {
        NSLog(@"当前位置：latitude-%f, longitude-%f", userLocation.coordinate.latitude, userLocation.coordinate.longitude);
    }
}

//- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views {
//    MAAnnotationView *view = views[0];
//    
//    if ([view.annotation isKindOfClass:[MAUserLocation class] ]) {
//        MAUserLocationRepresentation *pre = [[MAUserLocationRepresentation alloc] init];
//        pre.fillColor = [UIColor colorWithRed:0.9 green:0.1 blue:0.1 alpha:0.3];
//        pre.strokeColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.9 alpha:1.0];
//        pre.lineWidth = 10;
//        pre.lineDashPattern = @[@(6),@(3)];
//        
//        [self.mapView updateUserLocationRepresentation:pre];
//        
//        view.calloutOffset = CGPointMake(0, 0);
//    }
//}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *reuseID = @"pointID";
        
        /** 自带的annotationView */
        MAPinAnnotationView *annotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseID];
        if (!annotationView) {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseID];
        }
        annotationView.canShowCallout = YES;
        annotationView.animatesDrop = YES;
        annotationView.draggable = YES;
        return annotationView;
        
        /** 自定义annotationView */
//        CustomAnnotationView *annotationView = (CustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseID];
//        if (!annotationView) {
//            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseID];
//        }
//        /** 设置为NO，用以调用自定义的calloutView */
//        annotationView.canShowCallout = NO;
//        /** 设置中心偏移点 */
//        annotationView.centerOffset = CGPointMake(0, -18);
//        return annotationView;
    }
    return nil;
}

- (void)mapView:(MAMapView *)mapView didLongPressedAtCoordinate:(CLLocationCoordinate2D)coordinate {
    /** 长按的坐标点 */
    NSLog(@"longPress coordinate : latitude-%f, longitude-%f", coordinate.latitude, coordinate.longitude);
    
}

- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
