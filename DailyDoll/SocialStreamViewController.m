//
//  SocialStreamViewController.m
//  DailyDoll
//
//  Created by Richmond Watkins on 5/31/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "SocialStreamViewController.h"
#import "ProjectSettings.h"
#import "SocialStreamViewModel.h"
@interface SocialStreamViewController ()

@property SocialStreamViewModel *viewModel;

@end

@implementation SocialStreamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.viewModel = [[SocialStreamViewModel alloc] init];
}

@end
