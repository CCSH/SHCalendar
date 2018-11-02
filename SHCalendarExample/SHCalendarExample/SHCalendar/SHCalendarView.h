//
//  SHCalendarView.h
//  SHCalendarExample
//
//  Created by CSH on 2018/10/29.
//  Copyright © 2018 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHCalendarModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 日历视图
 */
@interface SHCalendarView : UIView

//数据源(默认当前年、月)
@property (nonatomic, copy) NSArray <SHCalendarModel *>*dataSoure;
//起始周(0 ~ 6 默认 0 也就是周日)
@property (nonatomic, assign) NSInteger startWeek;

//点击回调
@property (nonatomic, copy) void(^selectBlock)(SHCalendarModel *model);

#pragma mark 刷新界面
- (void)reloadView;

#pragma mark 获取指定月的数据(如果需要 startWeek 需要提前设置)
- (NSArray <SHCalendarModel *>*)getDataArrWithYear:(NSInteger)year month:(NSInteger)month;
#pragma mark 获取 date 的月数据
- (NSArray <SHCalendarModel *>*)getDataArrWithDate:(NSDate *)date;

#pragma mark 上一个月
- (NSArray *)lastMonth;
#pragma mark 下一个月
- (NSArray *)nextMonth;

@end

NS_ASSUME_NONNULL_END
