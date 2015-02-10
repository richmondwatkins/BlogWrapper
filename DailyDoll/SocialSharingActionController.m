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

        [self styleButtonAndAnimateActions:button withColor:[UIColor colorWithHexString:@"425daf"]];

        [buttons addObject:button];

    }

    SocialSharePopoverView *popUpView = [[SocialSharePopoverView alloc] initWithParentFrame:windowFrame andButtons:[NSArray arrayWithArray:buttons]];

    return popUpView;
}

- (void)facebookViewDelegate:(UIButton *)button {

    [self openWithAppOrWebView:[NSString stringWithFormat:@"fb://profile/%@",
                                [[ProjectSettings sharedManager] facebookId]]
                     andWebURL:[NSString stringWithFormat:@"https://www.facebook.com/%@",
                                                           [[ProjectSettings sharedManager] facebookId]]];
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
            [self.delegate socialWebView:params.link];
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


//==== Pintrest =====

-(SocialSharePopoverView *)pintrestPopConfig:(CGRect)windowFrame {

    NSArray *buttonItems = [[ProjectSettings sharedManager]buttonsForShareItem:1];

    NSMutableArray *buttons = [NSMutableArray array];

    for (NSDictionary *buttonItem in buttonItems) {

        UIButton *button = [[UIButton alloc] init];
        [button setTitle:buttonItem[@"Title"] forState:UIControlStateNormal];

        switch ([buttonItem[@"Id"] intValue]) {
            case 0: { //Pin

                self.pinterest = [[Pinterest alloc]initWithClientId:[[ProjectSettings sharedManager]pintrestId]];

                [button addTarget:self
                           action:@selector(pinIt:)
                 forControlEvents:UIControlEventTouchUpInside];

            }   break;
            case 1:

                [button addTarget:self
                           action:@selector(viewBoards:)
                 forControlEvents:UIControlEventTouchUpInside];

            default:
                break;
        }

        [self styleButtonAndAnimateActions:button withColor:[UIColor redColor]];

        
        [buttons addObject:button];
        
    }

    SocialSharePopoverView *popUpView = [[SocialSharePopoverView alloc] initWithParentFrame:windowFrame andButtons:[NSArray arrayWithArray:buttons]];

    return popUpView;

}

- (void)pinIt:(UIButton *)button {

    //TODO setup s3 to host images
    NSURL *imageURL     = [NSURL URLWithString:@"http://placekitten.com/500/400"];
    NSURL *sourceURL    = [NSURL URLWithString:[[ProjectSettings sharedManager] socialPropertiesForItem:1 withItem:kURLString]];


    if ([self.pinterest canPinWithSDK]) {
        [self.pinterest createPinWithImageURL:imageURL
                                    sourceURL:sourceURL
                                  description:[[ProjectSettings sharedManager] homeVariables:kBlogName]];
    } else {

        [self.delegate socialWebView:sourceURL];
    }

}

- (void)viewBoards:(UIButton *)button {

    NSString *pintrestAccountName = [[ProjectSettings sharedManager] socialAccountName:1];

    [self openWithAppOrWebView:[NSString stringWithFormat:@"pinterest://user/%@/", pintrestAccountName]
                     andWebURL:[NSString stringWithFormat:@"https://www.pinterest.com/%@/pins/", pintrestAccountName]];

}


//helper methods

- (void) styleButtonAndAnimateActions:(UIButton *)button withColor:(UIColor *)color {

    button.layer.cornerRadius = 3;

    button.backgroundColor = color;

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
}

- (void)openWithAppOrWebView:(NSString *)deepLinkURLString andWebURL:(NSString *)webURLString {

    NSURL *deepLinkURL = [NSURL URLWithString:deepLinkURLString];

    if ([[UIApplication sharedApplication] canOpenURL:deepLinkURL]) {

        [[UIApplication sharedApplication] openURL:deepLinkURL];
    } else {
        NSURL *webURL = [NSURL URLWithString:webURLString];
        [self.delegate socialWebView:webURL];
    }
}

@end
