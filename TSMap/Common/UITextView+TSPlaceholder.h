//
//  UITextView+TSPlaceholder.h
//  TSMap
//
//  Created by tunsuy on 27/4/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (TSPlaceholder)<UITextViewDelegate>

@property (nonatomic, strong) UITextView *placeholderTextView;

- (void)setPlaceholder:(NSString *)placeholder;

@end