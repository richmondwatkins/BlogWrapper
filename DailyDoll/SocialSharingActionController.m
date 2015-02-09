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
#import "UIColor+UIColor_Expanded.h"

@import Social;

@implementation SocialSharingActionController

- (SocialSharePopoverView *)facebookPopConfig:(CGRect)windowFrame {

    NSArray *buttonItems = [[ProjectSettings sharedManager]buttonsForShareItem:0];

    NSMutableArray *buttons = [NSMutableArray array];

    for (NSDictionary *buttonItem in buttonItems) {

        UIButton *button = [[UIButton alloc] init];
        [button setTitle:buttonItem[@"Title"] forState:UIControlStateNormal];

        switch ([buttonItem[@"Id"] intValue]) {
            case 0:  //View

                [button addTarget:self action:@selector(facebookViewDelegate:)
                 forControlEvents:UIControlEventTouchUpInside];

                break;
            case 1:  //Like

                [button addTarget:self action:@selector(faceBookLikeDelegate:)
                 forControlEvents:UIControlEventTouchUpInside];

                break;
            case 2:  //Share

                [button addTarget:self action:@selector(facebookShareDelegate:)
                 forControlEvents:UIControlEventTouchUpInside];

                break;

            default:
                break;
        }

        button.layer.cornerRadius = 3;

        button.backgroundColor = [UIColor colorWithHexString:@"425daf"];

        button.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];

        [button addTarget:self action:@selector(handleLikeButtonTouchUp:)
         forControlEvents:UIControlEventTouchUpInside];

        [button addTarget:self
                        action:@selector(handleLikeButtonTouchDown:)
              forControlEvents:(//UIControlEventTouchDragEnter |
                                UIControlEventTouchDown)];

        [button addTarget:self
                        action:@selector(handleLikeButtonTouchUp:)
              forControlEvents:(UIControlEventTouchCancel |
                                //UIControlEventTouchDragExit |
                                UIControlEventTouchUpOutside)];

        [buttons addObject:button];

    }

    SocialSharePopoverView *popUpView = [[SocialSharePopoverView alloc] initWithParentFrame:windowFrame andButtons:[NSArray arrayWithArray:buttons]];

    return popUpView;
}

- (void)facebookViewDelegate:(UIButton *)button {

    NSURL *facebookURL = [NSURL URLWithString:[NSString stringWithFormat:@"fb://profile/%@",
                                               [[ProjectSettings sharedManager] facebookId]]];

    if ([[UIApplication sharedApplication] canOpenURL:facebookURL]) {

        [[UIApplication sharedApplication] openURL:facebookURL];
    } else {

        [self.delegate facebookWebView:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.facebook.com/%@",
                                                             [[ProjectSettings sharedManager] facebookId]]]];
    }
}

- (void)facebookShareDelegate:(UIButton *)button {

    FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
    
    params.link = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.facebook.com/%@",
                                        [[ProjectSettings sharedManager] facebookId]]];

    // If the Facebook app is installed and we can present the share dialog
    if ([FBDialogs canPresentShareDialogWithParams:params]) {

        [self.delegate facebookShareExternal:params];
    } else {
        //TODO add share items ... text and images
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {

            [self.delegate facebookShareInternal:[[ProjectSettings sharedManager] homeVariables:kTitle]];
        }else {
            [self.delegate facebookWebView:params.link];
        }
    }

}

- (void)faceBookLikeDelegate:(UIButton *)button {


    [self.delegate facebookLike];
}

- (void)handleLikeButtonTap:(UIButton *)likeButton
{

    [self handleLikeButtonTouchUp:likeButton];

}

- (void)handleLikeButtonTouchDown:(UIButton *)likeButton
{
    [UIView animateWithDuration:0.1 animations:^{
        likeButton.transform = CGAffineTransformMakeScale(0.8, 0.8);
    }];
}

- (void)handleLikeButtonTouchUp:(UIButton *)likeButton
{
    [UIView animateWithDuration:0.05 animations:^{
        likeButton.transform = CGAffineTransformIdentity;
    }];
}


//==== TWITTER =====

//-(SocialSharePopoverView *)handleTwitterShare {
//
//}

@end
