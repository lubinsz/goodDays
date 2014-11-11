//
//  RBZIAPHelper.h
//  Date Reminder
//
//  Created by Xyz on 14-1-4.
//  Copyright (c) 2014年 Xyz Xyz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAPHelper.h"

static NSString *const RBZIAP_buyCoffee = @"com.lubinsz.gooddays.baac";

@interface RBZIAPHelper : IAPHelper

+ (RBZIAPHelper *)sharedInstance;

@end
