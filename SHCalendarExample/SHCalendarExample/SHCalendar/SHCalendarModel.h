//
//  SHCalendarModel.h
//  SHCalendarExample
//
//  Created by CSH on 2018/11/1.
//  Copyright © 2018 CSH. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 日历模型
 */
@interface SHCalendarModel : NSObject

//年
@property (nonatomic, assign) NSInteger year;
//月
@property (nonatomic, assign) NSInteger month;
//日
@property (nonatomic, assign) NSInteger day;

//其他数据
//@property (nonatomic, strong) id parameter;

@end

NS_ASSUME_NONNULL_END
