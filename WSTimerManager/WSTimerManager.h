//
//  WSTimer.h
//  WSTimer
//
//  Created by 余汪送 on 2016/12/13.
//  Copyright © 2016年 余汪送. All rights reserved.
//

#import <Foundation/Foundation.h>

struct WSTime {
    int day;
    int hours;
    int minute;
    int second;
};

@interface WSTimerManager : NSObject

/**
 timerDict:<NSString: dispatch_source_t>
 */
@property (nonatomic, strong, readonly) NSDictionary *timerDict;

+ (instancetype)manager;

//根据tag生成一个timer，间隔interval秒循环执行
- (dispatch_source_t)createTimerByTag:(NSString *)tag
                         timeInterval:(NSTimeInterval)interval
                              handler:(void(^)(NSInteger count))handler;

//根据startDate和endDate日期的间隔倒计时
- (dispatch_source_t)createTimerByTag:(NSString *)tag
                            startDate:(NSString *)startDate
                              endDate:(NSString *)endDate
                        dateFormatter:(NSDateFormatter *)dateFormatter
                              handler:(void(^)(struct WSTime time))handler
                                  end:(void(^)())end;

//从给定的倒计时数，开始每秒倒计时
- (dispatch_source_t)createTimerByTag:(NSString *)tag
                            countdown:(NSInteger)countdown
                              handler:(void(^)(NSInteger count))handler
                                  end:(void(^)())end;

- (void)invalidateTimerWithTag:(NSString *)tag;

@end


