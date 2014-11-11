//
//  RBZEventBadgeCell.m
//  DateReminder
//
//  Created by Xyz on 2/22/14.
//  Copyright (c) 2014 Xyz Xyz. All rights reserved.
//

#import "RBZEventBadgeCell.h"
#import "RBZDateReminder.h"

@implementation RBZEventBadgeCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.containerView.layer.cornerRadius = 3.0;
    self.containerView.backgroundColor = [RBZDateReminder instance].theme.mainColor;
}

@end
