//
//  CenterViewControllerActivityIndicator.m
//  DailyDoll
//
//  Created by Richmond on 2/7/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "CenterVCActivityIndicator.h"
#import "APIManager.h"

@implementation CenterVCActivityIndicator

- (instancetype)initWithStyle {

    if (self = [super init]) {

        self.color = [UIColor colorWithHexString:[[APIManager sharedManager] fetchThemeItem:ACTIVITYINDICATOR withProperty:kBackgroundColor]];

        [self startAnimating];
//        [self hidesWhenStopped];
    }

    return self;
}
@end
