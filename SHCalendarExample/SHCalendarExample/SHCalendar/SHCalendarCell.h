//
//  SHCalendarCell.h
//  SHCalendarExample
//
//  Created by CSH on 2018/11/1.
//  Copyright © 2018 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHCalendarModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 日历cell
 */
@interface SHCalendarCell : UICollectionViewCell

//宽高
@property (nonatomic, assign) CGSize itemSize;

//数据
@property (nonatomic, strong) SHCalendarModel *model;

//是否点击
@property (nonatomic, assign) BOOL isSelect;

//是否是今天
@property (nonatomic, assign) BOOL isToday;

@end

NS_ASSUME_NONNULL_END
