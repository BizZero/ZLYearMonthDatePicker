//
//  YMDatePicker.h
//  YMDataPicker
//
//  Created by zhoulin on 16/5/18.
//  Copyright © 2016年 Biz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^YMSelectBlock)(NSString *string);

@interface ZLYearMonthDatePicker : UIView

@property (nonatomic, strong, readwrite) NSDate *minDate;
@property (nonatomic, strong, readwrite) NSDate *maxDate;

+ (instancetype)dataPickerWithSelectBlock:(YMSelectBlock)selectedBlick;

- (void)showInView:(UIView *)view;

@end
