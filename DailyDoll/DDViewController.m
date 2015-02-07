//
//  DDViewController.m
//  DailyDoll
//
//  Created by Richmond on 2/6/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "DDViewController.h"
#import "UIColor+UIColor_Expanded.h"
#import "ProjectSettings.h"

@interface DDViewController ()

@end

@implementation DDViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIView *statusBarBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    statusBarBackground.backgroundColor = [UIColor colorWithHexString:[[ProjectSettings sharedManager] statusBarColor:@"BackgroundColor"]];
    [self.view addSubview:statusBarBackground];

    [[[UIApplication sharedApplication] keyWindow] addSubview:statusBarBackground];

    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"e2c675"];

    self.view.backgroundColor = [UIColor colorWithHexString:[[ProjectSettings sharedManager] navBar:@"BackgroundColor"]];

}


@end
