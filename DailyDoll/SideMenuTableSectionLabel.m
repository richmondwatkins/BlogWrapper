//
//  SideMenuTableSectionLabel.m
//  DailyDoll
//
//  Created by Richmond on 2/6/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "SideMenuTableSectionLabel.h"

@implementation SideMenuTableSectionLabel

- (instancetype)initWithHeight:(CGFloat)height andWidth:(CGFloat)width andText:(NSString *)text {

    if (self = [super init]) {

        self.frame = CGRectMake(0, height / 2, width, 15);

        self.textAlignment = NSTextAlignmentCenter;

        self.text = [text uppercaseString];
    }

    return self;
}

@end
