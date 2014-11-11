//
//  EventReminder+Functions.h
//  Date Reminder
//
//  Created by Xyz on 14-1-1.
//  Copyright (c) 2014年 Xyz Xyz. All rights reserved.
//

#import "EventReminder.h"

@interface EventReminder (Functions)

- (NSString *)getReminderString;
+ (NSString *)getReminderString:(NSNumber *)hasReminder minutes:(NSNumber *)minutes;

@end
