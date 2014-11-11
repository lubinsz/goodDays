//
//  RBZDateReminderApp.m
//  Date Reminder
//
//  Created by Xyz on 13-12-4.
//  Copyright (c) 2013年 Xyz Xyz. All rights reserved.
//

#import "RBZDateReminder.h"
#import "GoogleAnalyticsHelper.h"

@implementation RBZDateReminder {
    int _themeColorId;
}

static RBZDateReminder *instance;
NSString *const DRThemeColorChangedNotification = @"com.lubinsz.gooddays.themecolorchanged";
static NSString *const DateReminder_defaultEventsKey = @"dr_defaultEvents";
static NSString *const DateReminder_localNotificationCleared = @"dr_localNotificationCleared";
static NSString *const DateReminder_themeColorId = @"dr_theme";

+ (RBZDateReminder *)instance
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[RBZDateReminder alloc] init];
    });
    return instance;
}

- (id)init
{
    self = [super init];
    
    if (self) {
        //NSLog(@"bblu Event:%d, Date:%d, Time:%d, Reminder:%d", [Event MR_countOfEntities], [EventDate MR_countOfEntities], [EventTime MR_countOfEntities], [EventReminder MR_countOfEntities]);
        NSLog(@"Local Notifications:%d", [[[UIApplication sharedApplication] scheduledLocalNotifications] count]);
        
        //self.defaultLocale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
        self.defaultLocale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
        self.defaultCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        if (![defaults boolForKey:DateReminder_localNotificationCleared]) {
            [[UIApplication sharedApplication] cancelAllLocalNotifications];
            [defaults setBool:YES forKey:DateReminder_localNotificationCleared];
            [defaults synchronize];
        }
        
        if (![defaults boolForKey:DateReminder_defaultEventsKey]) {
            [self setupDefaultEvents];
            //[self setupDefaultEvents_2];
        }
        
        _themeColorId = [defaults integerForKey:DateReminder_themeColorId];
        self.theme = [self getTheme:_themeColorId];
        
        //[[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        //[[UIApplication sharedApplication] cancelAllLocalNotifications];
        //[Event MR_truncateAll];
        //[EventDate MR_truncateAll];
        //[EventTime MR_truncateAll];
        //[EventReminder MR_truncateAll];
        //[[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        
    }
    return self;
}

- (NSDateFormatter *)getLocalizedDateFormatter
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.calendar = self.defaultCalendar;
    formatter.locale = self.defaultLocale;
    return formatter;
}

- (DRTheme *)getTheme:(NSInteger)index
{
    switch (index) {
        case kThemeColorGreen: return [[DRTheme alloc] initWithRed:91.0/255.0 green:165.0/255.0 blue:37.0/255.0];
        case kThemeColorBlue: return [[DRTheme alloc] initWithRed:0.0/255.0 green:124.0/255.0 blue:195.0/255.0];
        case kThemeColorPurple: return [[DRTheme alloc] initWithRed:234.0/255.0 green:76.0/255.0 blue:137.0/255.0];
        default: return [[DRTheme alloc] initWithRed:251.0/255.0 green:119.0/255.0 blue:52.0/255.0];
    }
}

- (void)setThemeColor:(int)index
{
    _themeColorId = index;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:_themeColorId forKey:DateReminder_themeColorId];
    [defaults synchronize];
    self.theme = [self getTheme:_themeColorId];
    [[NSNotificationCenter defaultCenter] postNotificationName:DRThemeColorChangedNotification
                                                        object:nil
                                                      userInfo:nil];
}

- (NSInteger)getThemeColor
{
    return _themeColorId;
}

+ (NSString *)getThemeColorName:(int)index
{
    switch (index) {
        case kThemeColorGreen: return @"Green";
        case kThemeColorBlue: return @"Blue";
        case kThemeColorPurple: return @"Purple";
        default: return @"Orange";
    }
}

- (void)addEvent:(Event *)ev
{
    [self scheduleLocalNotificationForEvent:ev];
}

- (void)removeEvent:(Event *)ev
{
    [self cancelLocalNotificationForEvent:ev];
}

- (void)updateEvent:(Event *)ev
{
    [self updateLocalNotificationForEvent:ev];
}

