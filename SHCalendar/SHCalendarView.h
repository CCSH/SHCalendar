//
//  SHCalendarView.h
//  SHCalendarExample
//
//  Created by CSH on 2018/10/29.
//  Copyright © 2018 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 日历视图
 */
@interface SHCalendarView : UIView

//选中数据
@property (nonatomic, strong) NSDate *currentDate;
//最小日期
@property (nonatomic, strong) NSDate *minDate;
//最大日期
@property (nonatomic, strong) NSDate *maxDate;
//起始周(0 ~ 6 默认 0 也就是周日)
@property (nonatomic, assign) NSInteger startWeek;
//是否显示今天
@property (nonatomic, assign) BOOL showToday;
//点击回调
@property (nonatomic, copy) void(^selectBlock)(NSDate *date);

#pragma mark 定制
//字体(默认 16加粗)
@property (nonatomic, copy) UIFont *font;
//选中颜色(默认 orangeColor)
@property (nonatomic, copy) UIColor *currentColor;
//分割线颜色
@property (nonatomic, copy) UIColor *lineColor;
//圆角(cornerRadius<0 则为圆)
@property (nonatomic, assign) CGFloat cornerRadius;
//星期条高度(默认 30)
@property (nonatomic, assign) CGFloat weekH;

#pragma mark 刷新界面
- (void)reloadView;

#pragma mark 上一个月
- (NSDate *)lastMonth;
#pragma mark 下一个月
- (NSDate *)nextMonth;

@end

NS_ASSUME_NONNULL_END
