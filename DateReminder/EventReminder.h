//
//  EventReminder.h
//  DateReminder
//
//  Created by Xyz on 14-1-4.
//  Copyright (c) 2014年 Xyz Xyz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface EventReminder : NSManagedObject

@property (nonatomic, retain) NSNumber * hasReminder;
@property (nonatomic, retain) NSNumber * minutesBefore;
@property (nonatomic, retain) Event *event;

@end
