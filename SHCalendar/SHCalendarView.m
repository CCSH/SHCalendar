//
//  SHCalendarView.m
//  SHCalendarExample
//
//  Created by CSH on 2018/10/29.
//  Copyright © 2018 CSH. All rights reserved.
//

#import "SHCalendarView.h"
#import "SHCalendarCell.h"

@interface SHCalendarView ()<UICollectionViewDataSource, UICollectionViewDelegate>

//星期条
@property (nonatomic, strong) UIView *weekView;
//日历内容
@property (nonatomic, strong) UICollectionView *calendarView;
//数据源(默认当前年、月)
@property (nonatomic, copy) NSArray <NSDate *>*dataSoure;

@end

@implementation SHCalendarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.font = [UIFont boldSystemFontOfSize:16];
        self.currentColor = [UIColor orangeColor];
        self.cornerRadius = -1;
        self.weekH = 30;
    }
    return self;
}

#pragma mark - 蓝加载
- (UICollectionView *)calendarView{
    if (!_calendarView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.sectionInset = UIEdgeInsetsZero;
        
        _calendarView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _calendarView.backgroundColor = [UIColor clearColor];
        _calendarView.showsHorizontalScrollIndicator = NO;
        _calendarView.showsVerticalScrollIndicator = NO;
        _calendarView.dataSource = self;
        _calendarView.delegate = self;
        _calendarView.bounces = NO;
        
        //注册
        [_calendarView registerClass:[SHCalendarCell class] forCellWithReuseIdentifier:@"SHCalendarCell"];
        
        [self addSubview:_calendarView];
    }
    return _calendarView;
}

- (UIView *)weekView{
    if (!_weekView) {
        _weekView = [[UIView alloc]init];
        _weekView.backgroundColor = [UIColor clearColor];
        [self addSubview:_weekView];
    }
    return _weekView;
}

#pragma mark - 私有方法
#pragma mark 获取星期条
- (void)configWeekHeadView{
    
    [self.weekView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //设置高度
    CGFloat width = self.frame.size.width/7.0;
    
    self.weekView.frame = CGRectMake(0, 0, width, self.weekH);
    
    NSArray *weekArray = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
    
    //设置内容
    for (int i = 0; i < weekArray.count; i++) {
        
        NSInteger index = self.startWeek + i;
        
        if (index >= weekArray.count) {
            index = index - weekArray.count;
        }
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i*width, 0, width, self.weekH)];
        label.backgroundColor = [UIColor clearColor];
        label.text = weekArray[index];
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:10];
        label.textAlignment = NSTextAlignmentCenter;
        [self.weekView addSubview:label];
    }
    
    //分割线
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, self.weekH - 0.5, self.frame.size.width, 0.5);
    layer.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.weekView.layer addSublayer:layer];
}


#pragma mark - UICollectionViewDelegate
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    SHCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SHCalendarCell" forIndexPath:indexPath];
    cell.model = self.dataSoure[indexPath.row];
    cell.data = self;
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSoure.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SHCalendarCell *cell = (SHCalendarCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if (cell.isCanClick) {
        self.currentDate = cell.model;
        [self.calendarView reloadData];
        
        //回调
        if (self.selectBlock) {
            self.selectBlock(self.currentDate);
        }
    }
}

#pragma mark - 刷新界面
- (void)reloadView{
    
    //不存在数据源则为b当前 年、月
    if (!self.currentDate) {
        self.currentDate = [NSDate date];
    }
    if(!self.dataSoure.count){
        self.dataSoure = [self getDataArrWithDate:self.currentDate];
    }
    
    //超过规定周
    self.startWeek = MIN(MAX(self.startWeek, 6), 0);
    
    //是否存在余数
    BOOL hasModulo = (self.dataSoure.count/7);
    
    //设置整体高度
    CGRect frame = self.frame;
    frame.size.height = (self.dataSoure.count/7 + hasModulo) * (self.frame.size.width/7) + self.weekH;
    self.frame = frame;
    
    //设置星期条
    [self configWeekHeadView];

    //刷新日历内容
    self.calendarView.frame = CGRectMake(0, self.weekH, self.frame.size.width, frame.size.height - self.weekH);
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.calendarView.collectionViewLayout;
    layout.itemSize = CGSizeMake(self.frame.size.width/7, self.frame.size.width/7);
    [self.calendarView reloadData];
}

#pragma mark 获取 date 的月数据
- (NSArray <NSDate *>*)getDataArrWithDate:(NSDate *)date{
    
    //此月有多少天
    NSInteger totalDays = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;
    
    //此月1号是周几
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    components.day = 1; // 定位到当月第一天
    NSDate *firstDay = [calendar dateFromComponents:components];
    // 默认一周第一天序号为 1 ，而日历中约定为 0 ，故需要减一
    NSInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDay] - 1;
    
    if (self.startWeek > firstWeekday) {
        firstWeekday -= (self.startWeek - 6);
    }else{
        firstWeekday -= self.startWeek;
    }
    
    NSMutableArray *temp = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < totalDays + firstWeekday; i++) {
        if (i < firstWeekday) {//前面补全
            [temp addObject:@""];
        }else{
            components.year = components.year;
            components.month = components.month;
            components.day = i - firstWeekday + 1;
            [temp addObject:[calendar dateFromComponents:components]];
        }
    }
    return temp;
}


#pragma mark 上一个月
- (NSDate *)lastMonth{
    
    NSDate *date = [self.dataSoure lastObject];
    NSDateComponents *model = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    model.day = 1;
    //本月是
    if (model.month == 1) {
        model.year -= 1;
        model.month = 12;
    }else{
        model.month -= 1;
    }
    date = [[NSCalendar currentCalendar] dateFromComponents:model];
    self.dataSoure = [self getDataArrWithDate:date];
    [self reloadView];
    return date;
}

#pragma mark 下一个月
- (NSDate *)nextMonth{
    NSDate *date = [self.dataSoure lastObject];
    NSDateComponents *model = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    model.day = 1;
    if (model.month == 12) {
        model.year += 1;
        model.month = 1;
    }else{
        model.month += 1;
    }
    date = [[NSCalendar currentCalendar] dateFromComponents:model];
    self.dataSoure = [self getDataArrWithDate:date];
    [self reloadView];
    return date;
}

@end
