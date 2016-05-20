//
//  YMDatePicker.m
//  YMDataPicker
//
//  Created by zhoulin on 16/5/18.
//  Copyright © 2016年 Biz. All rights reserved.
//

#import "ZLYearMonthDatePicker.h"

#define YM_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define YM_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width


@interface ZLYearMonthDatePicker ()<UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDelegate>
{
    NSString *_selectedDateString;
    
    NSInteger _selectedYear;
    NSInteger _selectedMonth;
    
    NSInteger _minYearRow;
    NSInteger _minMonthRow;
    NSInteger _maxYearRow;
    NSInteger _maxMonthRow;
}


@property (nonatomic, copy, readwrite) YMSelectBlock selectedBlock;
@property (nonatomic, weak, readwrite) UIPickerView *pickerView;
@property (nonatomic, weak, readwrite) UIButton *confirmButton;
@property (nonatomic, weak, readwrite) UIButton *cancellButton;

@property (nonatomic, strong, readwrite) NSDateComponents *currentComponent;




@end

@implementation ZLYearMonthDatePicker

#pragma mark - init
+ (instancetype)dataPickerWithSelectBlock:(YMSelectBlock)selectedBlock {
    
    return [[self alloc] initWithFrame:CGRectMake(0, YM_SCREEN_HEIGHT, YM_SCREEN_WIDTH, 220) selectedBlock:selectedBlock];
}

- (instancetype)initWithFrame:(CGRect)frame selectedBlock:(YMSelectBlock)selectedBlock {
    ZLYearMonthDatePicker *dataPicker = [self initWithFrame:frame];
    dataPicker.selectedBlock = selectedBlock;
    return dataPicker;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.pickerView];
        [self addSubview:self.confirmButton];
        [self addSubview:self.cancellButton];
        self->_minDate = [NSDate dateWithTimeIntervalSince1970:0];
        NSDateFormatter *formate = [NSDateFormatter new];
        formate.dateFormat = @"yyyy-MM";
        self->_maxDate = [formate dateFromString:@"2041-12"];
    }
    return self;
}

#pragma mark - <UIPickerViewDataSource, UIPickerViewDelegate>
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (component) {
        case 0:
        {
            return [NSString stringWithFormat:@"%ld年",1970 + row];
        }
            break;
        case 1: {
            
            return [NSString stringWithFormat:@"%.2ld月",row + 1];
        }
            break;
        default:
            break;
    }
    return nil;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    switch (component) {
        case 0:
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, YM_SCREEN_WIDTH / 2.0, 40)];
            label.text = [NSString stringWithFormat:@"%ld年",1970 + row];
            label.textAlignment = NSTextAlignmentCenter;
            if (row < _minYearRow || row > _maxYearRow) {
                label.textColor = [UIColor lightGrayColor];
            } else {
                label.textColor = [UIColor blackColor];
            }
            
            return label;
        }
            break;
        case 1: {
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, YM_SCREEN_WIDTH / 2.0, 40)];
            label.text = [NSString stringWithFormat:@"%.2ld月",row + 1];
            label.textAlignment = NSTextAlignmentCenter;
            if ((_selectedYear == _minYearRow && row < _minMonthRow) || (_selectedYear == _maxYearRow && row > _maxMonthRow)) {
                label.textColor = [UIColor lightGrayColor];

            } else {
                
                label.textColor = [UIColor blackColor];
            }
            return label;
        }
            break;
        default:
            break;
    }
    return nil;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (component) {
        case 0:
        {
            return 70;
        }
            break;
        case 1: {
            return 12;
        }
        default:
            break;
    }
    return 0;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0:
        {

            if (row < _minYearRow) {
                [pickerView selectRow:_minYearRow inComponent:0 animated:YES];
                _selectedDateString = [NSString stringWithFormat:@"%ld年%.2ld月",_minYearRow + 1970,[_pickerView selectedRowInComponent:1] + 1];
                _selectedYear = _minYearRow;
                if ([pickerView selectedRowInComponent:1] < _minMonthRow) {
                    [pickerView selectRow:_minMonthRow inComponent:1 animated:YES];
                    _selectedDateString = [NSString stringWithFormat:@"%ld年%.2ld月",_minYearRow + 1970,_minMonthRow];
                    _selectedMonth = _minMonthRow;
                    [pickerView reloadComponent:1];
                }
                
            } else if (row > _maxYearRow) {
                _selectedDateString = [NSString stringWithFormat:@"%ld年%.2ld月",_maxYearRow + 1970,[_pickerView selectedRowInComponent:1] + 1];
                _selectedYear = _maxYearRow;
                [pickerView selectRow:_maxYearRow inComponent:0 animated:YES];
                if ([pickerView selectedRowInComponent:1] > _maxMonthRow) {
                    [pickerView selectRow:_maxMonthRow inComponent:1 animated:YES];
                    _selectedDateString = [NSString stringWithFormat:@"%ld年%.2ld月",_maxYearRow + 1970,_maxMonthRow];
                    _selectedMonth = _maxMonthRow;
                    [pickerView reloadComponent:1];
                }
            }
            
            if (row == _minYearRow) {
                _selectedYear = _minYearRow;
                if ([pickerView selectedRowInComponent:1] < _minMonthRow) {
                    [pickerView selectRow:_minMonthRow inComponent:1 animated:YES];
                    _selectedDateString = [NSString stringWithFormat:@"%ld年%.2ld月",_minYearRow + 1970,_minMonthRow];
                    _selectedMonth = _minMonthRow;
                }
            }
            
            if (row == _maxYearRow) {
                
                _selectedYear = _maxYearRow;
                if ([pickerView selectedRowInComponent:1] > _maxMonthRow) {
                    [pickerView selectRow:_maxMonthRow inComponent:1 animated:YES];
                    _selectedDateString = [NSString stringWithFormat:@"%ld年%.2ld月",_maxYearRow + 1970,_maxMonthRow];
                    _selectedMonth = _maxMonthRow;
                }
            }
            _selectedYear = [pickerView selectedRowInComponent:0];
        }
            break;
            
        case 1:{
            
            if ([pickerView selectedRowInComponent:0] == _minYearRow && row < _minMonthRow) {
                
                _selectedDateString = [NSString stringWithFormat:@"%ld年%.2ld月",[_pickerView selectedRowInComponent:0] + 1970,_minMonthRow];
                [pickerView selectRow:_minMonthRow inComponent:1 animated:YES];
            } else if ([pickerView selectedRowInComponent:0] == _maxYearRow && row > _maxMonthRow) {
                _selectedDateString = [NSString stringWithFormat:@"%ld年%.2ld月",[_pickerView selectedRowInComponent:0] + 1970,_maxMonthRow];
                [pickerView selectRow:_maxMonthRow inComponent:1 animated:YES];
            }
            
        }
            break;
        default:
            break;
    }
}



