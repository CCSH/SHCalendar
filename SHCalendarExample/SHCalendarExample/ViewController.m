//
//  ViewController.m
//  SHCalendarExample
//
//  Created by CSH on 2018/10/29.
//  Copyright © 2018 CSH. All rights reserved.
//

#import "SHCalendarView.h"
#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) SHCalendarView *calendarView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.calendarView = [[SHCalendarView alloc] init];
    // 高度不用设置 内部有计算
    self.calendarView.frame = CGRectMake(10, 100, self.view.frame.size.width - 20, 0);
    // 刷新
    [self.calendarView reloadView];
    // 回调
    self.calendarView.selectBlock = ^(NSDate *_Nonnull date) {
        NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
        NSLog(@"%ld---%ld---%ld",(long)components.year,(long)components.month,(long)components.day);
    };
    
    [self.view addSubview:self.calendarView];
    
    [self configTitile:self.calendarView.currentDate];
}

- (IBAction)btnLast:(id)sender {
    [self configTitile:[self.calendarView lastMonth]];
}

- (IBAction)btnNext:(id)sender {
    [self configTitile:[self.calendarView nextMonth]];
}

- (void)configTitile:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    self.title = [NSString stringWithFormat:@"%ld年 %ld月", (long)components.year, (long)components.month];

}

@end
