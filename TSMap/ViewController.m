//
//  ViewController.m
//  TSMap
//
//  Created by tunsuy on 26/4/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "Common/StringHelper.h"
#import "Common/CollectionHelper.h"
#import "MapViewController.h"
#import "MapLocationHelper.h"

@interface ViewController ()<CLLocationManagerDelegate, UITextViewDelegate>

@property (nonatomic, strong) UITextField *latitudeTextField;
@property (nonatomic, strong) UITextField *longitudeTextField;
@property (nonatomic, strong) UITextView *addressTextView;
@property (nonatomic, strong) UILabel *placeHolderLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIBarButtonItem *locationBtn = [[UIBarButtonItem alloc] initWithTitle:@"拜访" style:UIBarButtonItemStyleDone target:self action:@selector(locationHandler:)];
    self.navigationItem.rightBarButtonItems = @[locationBtn];
    
    [self initUI];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
}

- (void)initUI {
    _latitudeTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 90, ([UIScreen mainScreen].bounds.size.width-20*3)/2, 30)];
    _latitudeTextField.placeholder = @"经度";
    _latitudeTextField.backgroundColor = [UIColor whiteColor];
    
    _longitudeTextField = [[UITextField alloc] initWithFrame:CGRectMake(20*2+_latitudeTextField.bounds.size.width, 90, ([UIScreen mainScreen].bounds.size.width-20*3)/2, 30)];
    _longitudeTextField.placeholder = @"纬度";
    _longitudeTextField.backgroundColor = [UIColor whiteColor];
    
    UILabel *codeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 140, [UIScreen mainScreen].bounds.size.width-40, 30)];
    codeLabel.text = @"编解码";
    codeLabel.textAlignment = NSTextAlignmentCenter;
    
    _addressTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 190, [UIScreen mainScreen].bounds.size.width-40, 60)];
    _addressTextView.delegate = self;
    _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 15, 50, 30)];
    _placeHolderLabel.text = @"地址";
    _placeHolderLabel.textColor = [UIColor lightGrayColor];
    _placeHolderLabel.textAlignment = NSTextAlignmentCenter;
    [_addressTextView addSubview:_placeHolderLabel];
    
    UIButton *codeBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 270, [UIScreen mainScreen].bounds.size.width-40, 30)];
    codeBtn.backgroundColor = [UIColor orangeColor];
    [codeBtn setTitle:@"确定" forState:UIControlStateNormal];
    [codeBtn addTarget:self action:@selector(codeHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.latitudeTextField];
    [self.view addSubview:self.longitudeTextField];
    [self.view addSubview:codeLabel];
    [self.view addSubview:_addressTextView];
    [self.view addSubview:codeBtn];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.placeHolderLabel.hidden = YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        self.placeHolderLabel.hidden = NO;
    }
    else {
        self.placeHolderLabel.hidden = YES;
    }
}

#pragma mark - CoreLocation代理
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = [locations firstObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    NSLog(@"经度：%f,纬度：%f,海拔：%f,航向：%f,行走速度: %f",coordinate.longitude,coordinate.latitude,location.altitude,location.course,location.speed);
//    [_locationManager stopUpdatingLocation];

    
}

#pragma mark - Event SEL
- (void)locationHandler:(UIBarButtonItem *)sender {
    MapViewController *mapVC = [[MapViewController alloc] init];
    [self.navigationController pushViewController:mapVC animated:YES];
}

- (void)codeHandler:(UIBarButtonItem *)sender {
    NSCharacterSet *characterSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *latitude = [self.latitudeTextField.text stringByTrimmingCharactersInSet:characterSet];
    NSString *longitude = [self.longitudeTextField.text stringByTrimmingCharactersInSet:characterSet];
    NSString *address = [self.addressTextView.text stringByTrimmingCharactersInSet:characterSet];
    
    if ([latitude length] == 0 && [longitude length] == 0 && [address length] == 0) {
        [self showAlertWithAlertControllerTitle:@"编解码" message:@"请输入经纬度或者地址中的一种" alertActionTitle:@"好的"];
        return;
    }
    if ((([latitude length] == 0 && [longitude length] > 0) || ([latitude length] > 0 && [longitude length] == 0)) && [address length] == 0) {
        [self showAlertWithAlertControllerTitle:@"编解码" message:@"经纬度必须同时存在" alertActionTitle:@"好的"];
        return;
    }
    if ([latitude length] > 0 && [longitude length] > 0 && [address length] > 0) {
        [self showAlertWithAlertControllerTitle:@"编解码" message:@"经纬度和地址不能同时存在" alertActionTitle:@"好的"];
        return;
    }
    if ([latitude length] > 0 && [longitude length] > 0) {
        if (![StringHelper isPureFloat:latitude] && ![StringHelper isPureInt:latitude] && ![StringHelper isPureFloat:longitude] && ![StringHelper isPureInt:longitude]) {
            [self showAlertWithAlertControllerTitle:@"错误" message:@"经纬度必须是数值" alertActionTitle:@"好的"];
            return;
        }
        CLLocationDegrees latitude = [self.latitudeTextField.text floatValue];
        CLLocationDegrees longitude = [self.longitudeTextField.text floatValue];
        
        CLPlacemark *placemark = [MapLocationHelper getPlacemarkByLatitude:latitude longitude:longitude];
        NSString *message = [CollectionHelper descriptionWithDictionary:placemark.addressDictionary];
        [self showAlertWithAlertControllerTitle:@"结果" message:message alertActionTitle:@"好的"];
        self.addressTextView.text = placemark.addressDictionary[@"Name"];
        [self subViewsResignFirstResponder];
        return;
    }
    if ([address length] > 0) {
        NSString *address = self.addressTextView.text;
        CLPlacemark *placemark = [MapLocationHelper getPlacemarkByAddress:address];
        CLLocation *location = placemark.location;
        CLRegion *region = placemark.region;
        NSDictionary *infoDic = placemark.addressDictionary;
        NSString *info = [NSString stringWithFormat:@"位置：%@， 区域：%@， 详细信息：%@", location, region, infoDic];
        [self showAlertWithAlertControllerTitle:@"结果" message:info alertActionTitle:@"好的"];
        self.latitudeTextField.text = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
        self.longitudeTextField.text = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
        [self subViewsResignFirstResponder];
        return;
    }
}

#pragma mark - private SEL
- (void)subViewsResignFirstResponder {
    [self.latitudeTextField resignFirstResponder];
    [self.longitudeTextField resignFirstResponder];
    [self.addressTextView resignFirstResponder];
}

- (void)showAlertWithAlertControllerTitle:(NSString *)title message:(NSString *)message alertActionTitle:(NSString *)alertActionTitle {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:alertActionTitle style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
