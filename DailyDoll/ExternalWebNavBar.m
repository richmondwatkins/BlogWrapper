//
//  ExternalWebNavBar.m
//  DailyDoll
//
//  Created by Richmond on 2/7/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "ExternalWebNavBar.h"
#import "ProjectSettings.h"

@implementation ExternalWebNavBar

- (instancetype)initWithCustomFrameAndStyling:(CGFloat)width {

    if (self = [super init]) {
        self.frame = CGRectMake(0, 15, width, 50);

        self.backgroundColor = [UIColor colorWithHexString:[[ProjectSettings sharedManager] getNavBar:kBackgroundColor]];
    }

    return self;
}

@end
