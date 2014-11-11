//
//  RBZEventTimeHintView.m
//  DateReminder
//
//  Created by Xyz on 2/27/14.
//  Copyright (c) 2014 Xyz Xyz. All rights reserved.
//

#import "RBZEventTimeHintView.h"

@implementation RBZEventTimeHintView

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
    self.arrowView.edge = UIRectEdgeBottom;
    self.arrowView.color = [UIColor darkGrayColor];
    self.hintContainer.layer.cornerRadius = 3.0;
}

@end
