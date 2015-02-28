//
//  CenterVCTitleLabel.m
//  DailyDoll
//
//  Created by Richmond on 2/7/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "CenterVCTitleLabel.h"
#import "ProjectSettings.h"

@implementation CenterVCTitleLabel

- (instancetype)initWithStyleAndTitle:(NSString *)title {

    if (self = [super init]) {

        self.text = title;

        [self sizeToFit];

        NSString *fontString = [[ProjectSettings sharedManager] fetchMetaThemeItemWithProperty:kFontFamily];

        [self setFont:[UIFont fontWithName:fontString size:16]];

        self.textColor = [UIColor colorWithHexString:[[ProjectSettings sharedManager] fetchThemeItem:NAVBAR withProperty:kFontColor]];
    }

    return self;
}
@end