- (NSArray *)getTodayEvents
{
    NSMutableArray *ret = [NSMutableArray array];
    NSDate *today = [[NSDate alloc] init];
#if 0
    for (Event *ev in [Event MR_findAll]) {
        
        if ([ev isOnDate:today]) {

            //NSLog(@"bblu %@...",[ev.date getTypeString]);
            [ret addObject:ev];
        }
    }
#else
    int index = 0,index1 = 0;

    //for (; index < [Event count]; index++) {
    for (Event *ev in [Event MR_findAll]) {

        //Event *curr = event[index];
        if ([ev isOnDate:today]) {
        
        //NSLog(@"bblu insertEventToTodayTable:%d,%d,%d,%d",[curr.date.month integerValue],[curr.date.day integerValue],[event.date.month integerValue],[event.date.day integerValue]);
            
#if 0
        if ([curr.date.month integerValue] > [event.date.month integerValue])
        {
            break;
        }
        else if ([curr.date.month integerValue] == [event.date.month integerValue])
        {
            if ([curr.date.day integerValue] > [event.date.day integerValue])
            {
                break;
            }
            
        }
            
        
#endif
            if ( index != 0)
            {
                for (index1 = 0; index1 < index; index1++)
                {
                    Event *curr = [ret objectAtIndex:index1];
                    //NSLog(@"bblu curr:%@",[curr.date getTypeString]);
                    
                    if ([curr.date.month integerValue] > [ev.date.month integerValue])
                    {
                        break;
                    }
                    else if ([curr.date.month integerValue] == [ev.date.month integerValue])
                    {
                        if ([curr.date.day integerValue] > [ev.date.day integerValue])
                        {
                            break;
                        }
                        
                    }
                }
                [ret insertObject:ev atIndex:index1];
                
            }
            else
            {
                [ret addObject:ev];
            }
            index++;
        }
    }
  //  [ret insertObject:event atIndex:index];
#endif
    
#if 0
    NSSortDescriptor *hourSort = [[NSSortDescriptor alloc] initWithKey:@"time.hour" ascending:YES];
    NSSortDescriptor *minuteSort = [[NSSortDescriptor alloc] initWithKey:@"time.minute" ascending:YES];
    NSArray *sortDescriptors = @[hourSort, minuteSort];
    [ret sortUsingDescriptors:sortDescriptors];
#endif
    return ret;
}

- (NSArray *)getTomorrowEvents
{
    NSMutableArray *ret = [NSMutableArray array];
#if 0
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *tomorrow = [[NSDate alloc] initWithTimeIntervalSinceNow:secondsPerDay];
    
    for (Event *ev in [Event MR_findAll]) {
        if ([ev isOnDate:tomorrow]) {
            [ret addObject:ev];
        }
    }
#else
    NSDate *today = [[NSDate alloc] init];
    
    for (Event *ev in [Event MR_findAll]) {
        if ([ev isExpired:today]) {
            [ret addObject:ev];
        }
    }
#endif
    
#if 1
    NSSortDescriptor *hourSort = [[NSSortDescriptor alloc] initWithKey:@"time.hour" ascending:YES];
    NSSortDescriptor *minuteSort = [[NSSortDescriptor alloc] initWithKey:@"time.minute" ascending:YES];
    NSArray *sortDescriptors = @[hourSort, minuteSort];
    [ret sortUsingDescriptors:sortDescriptors];
#endif
    return ret;
}

- (NSMutableArray *)getActiveEvents
{
    NSDate *now = [[NSDate alloc] init];
    NSMutableArray *ret = [NSMutableArray array];
    
    for (Event *ev in [Event MR_findAll]) {
        if (![ev isExpired:now])
            [ret addObject:ev];
    }
    return ret;
}

- (NSMutableArray *)getExpiredEvents
{
    NSDate *now = [[NSDate alloc] init];
    NSMutableArray *ret = [NSMutableArray array];
    
    for (Event *ev in [Event MR_findAll]) {
        if ([ev isExpired:now])
            [ret addObject:ev];
    }
    return ret;
}

static NSString *LOCAL_NOTIFICATION_KEY = @"event_id";

- (void)cancelLocalNotificationForEvent:(Event *)event
{
    NSString *eid = [[[event objectID] URIRepresentation] absoluteString];
    NSLog(@"cancelLocalNotificationForEvent: %@", eid);
    NSArray *notifs = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *notif in notifs) {
        NSString *nid = [notif.userInfo objectForKey:LOCAL_NOTIFICATION_KEY];
        if ([eid isEqualToString:nid]) {
            NSLog(@"found local notification");
            [[UIApplication sharedApplication] cancelLocalNotification:notif];
        }
    }
}

