//
//  Event+Functions.m
//  Date Reminder
//
//  Created by Xyz on 14-1-1.
//  Copyright (c) 2014年 Xyz Xyz. All rights reserved.
//

#import "Event+Functions.h"
#import "EventTime+Functions.h"
#import "EventDate+Functions.h"
#import "EventReminder+Functions.h"
#import "RBZDateReminder.h"
#import "RBZUtils.h"

@implementation Event (Functions)

- (BOOL)isOnDate:(NSDate *)date
{
    NSCalendar *calendar = [[RBZDateReminder instance] defaultCalendar];
    NSInteger units = NSMinuteCalendarUnit | NSHourCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSWeekOfYearCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
    NSDateComponents *comps = [calendar components:units fromDate:date];
    NSInteger year = [comps year];
    NSInteger month = [comps month];
    NSInteger day = [comps day];
    NSInteger weekday = [comps weekday];
   // NSLog(@"bblu isOndate: %d,%d",day,[self.date.day integerValue]);
    
#if 0
    switch ([self.date.type integerValue]) {
        case RBZEventOnce:
            if ([self.date.year integerValue] == year && [self.date.month integerValue] == month && [self.date.day integerValue] == day)
                return YES;
            break;
        case RBZEventYearly:
            if ([self.date.month integerValue] == month && [self.date.day integerValue] == day)
                return YES;
            break;
        case RBZEventMonthly:
            if ([self.date.day integerValue] == day)
                return YES;
            break;
        case RBZEventWeekly:
            if ([self.date.weekday integerValue] == weekday)
                return YES;
            break;
        case RBZEventDaily:
            return YES;
    }
    return NO;
#else
    if ( ([self.date.month integerValue] < month) || ( ([self.date.month integerValue] == month) && ([self.date.day integerValue] < day) ))
    {
        return NO;
    }
    else
    {
        return YES;
    }
#endif
}

- (BOOL)isExpired:(NSDate *)now
{
#if 0
    return [Event isExpired:now
                       type:self.date.type
                     minute:self.time.minute
                       hour:self.time.hour
                        day:self.date.day
                    weekday:self.date.weekday
                      month:self.date.month
                       year:self.date.year];
#else
    NSCalendar *calendar = [[RBZDateReminder instance] defaultCalendar];
    NSInteger units = NSMinuteCalendarUnit | NSHourCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSWeekOfYearCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
    NSDateComponents *comps = [calendar components:units fromDate:now];
    NSInteger month = [comps month];
    NSInteger day = [comps day];
    
    if ( ([self.date.month integerValue] < month) || ( ([self.date.month integerValue] == month) && ([self.date.day integerValue] < day) ))
    {
        return YES;
    }
    else
    {
        return NO;
    }
#endif
}

