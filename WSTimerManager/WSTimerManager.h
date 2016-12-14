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

- (dispatch_source_t)createTimerByTag:(NSString *)tag
                            startDate:(NSString *)startDate
                              endDate:(NSString *)endDate
                        dateFormatter:(NSDateFormatter *)dateFormatter
                              handler:(void(^)(struct WSTime time))handler
                                  end:(void(^)())end;

- (dispatch_source_t)createTimerByTag:(NSString *)tag
                            countdown:(NSInteger)countdown
                              handler:(void(^)(NSInteger count))handler
                                  end:(void(^)())end;

- (void)invalidateTimerWithTag:(NSString *)tag;

@end


