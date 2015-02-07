//
//  SideMenuTableView.m
//  DailyDoll
//
//  Created by Richmond on 2/6/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "SideMenuTableView.h"
#import "UIColor+UIColor_Expanded.h"
#import "ProjectSettings.h"

@implementation SideMenuTableView


-(void)removeInsetsAndStyle {

    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        [self setSeparatorInset:UIEdgeInsetsZero];
    }

    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        [self setLayoutMargins:UIEdgeInsetsZero];
    }

    self.backgroundColor = [UIColor colorWithHexString:[[ProjectSettings sharedManager] sideMenuTableView:@"BackgroundColor"]];
    self.showsVerticalScrollIndicator = NO;

}

@end
