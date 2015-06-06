//
//  NotificationTableView.m
//  DailyDoll
//
//  Created by Richmond on 3/5/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "NotificationTableView.h"
#import "APIManager.h"

@implementation NotificationTableView

- (instancetype)initWithStyleAndFrame:(CGRect)frame {

    if (self= [super init]) {

        self.backgroundColor = [UIColor colorWithHexString:[[APIManager sharedManager] fetchMetaThemeItemWithProperty:kSecondaryColor]];

        self.frame = frame;

        self.layer.cornerRadius = 2;
        
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }

    return self;
}



@end
