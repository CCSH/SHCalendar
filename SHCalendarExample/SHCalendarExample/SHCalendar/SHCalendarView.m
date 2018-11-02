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

//选中数据
@property (nonatomic, strong) SHCalendarModel *selectModel;
//今天数据
@property (nonatomic, strong) SHCalendarModel *toDayModel;

//内容size
@property (nonatomic, assign) CGSize itemSize;

@end

@implementation SHCalendarView

static NSString *cellId = @"SHCalendarCell";

static CGFloat weekH = 32;

#pragma mark - 蓝加载
- (UICollectionView *)calendarView{
    if (!_calendarView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        self.itemSize = CGSizeMake(self.frame.size.width/7, self.frame.size.width/7);
        layout.itemSize = self.itemSize;
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
        [_calendarView registerClass:[SHCalendarCell class] forCellWithReuseIdentifier:cellId];
        
        [self addSubview:_calendarView];
    }
    return _calendarView;
}

- (UIView *)weekView{
    if (!_weekView) {
        _weekView = [[UIView alloc]init];
        _weekView.backgroundColor = [UIColor whiteColor];
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
    
    self.weekView.frame = CGRectMake(0, 0, width, weekH);
    
    NSArray *weekArray = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
    
    //设置内容
    for (int i = 0; i < weekArray.count; i++) {
        
        NSInteger index = self.startWeek + i;
        
        if (index >= weekArray.count) {
            index = index - weekArray.count;
        }
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i*width, 0, width, weekH)];
        label.backgroundColor = [UIColor clearColor];
        label.text = weekArray[index];
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:10];
        label.textAlignment = NSTextAlignmentCenter;
        [self.weekView addSubview:label];
    }
    
    //分割线
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, weekH - 0.5, self.frame.size.width, 0.5);
    layer.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.weekView.layer addSublayer:layer];
}


#pragma mark - UICollectionViewDelegate
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    SHCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    
    cell.itemSize = self.itemSize;
    
    SHCalendarModel *model = self.dataSoure[indexPath.row];
    
    //判断是否点击
    if (self.selectModel) {
        if (self.selectModel.year == model.year && self.selectModel.month == model.month && self.selectModel.day == model.day) {
            cell.isSelect = YES;
        }else{
            cell.isSelect = NO;
        }
    }
    
    //判断是否是今天
    if (self.toDayModel) {
        if (self.toDayModel.year == model.year && self.toDayModel.month == model.month && self.toDayModel.day == model.day) {
            cell.isToday = YES;
        }else{
            cell.isToday = NO;
        }
    }
    
    cell.model = model;
    
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
    
    self.selectModel = cell.model;
    [self.calendarView reloadData];
    
    //回调
    if (self.selectBlock) {
        self.selectBlock(self.selectModel);
    }
}

#pragma mark - 刷新界面
- (void)reloadView{
    
    //不存在数据源则为b当前 年、月
    if (!self.dataSoure.count) {
        //不存在的话就默认今天
        self.dataSoure = [self getDataArrWithDate:[NSDate date]];
    }
    
    //超过规定周
    if (self.startWeek > 6) {
        self.startWeek = 0;
    }
    
    //是否存在余数
    BOOL hasModulo = (self.dataSoure.count/7);
    
    //设置整体高度
    CGRect frame = self.frame;
    frame.size.height = (self.dataSoure.count/7 + hasModulo) * (self.frame.size.width/7) + weekH;
    self.frame = frame;
    
    //设置星期条
    [self configWeekHeadView];

    //刷新日历内容
    self.calendarView.frame = CGRectMake(0, weekH, self.frame.size.width,frame.size.height - weekH);
    [self.calendarView reloadData];
}

#pragma mark 获取指定月的数据
- (NSArray <SHCalendarModel *>*)getDataArrWithYear:(NSInteger)year month:(NSInteger)month{
    
    NSString *time = [NSString stringWithFormat:@"%ld %ld",(long)year,(long)month];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy MM"];
    NSDate *date = [formatter dateFromString:time];
    
    return [self getDataArrWithDate:date];
}

#pragma mark 获取 date 的月数据
- (NSArray <SHCalendarModel *>*)getDataArrWithDate:(NSDate *)date{
    
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
        
        SHCalendarModel *model = [[SHCalendarModel alloc]init];
        
        if (i < firstWeekday) {//前面补全
            model.year = 0;
            model.month = 0;
            model.day = 0;
        }else{
            model.year = components.year;
            model.month = components.month;
            model.day = i - firstWeekday + 1;
        }
        [temp addObject:model];
        
        //设置今天
        [self configToDayWithModel:model];
    }
    return temp;
}

#pragma mark 上一个月
- (NSArray *)lastMonth{
    
    SHCalendarModel *model = [self.dataSoure lastObject];
    //本月是
    if (model.month == 1) {
        model.year -= 1;
        model.month = 12;
    }else{
        model.month -= 1;
    }
    return [self getDataArrWithYear:model.year month:model.month];
}

#pragma mark 下一个月
- (NSArray *)nextMonth{
    
    SHCalendarModel *model = [self.dataSoure lastObject];
    if (model.month == 12) {
        model.year += 1;
        model.month = 1;
    }else{
        model.month += 1;
    }
    return [self getDataArrWithYear:model.year month:model.month];
}

- (void)configToDayWithModel:(SHCalendarModel *)model{
    
    //获取今天的时间
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *year = [calendar components:NSCalendarUnitYear fromDate:[NSDate date]];
    NSDateComponents *month = [calendar components:NSCalendarUnitMonth fromDate:[NSDate date]];
    NSDateComponents *day = [calendar components:NSCalendarUnitDay fromDate:[NSDate date]];
    
    //年、月、日 相同则是今天
    if (model.year == year.year && model.month == month.month && model.day == day.day) {
        
        self.toDayModel = model;
        
        if (!self.selectModel) {
            self.selectModel = model;
        }
    }
}

@end
