//
//  RBZEventDateValueDelegate.h
//  Date Reminder
//
//  Created by Xyz on 13-12-26.
//  Copyright (c) 2013年 Xyz Xyz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventDate+Functions.h"

@protocol RBZEventDateValueDelegate <NSObject>

- (void)eventDateDailyPicked;
- (void)eventDateWeeklyPicked:(NSNumber *)weekday;
- (void)eventDateMonthlyPicked:(NSNumber *)day;
- (void)eventDateYearlyPicked:(NSNumber *)day month:(NSNumber *)month;
- (void)eventDateOncePicked:(NSNumber *)day month:(NSNumber *)month year:(NSNumber *)year;

@end
