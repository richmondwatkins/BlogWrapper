//
//  ShareView.m
//  DailyDoll
//
//  Created by Richmond on 2/7/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "ShareView.h"
#import "ProjectSettings.h"

@implementation ShareView

- (instancetype)initWithStyleAndFrame:(CGRect)parentFrame {

    if (self = [super init]) {

        self.backgroundColor = [UIColor colorWithHexString:[[ProjectSettings sharedManager] fetchThemeItem:SHAREVIEW withProperty:kBackgroundColor]];

        self.frame = parentFrame;
    }

    return self;
}

@end
