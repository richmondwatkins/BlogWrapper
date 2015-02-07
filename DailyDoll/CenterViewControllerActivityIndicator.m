//
//  CenterViewControllerActivityIndicator.m
//  DailyDoll
//
//  Created by Richmond on 2/7/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "CenterViewControllerActivityIndicator.h"
#import "ProjectSettings.h"
#import "UIColor+UIColor_Expanded.h"

@implementation CenterViewControllerActivityIndicator

- (instancetype)initWithStyle {

    if (self = [super init]) {

        self.color = [UIColor colorWithHexString:[[ProjectSettings sharedManager] activityIndicator:@"TintColor"]];

        [self hidesWhenStopped];
    }

    return self;
}
@end