#pragma mark - action
- (void)clickedConfirmButton {

//    _selectedDateString = [NSString stringWithFormat:@"%ld年%.2ld月",[_pickerView selectedRowInComponent:0] + 1970,[_pickerView selectedRowInComponent:1] + 1 ];
    
    if (self.selectedBlock) {
        self.selectedBlock(_selectedDateString);
    }
    [self removeFromSuperview];
}

- (void)clickedCancellButton {
    [self removeFromSuperview];
}

- (void)showInView:(UIView *)view {
    [view addSubview:self];
}

#pragma mark - override
- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
//    [self makeKeyWindow];
    [self.pickerView selectRow:self.currentComponent.year - 1970 inComponent:0 animated:NO];
    [self.pickerView selectRow:self.currentComponent.month - 1 inComponent:1 animated:NO];
    
    _minYearRow = [self componentWithDate:self.minDate].year - 1970;
    _minMonthRow = [self componentWithDate:self.minDate].month - 1;
    _maxYearRow = [self componentWithDate:self.maxDate].year - 1970;
    _maxMonthRow = [self componentWithDate:self.maxDate].month - 1;
    _selectedDateString = [NSString stringWithFormat:@"%ld年%.2ld月",self.currentComponent.year,self.currentComponent.month];
    [UIView animateWithDuration:0.4 animations:^{
        CGRect frame = self.frame;
        frame.origin.y = YM_SCREEN_HEIGHT - frame.size.height;
        self.frame = frame;

    }];
}

- (void)removeFromSuperview {
//    [self resignKeyWindow];
    [UIView animateWithDuration:0.4 animations:^{
        self.frame = CGRectMake(0, YM_SCREEN_HEIGHT, YM_SCREEN_WIDTH, 300);
    } completion:^(BOOL finished) {
        [super removeFromSuperview];
    }];
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    [_pickerView reloadComponent:1];
}

#pragma mark - private method
- (NSDateComponents *)componentWithDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:date];
}


#pragma mark - getter
- (UIPickerView *)pickerView {
    if (!_pickerView) {
        UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, YM_SCREEN_WIDTH, 180)];
        pickerView.delegate = self;
        pickerView.dataSource = self;
        [self addSubview:(_pickerView = pickerView)];
    }
    return _pickerView;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(YM_SCREEN_WIDTH - 80, 0, 60, 40)];
        [button setTitle:@"确定" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickedConfirmButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:(_confirmButton = button)];
    }
    return _confirmButton;
}

- (UIButton *)cancellButton {
    if (!_cancellButton) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, 60, 40)];
        [button setTitle:@"取消" forState:UIControlStateNormal];
        button.titleLabel.textColor = [UIColor blueColor];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickedCancellButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:(_cancellButton = button)];
    }
    return _cancellButton;
}

- (NSDateComponents *)currentComponent {
    if (!_currentComponent) {
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        
        _currentComponent = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:[NSDate date]];
        
    }
    return _currentComponent;
}

@end