- (NSInteger)getBetweenDays:(NSDate *)date;
{

    NSCalendar *calendar = [[RBZDateReminder instance] defaultCalendar];
    NSInteger units = NSMinuteCalendarUnit | NSHourCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSWeekOfYearCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
    NSDateComponents *comps = [calendar components:units fromDate:date];
    NSInteger year = [comps year];
    NSInteger month = [comps month];
    NSInteger day = [comps day];
    NSInteger destYear = year;
    
    //NSLog(@"bblu today is %@",date);
    
    if ( ([self.date.month integerValue] == month) && ([self.date.day integerValue] == day)) {
        return  0;
    }
    
   // NSString *string = [[NSString alloc] initWithString:[NSString stringWithFormat:<#(NSString *), ...#>]]

    if ( ([self.date.month integerValue] > month)
        || ( ([self.date.month integerValue] == month) && ([self.date.day integerValue] > day))
        )
    {
        
    }
    else
    {
        destYear++;
    }

    NSString *datestring = [NSString stringWithFormat:@"%d-%d-%d",destYear,[self.date.month integerValue],[self.date.day integerValue]];
    
    NSDateFormatter *dm = [[NSDateFormatter alloc] init];
    
    [dm setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *newdate = [dm dateFromString:datestring];
    
    //NSLog(@"bblu newdate is %@",newdate);
    
    
    NSTimeInterval time = [ newdate timeIntervalSinceDate:date];
    
    int days = ((int)time/(3600*24)) + 1;
    
    //NSLog(@"bblu time:%d",days);
    //self.days = (NSInteger)days;
    
    return days;
}

+ (BOOL)isExpired:(NSDate *)now type:(NSNumber *)type minute:(NSNumber *)minute hour:(NSNumber *)hour day:(NSNumber *)day weekday:(NSNumber *)weekday month:(NSNumber *)month year:(NSNumber *)year
{
    if ([type integerValue] == RBZEventOnce) {
        NSDate *next = [Event getNextDate:type
                                   minute:minute
                                     hour:hour
                                      day:day
                                  weekday:weekday
                                    month:month
                                     year:year];
        if ([next timeIntervalSinceDate:now] <= 0)
            return YES;
    }
    return NO;
}

- (NSDate *)getNextDate
{
    return [Event getNextDate:self.date.type
                       minute:self.time.minute
                         hour:self.time.hour
                          day:self.date.day
                      weekday:self.date.weekday
                        month:self.date.month
                         year:self.date.year];
}

+ (NSDate *)getNextDate:(NSNumber *)type minute:(NSNumber *)minute hour:(NSNumber *)hour day:(NSNumber *)day weekday:(NSNumber *)weekday month:(NSNumber *)month year:(NSNumber *)year
{
    switch ([type integerValue]) {
        case RBZEventDaily: return [Event nextDailyDate:minute hour:hour];
        case RBZEventWeekly: return [Event nextWeeklyDate:minute hour:hour weekday:weekday];
        case RBZEventMonthly: return [Event nextMonthlyDate:minute hour:hour day:day];
        case RBZEventYearly: return [Event nextYearlyDate:minute hour:hour day:day month:month];
        case RBZEventOnce: return [Event nextOnceDate:minute hour:hour day:day month:month year:year];
    }
    return nil;
}


+ (NSDate *)nextDailyDate:(NSNumber *)minute hour:(NSNumber *)hour
{
    NSCalendar *calendar = [[RBZDateReminder instance] defaultCalendar];
    NSInteger units = NSMinuteCalendarUnit | NSHourCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
    NSDate *now = [NSDate date];
    NSDateComponents *nowComps = [calendar components:units fromDate:now];
    now = [calendar dateFromComponents:nowComps];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    comps.minute = [minute integerValue];
    comps.hour = [hour integerValue];
    comps.day = nowComps.day;
    comps.month = nowComps.month;
    comps.year = nowComps.year;
    NSDate *d = [calendar dateFromComponents:comps];
    if ([d timeIntervalSinceDate:now] <= 0) {
        NSDateComponents *add = [[NSDateComponents alloc] init];
        add.day = 1;
        return [calendar dateByAddingComponents:add toDate:d options:0];
    } else {
        return d;
    }
}

+ (NSDate *)nextWeeklyDate:(NSNumber *)minute hour:(NSNumber *)hour weekday:(NSNumber *)weekday
{
    NSCalendar *calendar = [[RBZDateReminder instance] defaultCalendar];
    NSInteger units = NSMinuteCalendarUnit | NSHourCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSWeekCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
    NSDate *now = [NSDate date];
    NSDateComponents *nowComps = [calendar components:units fromDate:now];
    now = [calendar dateFromComponents:nowComps];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    comps.minute = [minute integerValue];
    comps.hour = [hour integerValue];
    comps.weekday = [weekday integerValue];
    comps.week = nowComps.week;
    comps.year = nowComps.year;
    NSDate *d = [calendar dateFromComponents:comps];
    if ([d timeIntervalSinceDate:now] <= 0) {
        NSDateComponents *add = [[NSDateComponents alloc] init];
        add.week = 1;
        return [calendar dateByAddingComponents:add toDate:d options:0];
    } else {
        return d;
    }
}

+ (NSDate *)nextMonthlyDate:(NSNumber *)minute hour:(NSNumber *)hour day:(NSNumber *)day
{
    NSCalendar *calendar = [[RBZDateReminder instance] defaultCalendar];
    NSInteger units = NSMinuteCalendarUnit | NSHourCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
    NSDate *now = [NSDate date];
    NSDateComponents *nowComps = [calendar components:units fromDate:now];
    
    BOOL passed = [EventTime isTimePassed:minute
                                eventHour:hour
                            currentMinute:nowComps.minute
                              currentHour:nowComps.hour];
    nowComps.minute = [minute integerValue];
    nowComps.hour = [hour integerValue];
    
    NSInteger sd = [day integerValue];
    if (nowComps.day < sd) {
        if (sd == 31) {
            nowComps.day = [RBZUtils lastDayOfMonth:nowComps.month year:nowComps.year];
            return [calendar dateFromComponents:nowComps];
        } else if (sd == 30 && nowComps.month == 2) {
            nowComps.day = sd;
            nowComps.month = 3;
            return [calendar dateFromComponents:nowComps];
        } else if (sd == 29 && nowComps.month == 2) {
            if ([RBZUtils isLeapYear:nowComps.year]) {
                nowComps.day = sd;
                return [calendar dateFromComponents:nowComps];
            } else {
                nowComps.day = sd;
                nowComps.month = 3;
                return [calendar dateFromComponents:nowComps];
            }
        } else {
            nowComps.day = sd;
            return [calendar dateFromComponents:nowComps];
        }
    } else if (nowComps.day == sd && !passed) {
        return [calendar dateFromComponents:nowComps];
    } else {
        if (sd == 31) {
            if (nowComps.month == 12) {
                nowComps.month = 1;
                nowComps.year++;
                nowComps.day = [RBZUtils lastDayOfMonth:nowComps.month year:nowComps.year];
            } else {
                nowComps.month++;
                nowComps.day = [RBZUtils lastDayOfMonth:nowComps.month year:nowComps.year];
            }
            return [calendar dateFromComponents:nowComps];
        } else if (sd == 30 && nowComps.month == 1) {
            nowComps.day = sd;
            nowComps.month = 3;
            return [calendar dateFromComponents:nowComps];
        } else if (sd == 29 && nowComps.month == 1) {
            nowComps.day = sd;
            if ([RBZUtils isLeapYear:nowComps.year])
                nowComps.month = 2;
            else
                nowComps.month = 3;
            return [calendar dateFromComponents:nowComps];
        } else {
            nowComps.day = sd;
            NSDate *d = [calendar dateFromComponents:nowComps];
            NSDateComponents *add = [[NSDateComponents alloc] init];
            add.month = 1;
            return [calendar dateByAddingComponents:add toDate:d options:0];
        }
    }
}

+ (NSDate *)nextYearlyDate:(NSNumber *)minute hour:(NSNumber *)hour day:(NSNumber *)day month:(NSNumber *)month
{
    NSCalendar *calendar = [[RBZDateReminder instance] defaultCalendar];
    NSInteger units = NSMinuteCalendarUnit | NSHourCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
    NSDate *now = [NSDate date];
    NSDateComponents *nowComps = [calendar components:units fromDate:now];
    now = [calendar dateFromComponents:nowComps];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    NSInteger sd = [day integerValue];
    NSInteger sm = [month integerValue];
    
    comps.minute = [minute integerValue];
    comps.hour = [hour integerValue];
    comps.day = sd;
    comps.month = sm;
    if (sd == 29 && sm == 2) {
        if ([RBZUtils isLeapYear:nowComps.year])
            comps.year = nowComps.year;
        else
            comps.year = [RBZUtils nextLeapYear:nowComps.year];
    } else {
        comps.year = nowComps.year;
    }
    NSDate *d = [calendar dateFromComponents:comps];
    if ([d timeIntervalSinceDate:now] <= 0) {
        if (sd == 29 && sm == 2) {
            comps.year = [RBZUtils nextLeapYear:nowComps.year];
            return [calendar dateFromComponents:comps];
        } else {
            NSDateComponents *add = [[NSDateComponents alloc] init];
            add.year = 1;
            return [calendar dateByAddingComponents:add toDate:d options:0];
        }
    } else {
        return d;
    }
}

+ (NSDate *)nextOnceDate:(NSNumber *)minute hour:(NSNumber *)hour day:(NSNumber *)day month:(NSNumber *)month year:(NSNumber *)year
{
    NSCalendar *calendar = [[RBZDateReminder instance] defaultCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    comps.year = [year integerValue];
    comps.month = [month integerValue];
    comps.day = [day integerValue];
    comps.hour = [hour integerValue];
    comps.minute = [minute integerValue];
    return [calendar dateFromComponents:comps];
}

@end
