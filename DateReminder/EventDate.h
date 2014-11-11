//
//  EventDate.h
//  DateReminder
//
//  Created by Xyz on 14-1-4.
//  Copyright (c) 2014年 Xyz Xyz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface EventDate : NSManagedObject

@property (nonatomic, retain) NSNumber * day;
@property (nonatomic, retain) NSNumber * month;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSNumber * weekday;
@property (nonatomic, retain) NSNumber * year;
@property (nonatomic, retain) Event *event;

@end
