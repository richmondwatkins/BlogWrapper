//
//  SideMenuTableView.m
//  DailyDoll
//
//  Created by Richmond on 2/6/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "SideMenuTableView.h"
#import "ProjectSettings.h"

@implementation SideMenuTableView


-(void)removeInsetsAndStyle {

    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        [self setSeparatorInset:UIEdgeInsetsZero];
    }

    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        [self setLayoutMargins:UIEdgeInsetsZero];
    }

    self.backgroundColor = [UIColor colorWithHexString:[[ProjectSettings sharedManager] getSideMenuTableView:kBackgroundColor]];
    self.showsVerticalScrollIndicator = NO;

    CGFloat bottomInset = 40;
    self.contentInset = UIEdgeInsetsMake(0, 0 , bottomInset, 0);

}

@end
