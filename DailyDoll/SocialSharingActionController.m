//
//  SocialSharingActionController.m
//  DailyDoll
//
//  Created by Richmond on 2/7/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "SocialSharingActionController.h"
#import "ProjectSettings.h"
#import "SocialSharePopoverView.h"

@implementation SocialSharingActionController

+ (UIView *)facebookPopConfig:(CGRect)windowFrame {

    NSArray *buttonItems = [[ProjectSettings sharedManager]buttonsForShareItem:0];

    NSMutableArray *buttons = [NSMutableArray array];

    for (NSDictionary *buttonItem in buttonItems) {

        UIButton *button = [[UIButton alloc] init];
        [button setTitle:buttonItem[@"Title"] forState:UIControlStateNormal];

        [buttons addObject:button];
    }

    SocialSharePopoverView *popUpView = [[SocialSharePopoverView alloc] initWithParentFrame:windowFrame andButtons:[NSArray arrayWithArray:buttons]];

    return popUpView;
}

//.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
//CGRectMake(0, 0, windowFrame.size.width * 0.8, windowFrame.size.height / 2)
@end
