//
//  SideMenuTableSectionHeader.m
//  DailyDoll
//
//  Created by Richmond on 2/6/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "SideMenuTableSectionHeader.h"
#import "ProjectSettings.h"

@implementation SideMenuTableSectionHeader

- (instancetype)initWithParentFrame:(CGRect)parentFrame {

    if (self = [super init]) {
        
        self.frame = CGRectMake(0, 0, parentFrame.size.width, 15);

        self.backgroundColor = [UIColor colorWithHexString:[[ProjectSettings sharedManager] fetchThemeItem:SIDEMENUSECTIONHEADER withProperty:kBackgroundColor]];
    }


    return self;
}


@end
