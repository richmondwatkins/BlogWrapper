//
//  DDViewController.m
//  DailyDoll
//
//  Created by Richmond on 2/6/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "DDViewController.h"
#import "ProjectSettings.h"

@interface DDViewController ()
@property UIView *statusBarBackground;
@end

@implementation DDViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.statusBarBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    self.statusBarBackground.backgroundColor = [UIColor colorWithHexString:[[ProjectSettings sharedManager] fetchThemeItem:STATUSBAR withProperty:kBackgroundColor]];
    self.statusBarBackground.autoresizingMask =  UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.statusBarBackground];

    [[[UIApplication sharedApplication] keyWindow] addSubview:self.statusBarBackground];

    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"e2c675"];

    self.view.backgroundColor = [UIColor colorWithHexString:[[ProjectSettings sharedManager] fetchThemeItem:NAVBAR withProperty:kBackgroundColor]];

}

-(void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {

    if (self.view.frame.size.height > self.view.frame.size.width) {
        //view is in portrait about to transtion to landscape
        self.statusBarBackground.hidden = YES;
    }else {

        self.statusBarBackground.hidden = NO;
    }
}

@end
