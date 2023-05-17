//
//  SHCalendarCell.m
//  SHCalendarExample
//
//  Created by CSH on 2018/11/1.
//  Copyright © 2018 CSH. All rights reserved.
//

#import "SHCalendarCell.h"

@interface SHCalendarCell ()

// 背景
@property (nonatomic, strong) UIView *bgView;
// 日期
@property (nonatomic, strong) UILabel *dayLab;

@end

@implementation SHCalendarCell

- (void)setModel:(NSDate *)model {
    _model = model;
    [self reloadView];
}

- (void)setData:(SHCalendarView *)data {
    _data = data;
    [self reloadView];
}

- (void)reloadView {
    self.dayLab.text = @"";
    self.bgView.backgroundColor = [UIColor clearColor];
    self.bgView.layer.borderColor = [UIColor clearColor].CGColor;
    _isCanClick = NO;
    if ([self.model isKindOfClass:[NSString class]]) {
        return;
    }
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.model];
    
    self.dayLab.text = [NSString stringWithFormat:@"%ld", components.day];
    
    CGFloat itemSize = self.data.frame.size.width / 7;
    
    self.bgView.frame = CGRectMake(2.5, 2.5, itemSize - 5, itemSize - 5);
    self.dayLab.frame = CGRectMake(0, 0, itemSize, itemSize);
    self.bgView.layer.cornerRadius = (self.data.cornerRadius < 0) ? self.bgView.frame.size.height / 2 : self.data.cornerRadius;
    
    // 判断是否点击
    BOOL isSelect = NO;
    if (!self.data.currentDate) {
        self.data.currentDate = [NSDate date];
    }
    NSDateComponents *components2 = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.data.currentDate];
    if (components2.year == components.year &&
        components2.month == components.month &&
        components2.day == components.day) {
        isSelect = YES;
    }
    
    // 判断是否是今天
    BOOL isToday = NO;
    components2 = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
    if (components2.year == components.year &&
        components2.month == components.month &&
        components2.day == components.day &&
        self.data.showToday) {
        isToday = YES;
    }
    // 判断是否可以点击
    BOOL isCanClick = [self isCanClick:self.model];
    
    self.dayLab.textColor = isCanClick ? [UIColor blackColor] : [UIColor lightGrayColor];
    self.bgView.layer.borderColor = (isToday ? self.data.currentColor : [UIColor clearColor]).CGColor;
    
    self.bgView.backgroundColor = isSelect ? self.data.currentColor : [UIColor clearColor];
    self.dayLab.textColor = isSelect ? [UIColor whiteColor] : self.dayLab.textColor;
    
    self.dayLab.font = self.data.font;
}

- (BOOL)isCanClick:(NSDate *)model {
    BOOL isCanClick = YES;
    if (self.data.minDate) {
        if ([model compare:self.data.minDate] == NSOrderedAscending) {
            isCanClick = NO;
        }
    }
    if (isCanClick) {
        if (self.data.maxDate) {
            if ([model compare:self.data.maxDate] == NSOrderedDescending) {
                isCanClick = NO;
            }
        }
    }
    _isCanClick = isCanClick;
    return isCanClick;
}

#pragma mark - 懒加载
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.layer.borderWidth = 0.5;
        [self.contentView addSubview:_bgView];
        [self.contentView sendSubviewToBack:_bgView];
    }
    return _bgView;
}

- (UILabel *)dayLab {
    if (!_dayLab) {
        _dayLab = [[UILabel alloc] init];
        _dayLab.textAlignment = NSTextAlignmentCenter;
        _dayLab.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_dayLab];
    }
    return _dayLab;
}

@end
