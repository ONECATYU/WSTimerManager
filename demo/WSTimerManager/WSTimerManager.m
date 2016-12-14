//
//  WSTimer.m
//  WSTimer
//
//  Created by 余汪送 on 2016/12/13.
//  Copyright © 2016年 余汪送. All rights reserved.
//

#import "WSTimerManager.h"

@interface WSTimerManager ()

@property (strong, nonatomic) NSMutableDictionary *timers;

@end

@implementation WSTimerManager

+ (instancetype)manager
{
    static WSTimerManager *timer;
    static dispatch_once_t token;
    dispatch_once(&token,^{
        timer = [[WSTimerManager alloc]init];
    });
    return timer;
}

- (instancetype)init {
    if (self = [super init]) {
        _timers = [NSMutableDictionary dictionary];
    }
    return self;
}

- (NSDictionary *)timerDict {
    return _timers;
}

- (dispatch_source_t)timer_t {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer,dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0);
    return timer;
}

- (dispatch_source_t)createTimerByTag:(NSString *)tag
                            countdown:(NSInteger)countdown
                              handler:(void(^)(NSInteger count))handler
                                  end:(void(^)())end
{
    __block NSInteger timeOut = countdown;
    __block dispatch_source_t timer = _timers[tag];
    if (!timer) {
        timer = [self timer_t];
        _timers[tag] = timer;
    }else{
        return timer;
    }
    dispatch_source_set_event_handler(timer, ^{
        if (timeOut <= 0) {
            dispatch_source_cancel(timer);
            timer = nil;
            [_timers removeObjectForKey:tag];
            if (end) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    end();
                });
            }
        }else{
            timeOut --;
            if (handler) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    handler(timeOut);
                });
            }
        }
    });
    dispatch_resume(timer);
    return timer;
}

- (dispatch_source_t)createTimerByTag:(NSString *)tag
                            startDate:(NSString *)startDate
                              endDate:(NSString *)endDate
                        dateFormatter:(NSDateFormatter *)dateFormatter
                              handler:(void(^)(struct WSTime time))handler
                                  end:(void(^)())end
{
    
    NSDate *end_date = [dateFormatter dateFromString:endDate];
    NSDate *start_date = [dateFormatter dateFromString:startDate];
    NSTimeInterval interval =[end_date timeIntervalSinceDate:start_date];
    __block NSInteger timeOut = interval;
    
    __block dispatch_source_t timer = _timers[tag];
    if (!timer) {
        timer = [self timer_t];
        _timers[tag] = timer;
    }else{
        return timer;
    }
    dispatch_source_set_event_handler(timer, ^{
        if (timeOut <= 0) {
            dispatch_source_cancel(timer);
            timer = nil;
            [_timers removeObjectForKey:tag];
            if (end) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    end();
                });
            }
        }else{
            timeOut --;
            if (handler) {
                int days = (int)(timeOut / (3600*24));
                int hours = (int)((timeOut - days * 24 * 3600) / 3600);
                int minute = (int)(timeOut- days * 24 * 3600 - hours * 3600) / 60;
                int second = (int)timeOut - days * 24 * 3600 - hours * 3600 - minute * 60;
                struct WSTime time = {days, hours, minute, second};
                dispatch_async(dispatch_get_main_queue(), ^{
                    handler(time);
                });
            }
        }
    });
    dispatch_resume(timer);
    return timer;
}

- (void)invalidateTimerWithTag:(NSString *)tag {
    dispatch_source_t timer = _timers[tag];
    if (timer) {
        dispatch_source_cancel(timer);
        timer = nil;
        [_timers removeObjectForKey:tag];
    }
}

@end

