//
//  ViewController.m
//  SHCalendarExample
//
//  Created by CSH on 2018/10/29.
//  Copyright © 2018 CSH. All rights reserved.
//

#import "ViewController.h"
#import "SHCalendarView.h"

@interface ViewController ()
@property (nonatomic, strong) SHCalendarView *calendarView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.calendarView = [[SHCalendarView alloc]init];
    //高度不用设置 内部有计算
    self.calendarView.frame = CGRectMake(10, 100, self.view.frame.size.width - 20, 0);
    
    //设置起始周
    self.calendarView.startWeek = 1;
    //设置数据源
    self.calendarView.dataSoure = [self.calendarView getDataArrWithYear:2018 month:11];
    //刷新
    [self.calendarView reloadView];
    //回调
    self.calendarView.selectBlock = ^(SHCalendarModel * _Nonnull model) {
        NSLog(@"%ld---%ld---%ld",(long)model.year,(long)model.month,(long)model.day);
    };
    
    [self.view addSubview:self.calendarView];
    //配置头部内容
    [self configTitle];
}

- (IBAction)btnLast:(id)sender {
    self.calendarView.dataSoure = [self.calendarView lastMonth];
    [self.calendarView reloadView];
    
    [self configTitle];
}

- (IBAction)btnNext:(id)sender {
    
    self.calendarView.dataSoure = [self.calendarView nextMonth];
    [self.calendarView reloadView];
    
    [self configTitle];
}

- (void)configTitle{
    
    SHCalendarModel *model = self.calendarView.dataSoure.lastObject;
    self.title = [NSString stringWithFormat:@"%ld年 %ld月",(long)model.year,(long)model.month];
}

@end
