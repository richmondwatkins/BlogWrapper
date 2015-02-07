//
//  ShareTableView.m
//  DailyDoll
//
//  Created by Richmond on 2/7/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "ShareTableView.h"
#import "ProjectSettings.h"

@implementation ShareTableView

-(instancetype)initWithStyleAndFrame:(CGRect)parentFrame {

    if (self = [super init]) {

        self.backgroundColor = [UIColor colorWithHexString:[[ProjectSettings sharedManager] shareTableView:kBackgroundColor]];

        self.frame = parentFrame;
    }

    return self;
}

@end
