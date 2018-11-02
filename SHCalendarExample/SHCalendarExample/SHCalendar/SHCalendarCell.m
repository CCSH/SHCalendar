//
//  SHCalendarCell.m
//  SHCalendarExample
//
//  Created by CSH on 2018/11/1.
//  Copyright © 2018 CSH. All rights reserved.
//

#import "SHCalendarCell.h"

@interface SHCalendarCell ()

//背景
@property (nonatomic, strong) UIView *bgView;
//日期
@property (nonatomic, strong) UILabel *dayLab;

@end

@implementation SHCalendarCell

- (void)setModel:(SHCalendarModel *)model{
    _model = model;
    
    self.dayLab.text = [NSString stringWithFormat:@"%@",(model.day?[NSString stringWithFormat:@"%ld",(long)model.day]:@"")];
    
    if (self.dayLab.text.length) {
        self.userInteractionEnabled = YES;
    }else{
        self.userInteractionEnabled = NO;
    }
}

- (void)setIsSelect:(BOOL)isSelect{
    _isSelect = isSelect;
    
    self.bgView.backgroundColor = isSelect?[UIColor redColor]:[UIColor clearColor];
}

- (void)setIsToday:(BOOL)isToday{
    _isToday = isToday;
    
    self.bgView.layer.borderColor = (isToday?[UIColor redColor]:[UIColor clearColor]).CGColor;
}

#pragma mark - 蓝加载
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.frame = CGRectMake(2.5, 2.5, self.itemSize.width - 5, self.itemSize.height - 5);
        _bgView.layer.cornerRadius = _bgView.frame.size.height/2;
        _bgView.layer.borderWidth = 0.5;
        _bgView.layer.borderColor = [UIColor clearColor].CGColor;
        
        [self.contentView addSubview:_bgView];
        [self.contentView sendSubviewToBack:_bgView];
    }
    return _bgView;
}

- (UILabel *)dayLab{
    if (!_dayLab) {
        _dayLab = [[UILabel alloc]init];
        _dayLab.frame =CGRectMake(0, 0, self.itemSize.width, self.itemSize.height);
        _dayLab.textAlignment = NSTextAlignmentCenter;
        _dayLab.font = [UIFont fontWithName:@"PingFang SC" size:14];
        _dayLab.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_dayLab];
    }
    return _dayLab;
}

@end
