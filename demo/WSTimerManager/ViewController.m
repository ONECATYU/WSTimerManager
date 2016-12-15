//
//  ViewController.m
//  WSTimerManager
//
//  Created by 余汪送 on 2016/12/13.
//  Copyright © 2016年 余汪送. All rights reserved.
//

#import "ViewController.h"
#import "WSTimerManager.h"

NSString *const tag_timer1 = @"timer1";
NSString *const tag_timer2 = @"timer2";

@interface ViewController ()
{
    dispatch_source_t _timer1;
    dispatch_source_t _timer2;
}
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;

@end

@implementation ViewController

- (void)dealloc {
    NSLog(@"--- viewController dealloc ---");
    [[WSTimerManager manager] invalidateTimerWithTag:tag_timer1];
    [[WSTimerManager manager] invalidateTimerWithTag:tag_timer2];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)btn1Click:(id)sender {
    __weak typeof(self) wself = self;
    [[WSTimerManager manager]createTimerByTag:tag_timer1
                                    countdown:10
                                      handler:^(NSInteger count) {
                                          wself.label1.text = [NSString stringWithFormat:@"%02ld",(long)count];
                                      } end:^{
                                          wself.label1.text = @"倒计时结束";
                                      }];
    
}

- (IBAction)btn2Click:(id)sender {
    __weak typeof(self) wself = self;
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [[WSTimerManager manager]createTimerByTag:tag_timer2
                                    startDate:[dateFormatter stringFromDate:[NSDate date]]
                                      endDate:[dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:10000]]
                                dateFormatter:dateFormatter
                                      handler:^(struct WSTime time) {
                                          wself.label2.text = [NSString stringWithFormat:@"%02d:%02d:%02d:%02d", time.day, time.hours, time.minute, time.second];
                                      } end:^{
                                          wself.label2.text = @"倒计时结束";
                                      }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
