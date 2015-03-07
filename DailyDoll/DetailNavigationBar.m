//
//  DetailNavigationBar.m
//  DailyDoll
//
//  Created by Richmond on 3/5/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "DetailNavigationBar.h"
#import "ProjectSettings.h"

@implementation DetailNavigationBar

- (instancetype)initWithCloseButtonAndFrame:(CGRect)frame {

    if (self = [super init]) {

        self.frame = frame;

         self.barTintColor = [UIColor colorWithHexString:[[ProjectSettings sharedManager] fetchThemeItem:NAVBAR withProperty:kBackgroundColor]];

        self.rightBarButton = [[UIBarButtonItem alloc] init];
        self.rightBarButton.image = [UIImage imageNamed:@"exit"];
        self.rightBarButton.style = UIBarButtonItemStylePlain;
        self.rightBarButton.tintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"exit"]];

        UINavigationItem *navItem = [[UINavigationItem alloc] init];
        navItem.rightBarButtonItem = self.rightBarButton;

        [self pushNavigationItem:navItem animated:YES];
    }

    return self;
}

@end