- (void)scheduleLocalNotificationForEvent:(Event *)event
{
    if (![event.reminder.hasReminder boolValue])
        return;
    NSArray *notifs = [[UIApplication sharedApplication] scheduledLocalNotifications];
    if ([notifs count] >= 64) {
        NSLog(@"Local notification exceeded maximum");
        [GoogleAnalyticsHelper trackEventWithCategory:GA_CATEGORY_ERROR
                                               action:GA_ACTION_LOCAL_NOTIFICATION_EXCEED
                                                label:nil
                                                value:nil];
    }
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil)
        return;
    NSDate *date = [event getNextDate];
    date = [date dateByAddingTimeInterval:-60.0 * [event.reminder.minutesBefore integerValue]];
    
    //NSLog(@"bblu scheduleLocalNotificationForEvent: %@",date);
    localNotif.fireDate = date;
    switch ([event.date.type integerValue]) {
        case RBZEventDaily: localNotif.repeatInterval = NSDayCalendarUnit; break;
        case RBZEventWeekly: localNotif.repeatInterval = NSWeekCalendarUnit; break;
        case RBZEventMonthly: localNotif.repeatInterval = NSMonthCalendarUnit; break;
        case RBZEventYearly: localNotif.repeatInterval = NSYearCalendarUnit; break;
        case RBZEventOnce: {
            NSDate *now = [[NSDate alloc] init];
            if ([date timeIntervalSinceDate:now] < 0) {
                return;
            }
        }
    }
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    //localNotif.alertBody = event.title;
    //localNotif.alertBody = [NSString initWithFormat:@"%@(%d/%d)",event.title,[event.date.month integerValue],[event.date.day integerValue]];
    localNotif.alertBody = [[NSString alloc] initWithFormat:@"%@(%d/%d)",event.title,[event.date.month integerValue],[event.date.day integerValue]];
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    NSString *eid = [[[event objectID] URIRepresentation] absoluteString];
    NSLog(@"scheduleLocalNotificationForEvent: %@", eid);
    NSDictionary *info = [NSDictionary dictionaryWithObject:eid forKey:LOCAL_NOTIFICATION_KEY];
    localNotif.userInfo = info;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    
    //2
    
    //date = [date dateByAddingTimeInterval:-25*3600];
    NSDate *newDate2 = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([date timeIntervalSinceReferenceDate] - 24*3600)];
    
    localNotif.fireDate = newDate2;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    
    //3
    NSDate *newDate3 = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([newDate2 timeIntervalSinceReferenceDate] - 24*3600)];
    
    localNotif.fireDate = newDate3; 
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    //NSLog(@"bblu scheduleLocalNotificationForEvent end.....");
}

- (void)updateLocalNotificationForEvent:(Event *)event
{
    [self cancelLocalNotificationForEvent:event];
    [self scheduleLocalNotificationForEvent:event];
}

/*
- (void)removeDangingLocalNotifications
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_defaultContext];
    NSArray *notifs = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *notif in notifs) {
        NSString *nid = [notif.userInfo objectForKey:LOCAL_NOTIFICATION_KEY];
        NSLog(@"%@", nid);
        NSURL *url = [[NSURL alloc] initWithString:nid];
        NSManagedObjectID *objectId = [[localContext persistentStoreCoordinator] managedObjectIDForURIRepresentation:url];
        NSError *error;
        NSManagedObject *object = [localContext existingObjectWithID:objectId error:&error];
        if (!object) {
            NSLog(@"dangling local notification found");
        }
    }
}
*/

