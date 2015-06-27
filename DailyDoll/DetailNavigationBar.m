//
//  DetailNavigationBar.m
//  DailyDoll
//
//  Created by Richmond on 3/5/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "DetailNavigationBar.h"
#import "APIManager.h"

@implementation DetailNavigationBar

- (instancetype)initWithCloseButtonAndFrame:(CGRect)frame {

    if (self = [super init]) {

        self.frame = frame;

         self.barTintColor = [UIColor colorWithHexString:[[APIManager sharedManager] fetchThemeItem:NAVBAR withProperty:kBackgroundColor]];

        self.rightBarButton = [[UIBarButtonItem alloc] init];
        self.rightBarButton.image = [UIImage imageNamed:@"exit"];
        self.rightBarButton.style = UIBarButtonItemStylePlain;
        self.rightBarButton.image = [UIImage imageNamed:@"exit"];
        self.rightBarButton.tintColor = [UIColor whiteColor];

        UINavigationItem *navItem = [[UINavigationItem alloc] init];
        navItem.rightBarButtonItem = self.rightBarButton;

        [self pushNavigationItem:navItem animated:YES];
    }

    return self;
}

@end
