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

- (instancetype)initWithHeight:(CGFloat)height andWidth:(CGFloat)width andText:(NSString *)text {

    if (self = [super init]) {

        self.frame = CGRectMake(0, height / 2, width, 20);

        self.textAlignment = NSTextAlignmentCenter;

        self.text = [text uppercaseString];

        NSString *fontName = [[ProjectSettings sharedManager] fetchMetaThemeItemWithProperty:kFontFamily];

        [self setFont:[UIFont fontWithName:fontName size:18]];

        self.textColor = [UIColor colorWithHexString:[[ProjectSettings sharedManager] fetchMetaThemeItemWithProperty:kSecondaryColor]];

        [self setCenter:CGPointMake(width / 2, 15)];
    }

    return self;
}

@end
