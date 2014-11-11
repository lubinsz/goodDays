//
//  GoogleAnalyticsHelper.m
//  DateReminder
//
//  Created by Xyz on 1/17/14.
//  Copyright (c) 2014 Xyz Xyz. All rights reserved.
//

#import "GoogleAnalyticsHelper.h"
#import <sys/utsname.h>

@implementation GoogleAnalyticsHelper

static NSString *const GA_ACTION_EVENT_ONCE     = @"Once";
static NSString *const GA_ACTION_EVENT_DAILY    = @"Daily";
static NSString *const GA_ACTION_EVENT_WEEKLY   = @"Weekly";
static NSString *const GA_ACTION_EVENT_MONTHLY  = @"Monthly";
static NSString *const GA_ACTION_EVENT_YEARLY   = @"Yearly";

+ (void)trackScreen:(NSString *)screenName
{
#if 0
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:[GAIFields customDimensionForIndex:1] value:[self getDeviceModel]];
    [tracker set:kGAIScreenName value:screenName];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
#endif
}

+ (void)trackEventWithCategory:(NSString *)category action:(NSString *)action label:(NSString *)label value:(NSNumber *)value
{
#if 0
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:[GAIFields customDimensionForIndex:1] value:[self getDeviceModel]];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:category
                                                         action:action
                                                          label:label
#endif                                                          value:value] build]];
}

+ (void)trackCreateEvent:(Event *)event
{
#if 0
    [GoogleAnalyticsHelper trackEventWithCategory:GA_CATEGORY_NEW_EVENT
                                           action:[self getEventAction:event]
                                            label:[self getEventLabel:event]
                                            value:nil];
#endif
}

+ (void)trackDeleteEvent:(Event *)event
{
#if 0
    [GoogleAnalyticsHelper trackEventWithCategory:GA_CATEGORU_DELETE_EVENT
                                           action:[self getEventAction:event]
                                            label:[self getEventLabel:event]
                                            value:nil];
#endif
}

+ (NSString *)getEventAction:(Event *)event
{
#if 0
    switch ([event.date.type integerValue]) {
        case RBZEventOnce: return GA_ACTION_EVENT_ONCE;
        case RBZEventDaily: return GA_ACTION_EVENT_DAILY;
        case RBZEventWeekly: return GA_ACTION_EVENT_WEEKLY;
        case RBZEventMonthly: return GA_ACTION_EVENT_MONTHLY;
        case RBZEventYearly: return GA_ACTION_EVENT_YEARLY;
    }
#endif
    return @"";
}

+ (NSString *)getEventLabel:(Event *)event
{
#if 0
    NSString *str = [NSString stringWithFormat:@"%02d:%02d - %d",
                     [event.time.hour integerValue],
                     [event.time.minute integerValue],
                     [event.reminder.hasReminder boolValue] ? [event.reminder.minutesBefore integerValue] : 0];
    return str;
#else
    return @"";
#endif
}

+ (NSString *)getDeviceModel {
#if 0
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
#else
    return @"";
#endif
}

@end
