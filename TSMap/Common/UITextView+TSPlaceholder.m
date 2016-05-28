//
//  UITextView+TSPlaceholder.m
//  TSMap
//
//  Created by tunsuy on 27/4/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import <objc/runtime.h>
#import "UITextView+TSPlaceholder.h"

static char placeholderTextViewKey;

@implementation UITextView (TSPlaceholder)

- (void)setPlaceholderTextView:(UITextView *)placeholderTextView {
    objc_setAssociatedObject(self, &placeholderTextViewKey, placeholderTextView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UITextView *)placeholderTextView {
    return objc_getAssociatedObject(self, &placeholderTextViewKey);
}

- (void)setPlaceholder:(NSString *)placeholder {
    self.placeholderTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    self.placeholderTextView.text = placeholder;
    self.placeholderTextView.textColor = [UIColor lightGrayColor];
    self.placeholderTextView.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.placeholderTextView];
}

- (void)textViewDidChange:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        self.placeholderTextView.hidden = NO;
    }
    else {
        self.placeholderTextView.hidden = YES;
    }
}

@end