- (void)setupDefaultEvents
{
    NSDate *now = [NSDate date];
    NSDateComponents *add = [[NSDateComponents alloc] init];
    add.day = 15;
    NSDate *d = [self.defaultCalendar dateByAddingComponents:add toDate:now options:0];
    NSDateComponents *comps = [self.defaultCalendar components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit
                                          fromDate:d];
    
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_defaultContext];
    Event *event = [Event MR_createInContext:localContext];
    //bblu default label...........
    event.title = @"爸爸生日快乐.";
    EventTime *time = [EventTime MR_createInContext:localContext];
    time.hour = [NSNumber numberWithInteger:9];
    time.minute = [NSNumber numberWithInteger:0];
    EventDate *date = [EventDate MR_createInContext:localContext];
    date.type = [NSNumber numberWithInteger:RBZEventYearly];
    date.day = [NSNumber numberWithInteger:comps.day];
    date.month = [NSNumber numberWithInteger:comps.month];
    date.year = [NSNumber numberWithInteger:comps.year];
    EventReminder *reminder = [EventReminder MR_createInContext:localContext];
    reminder.hasReminder = [NSNumber numberWithBool:YES];
    event.date = date;
    event.time = time;
    event.reminder = reminder;
    [localContext MR_saveToPersistentStoreAndWait];
    
    //2
    Event *event2 = [Event MR_createInContext:localContext];
    //bblu default label...........
    event2.title = @"妈妈生日快乐.";
    EventTime *time2 = [EventTime MR_createInContext:localContext];
    time2.hour = [NSNumber numberWithInteger:9];
    time2.minute = [NSNumber numberWithInteger:0];
    EventDate *date2 = [EventDate MR_createInContext:localContext];
    date2.type = [NSNumber numberWithInteger:RBZEventYearly];
    date2.day = [NSNumber numberWithInteger:comps.day];
    date2.month = [NSNumber numberWithInteger:comps.month];
    date2.year = [NSNumber numberWithInteger:comps.year];
    EventReminder *reminder2 = [EventReminder MR_createInContext:localContext];
    reminder2.hasReminder = [NSNumber numberWithBool:YES];
    event2.date = date2;
    event2.time = time2;
    event2.reminder = reminder2;
    [localContext MR_saveToPersistentStoreAndWait];
    
    //3
    //bblu default label...........
    Event *event3 = [Event MR_createInContext:localContext];
    event3.title = @"爷爷生日快乐.";
    EventTime *time3 = [EventTime MR_createInContext:localContext];
    time3.hour = [NSNumber numberWithInteger:9];
    time3.minute = [NSNumber numberWithInteger:0];
    EventDate *date3 = [EventDate MR_createInContext:localContext];
    date3.type = [NSNumber numberWithInteger:RBZEventYearly];
    date3.day = [NSNumber numberWithInteger:comps.day];
    date3.month = [NSNumber numberWithInteger:comps.month];
    date3.year = [NSNumber numberWithInteger:comps.year];
    EventReminder *reminder3 = [EventReminder MR_createInContext:localContext];
    reminder3.hasReminder = [NSNumber numberWithBool:YES];
    event3.date = date3;
    event3.time = time3;
    event3.reminder = reminder3;
    [localContext MR_saveToPersistentStoreAndWait];
    
    //4
    //bblu default label...........
    Event *event4 = [Event MR_createInContext:localContext];
    event4.title = @"奶奶生日快乐.";
    EventTime *time4 = [EventTime MR_createInContext:localContext];
    time4.hour = [NSNumber numberWithInteger:9];
    time4.minute = [NSNumber numberWithInteger:0];
    EventDate *date4 = [EventDate MR_createInContext:localContext];
    date4.type = [NSNumber numberWithInteger:RBZEventYearly];
    date4.day = [NSNumber numberWithInteger:comps.day];
    date4.month = [NSNumber numberWithInteger:comps.month];
    date4.year = [NSNumber numberWithInteger:comps.year];
    EventReminder *reminder4 = [EventReminder MR_createInContext:localContext];
    reminder4.hasReminder = [NSNumber numberWithBool:YES];
    event4.date = date4;
    event4.time = time4;
    event4.reminder = reminder4;
    [localContext MR_saveToPersistentStoreAndWait];
    
    //5
    //bblu default label...........
    Event *event5 = [Event MR_createInContext:localContext];
    event5.title = @"老婆生日快乐.";
    EventTime *time5 = [EventTime MR_createInContext:localContext];
    time5.hour = [NSNumber numberWithInteger:9];
    time5.minute = [NSNumber numberWithInteger:0];
    EventDate *date5 = [EventDate MR_createInContext:localContext];
    date5.type = [NSNumber numberWithInteger:RBZEventYearly];
    date5.day = [NSNumber numberWithInteger:comps.day];
    date5.month = [NSNumber numberWithInteger:comps.month];
    date5.year = [NSNumber numberWithInteger:comps.year];
    EventReminder *reminder5 = [EventReminder MR_createInContext:localContext];
    reminder5.hasReminder = [NSNumber numberWithBool:YES];
    event5.date = date5;
    event5.time = time5;
    event5.reminder = reminder5;
    [localContext MR_saveToPersistentStoreAndWait];
    
    //5
    //bblu default label...........
    Event *event6 = [Event MR_createInContext:localContext];
    event6.title = @"该考试啦.";
    EventTime *time6 = [EventTime MR_createInContext:localContext];
    time6.hour = [NSNumber numberWithInteger:9];
    time6.minute = [NSNumber numberWithInteger:0];
    EventDate *date6 = [EventDate MR_createInContext:localContext];
    date6.type = [NSNumber numberWithInteger:RBZEventYearly];
    date6.day = [NSNumber numberWithInteger:comps.day];
    date6.month = [NSNumber numberWithInteger:comps.month];
    date6.year = [NSNumber numberWithInteger:comps.year];
    EventReminder *reminder6 = [EventReminder MR_createInContext:localContext];
    reminder6.hasReminder = [NSNumber numberWithBool:YES];
    event6.date = date6;
    event6.time = time6;
    event6.reminder = reminder6;
    [localContext MR_saveToPersistentStoreAndWait];
    
    // this event has no reminder, no need to call AddEvent:
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:DateReminder_defaultEventsKey];
    [defaults synchronize];
}


@end
