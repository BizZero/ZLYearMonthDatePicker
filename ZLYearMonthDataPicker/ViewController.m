//
//  ViewController.m
//  YMDataPicker
//
//  Created by zhoulin on 16/5/18.
//  Copyright © 2016年 Biz. All rights reserved.
//

#import "ViewController.h"
#import "ZLYearMonthDatePicker.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clicked:(UIButton *)sender {
    
    ZLYearMonthDatePicker *datePicker = [ZLYearMonthDatePicker dataPickerWithSelectBlock:^(NSString *string) {
        [sender setTitle:string forState:UIControlStateNormal];
    }];
    datePicker.minDate = [NSDate date];
    datePicker.maxDate = [NSDate dateWithTimeIntervalSinceNow:88883453];
    [datePicker showInView:self.view];
    
}

@end
