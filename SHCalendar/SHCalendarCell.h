//
//  SHCalendarCell.h
//  SHCalendarExample
//
//  Created by CSH on 2018/11/1.
//  Copyright © 2018 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHCalendarView.h"

NS_ASSUME_NONNULL_BEGIN

/**
 日历cell
 */
@interface SHCalendarCell : UICollectionViewCell

@property (nonatomic, assign, readonly) BOOL isCanClick;
//数据
@property (nonatomic, strong) NSDate *model;
//定制数据
@property (nonatomic, strong) SHCalendarView *data;

@end

NS_ASSUME_NONNULL_END
