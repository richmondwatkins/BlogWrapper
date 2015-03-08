//
//  SideMenuTableSectionLabel.m
//  DailyDoll
//
//  Created by Richmond on 2/6/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "SideMenuTableSectionLabel.h"
#import "ProjectSettings.h"

@implementation SideMenuTableSectionLabel

- (instancetype)initWithParentFrame:(CGRect)parentFrame andText:(NSString *)text {

    if (self = [super init]) {

        self.frame = CGRectMake(0, parentFrame.size.height / 2, parentFrame.size.width, 20);

        self.textAlignment = NSTextAlignmentCenter;

        self.text = [text uppercaseString]; //TODO remove 

        NSString *fontName = [[ProjectSettings sharedManager] fetchMetaThemeItemWithProperty:kFontFamily];

        [self setFont:[UIFont fontWithName:fontName size:18]];

        self.textColor = [UIColor colorWithHexString:[[ProjectSettings sharedManager] fetchMetaThemeItemWithProperty:kSecondaryColor]];

        [self setCenter:CGPointMake(parentFrame.size.width / 2, 15)];
    }

    return self;
}

@end
