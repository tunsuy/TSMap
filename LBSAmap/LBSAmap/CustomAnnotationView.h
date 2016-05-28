//
//  CustomAnnotationView.h
//  LBSAmap
//
//  Created by tunsuy on 30/4/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "CustomCalloutView.h"

@interface CustomAnnotationView : MAAnnotationView

@property (nonatomic, strong, readonly) CustomCalloutView *calloutView;

@end
