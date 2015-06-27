//
//  CenterVCTitleLabel.m
//  DailyDoll
//
//  Created by Richmond on 2/7/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "CenterVCTitleLabel.h"
#import "APIManager.h"

@implementation CenterVCTitleLabel

- (instancetype)initWithStyleAndTitle:(NSString *)title andFrame:(CGRect)frame {

    if (self = [super init]) {
        
        self.frame = frame;

        self.text = title;

        NSString *fontString = [[APIManager sharedManager] fetchMetaThemeItemWithProperty:kFontFamily];

        [self setFont:[UIFont fontWithName:fontString size:16]];

        self.textColor = [UIColor colorWithHexString:[[APIManager sharedManager] fetchThemeItem:NAVBAR withProperty:kFontColor]];
    }

    return self;
}
@end
