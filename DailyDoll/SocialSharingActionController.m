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

- (SocialSharePopoverView *)facebookPopConfig:(CGRect)windowFrame {

    NSArray *buttonItems = [[ProjectSettings sharedManager]buttonsForShareItem:0];

    NSMutableArray *buttons = [NSMutableArray array];

    for (NSDictionary *buttonItem in buttonItems) {

        UIButton *button = [[UIButton alloc] init];
        [button setTitle:buttonItem[@"Title"] forState:UIControlStateNormal];

        switch ([buttonItem[@"Id"] intValue]) {
            case 0:  //View
                //
                break;
            case 1:  //Like
                //
                break;
            case 2:  //Share

                [button addTarget:self action:@selector(facebookShareDelegate:) forControlEvents:UIControlEventTouchUpInside];

                break;

            default:
                break;
        }

        [buttons addObject:button];
    }

    SocialSharePopoverView *popUpView = [[SocialSharePopoverView alloc] initWithParentFrame:windowFrame andButtons:[NSArray arrayWithArray:buttons]];

    return popUpView;
}

- (void)facebookShareDelegate:(UIButton *)button {
    
    [self.delegate facebookShare:[[ProjectSettings sharedManager] homeVariables:kTitle]];
}


@end
