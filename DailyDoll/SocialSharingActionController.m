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
#import <FacebookSDK/FacebookSDK.h>

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
            case 1: { //Like
                [button addTarget:self action:@selector(faceBookLikeDelegate:) forControlEvents:UIControlEventTouchUpInside];
    
                [buttons addObject:button];
            }
                break;
            case 2:  //Share

                [button addTarget:self action:@selector(facebookShareDelegate:) forControlEvents:UIControlEventTouchUpInside];
                [buttons addObject:button];
                break;

            default:
                break;
        }

        [button addTarget:self action:@selector(_handleLikeButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self
                        action:@selector(_handleLikeButtonTouchDown:)
              forControlEvents:(//UIControlEventTouchDragEnter |
                                UIControlEventTouchDown)];
        [button addTarget:self
                        action:@selector(_handleLikeButtonTouchUp:)
              forControlEvents:(UIControlEventTouchCancel |
                                //UIControlEventTouchDragExit |
                                UIControlEventTouchUpOutside)];

    }

    SocialSharePopoverView *popUpView = [[SocialSharePopoverView alloc] initWithParentFrame:windowFrame andButtons:[NSArray arrayWithArray:buttons]];

    return popUpView;
}



- (void)facebookShareDelegate:(UIButton *)button {


    [self.delegate facebookShare:[[ProjectSettings sharedManager] homeVariables:kTitle]];
}

- (void)faceBookLikeDelegate:(UIButton *)button {


    [self.delegate facebookLike];
}

- (void)_handleLikeButtonTap:(UIButton *)likeButton
{

    [self _handleLikeButtonTouchUp:likeButton];

}

- (void)_handleLikeButtonTouchDown:(UIButton *)likeButton
{
    [UIView animateWithDuration:0.1 animations:^{
        likeButton.transform = CGAffineTransformMakeScale(0.8, 0.8);
    }];
}

- (void)_handleLikeButtonTouchUp:(UIButton *)likeButton
{
    [UIView animateWithDuration:0.05 animations:^{
        likeButton.transform = CGAffineTransformIdentity;
    }];
}

@end
