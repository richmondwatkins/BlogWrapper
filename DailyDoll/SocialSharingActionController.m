//
//  SocialSharingActionController.m
//  DailyDoll
//
//  Created by Richmond on 2/7/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "SocialSharingActionController.h"
#import "APIManager.h"
#import "SocialSharePopoverView.h"
#import "UIColor+UIColor_Expanded.h"
#import "Button.h"

#import "SocialShareMethods.h"

@interface SocialSharingActionController ()

@property SocialSharePopoverView *popUpView;

@end

@import Social;

@implementation SocialSharingActionController

- (SocialSharePopoverView *)facebookPopConfig:(CGRect)windowFrame {

    NSArray *buttonItems = [[APIManager sharedManager] fetchSocialButtonsForItem:FACEBOOK];

    NSMutableArray *buttons = [NSMutableArray array];

    for (Button *buttonItem in buttonItems) {

        UIButton *button = [[UIButton alloc] init];
        [button setTitle:buttonItem.title forState:UIControlStateNormal];

        switch ([buttonItem.id intValue]) {
            case 0:  //Like
                // The button handles itself
                break;
            case 1:  //View

                [button addTarget:self action:@selector(facebookViewDelegate:)
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

    self.popUpView = [[SocialSharePopoverView alloc] initWithParentFrame:windowFrame andButtons:[NSArray arrayWithArray:buttons] andSocialSiteName:kFacebook ];

    return self.popUpView;
}

- (void)facebookViewDelegate:(UIButton *)button {

    NSString *accountId = [[APIManager sharedManager] fetchSocialItem:FACEBOOK withProperty:@"accountId"];
    
    [self openWithAppOrWebView:[NSString stringWithFormat:@"fb://profile/%@",
                                accountId]
                     andWebURL:[NSString stringWithFormat:@"https://www.facebook.com/%@",
                                                           accountId]];
}

- (void)facebookShareDelegate:(UIButton *)button {

    FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
    
    params.link = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.facebook.com/%@",
                                        [[APIManager sharedManager] fetchSocialItem:FACEBOOK withProperty:@"accountId"]]];
    BOOL didShare = [[SocialShareMethods sharedManager] shareToFaceBookWithURL:params];

    if (!didShare) {

        [self.delegate socialWebView:params.link];
    }

    [self.popUpView animateOffScreen];
}

//==== Pintrest =====

-(SocialSharePopoverView *)pintrestPopConfig:(CGRect)windowFrame {

    NSArray *buttonItems = [[APIManager sharedManager] fetchSocialButtonsForItem:PINTEREST];

    NSMutableArray *buttons = [NSMutableArray array];

    for (Button *buttonItem in buttonItems) {

        UIButton *button = [[UIButton alloc] init];
        [button setTitle:buttonItem.title forState:UIControlStateNormal];

        switch ([buttonItem.id intValue]) {
            case 0: { //Pin

                self.pinterest = [[Pinterest alloc] initWithClientId:@"1442952"];

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

        [self styleButtonAndAnimateActions:button withColor:[UIColor colorWithHexString:@"cb2027"]];

        
        [buttons addObject:button];
        
    }

    SocialSharePopoverView *popUpView = [[SocialSharePopoverView alloc] initWithParentFrame:windowFrame andButtons:[NSArray arrayWithArray:buttons] andSocialSiteName:kPintrest];

    return popUpView;

}

- (void)pinIt:(UIButton *)button {

    //TODO setup s3 to host images
    NSURL *imageURL = [NSURL URLWithString:@"http://placekitten.com/g/200/300"];
    NSURL *sourceURL = [NSURL URLWithString:[[APIManager sharedManager] fetchSocialItem:PINTEREST withProperty:kSocialAccountURL]];

    BOOL didShare = [[SocialShareMethods sharedManager] pinToPinterest:imageURL andSource:sourceURL];

    if (!didShare) {

        [self.delegate socialWebView:sourceURL];
    }
    
}

- (void)viewBoards:(UIButton *)button {

    NSString *pintrestAccountName = [[APIManager sharedManager] fetchSocialItem:PINTEREST withProperty:kAccountName];

    [self openWithAppOrWebView:[NSString stringWithFormat:@"pinterest://user/%@/", pintrestAccountName]
                     andWebURL:[NSString stringWithFormat:@"https://www.pinterest.com/%@/pins/", pintrestAccountName]];

}

//TODO save instagram auth token to keychain

// ======= Instagram ======

-(SocialSharePopoverView *)instagramPopConfig:(CGRect)windowFrame {

    NSArray *buttonItems = [[APIManager sharedManager] fetchSocialButtonsForItem:INSTAGRAM];

    NSMutableArray *buttons = [NSMutableArray array];

    for (Button *buttonItem in buttonItems) {

        UIButton *button = [[UIButton alloc] init];
        [button setTitle:buttonItem.title forState:UIControlStateNormal];

        switch ([buttonItem.id intValue]) {
            case 0: { //View

                [button addTarget:self
                           action:@selector(viewOnInstagram:)
                 forControlEvents:UIControlEventTouchUpInside];

            }   break;
            case 1: //

                if ([[APIManager sharedManager] hasInteractedWithSocialItem:INSTAGRAM]) {
                    [button setTitle:@"Following" forState:UIControlStateNormal];
                }

                [button addTarget:self
                           action:@selector(authenticateAndFollowWithInstagram:)
                 forControlEvents:UIControlEventTouchUpInside];

            default:
                break;
        }


        [self styleButtonAndAnimateActions:button withColor:[UIColor colorWithHexString:@"517fa4"]];


        [buttons addObject:button];

    }

    SocialSharePopoverView *popUpView = [[SocialSharePopoverView alloc] initWithParentFrame:windowFrame andButtons:[NSArray arrayWithArray:buttons] andSocialSiteName:kInstagram];

    return popUpView;

}

- (void)viewOnInstagram:(UIButton *)button {

    NSString *instagramAccountName = [[APIManager sharedManager] fetchSocialItem:INSTAGRAM withProperty:kAccountName];

    [self openWithAppOrWebView:[NSString stringWithFormat:@"instagram://user?username=%@", instagramAccountName]
                     andWebURL:[NSString stringWithFormat:@"http://instagram.com/%@", instagramAccountName]];
}

- (void)authenticateAndFollowWithInstagram:(UIButton *) button {

    [self.delegate instantiateOAuthLoginView:INSTAGRAM];
}

//TODO save twitter auth token to keychain
// ========   Twitter =======

-(SocialSharePopoverView *)twitterPopConfig:(CGRect)windowFrame {

    NSArray *buttonItems = [[APIManager sharedManager] fetchSocialButtonsForItem:TWIITER];

    NSMutableArray *buttons = [NSMutableArray array];

    for (Button *buttonItem in buttonItems) {

        UIButton *button = [[UIButton alloc] init];
        [button setTitle:buttonItem.title forState:UIControlStateNormal];

        switch ([buttonItem.id intValue]) {
            case 0: { //Follow

                if ([[APIManager sharedManager] hasInteractedWithSocialItem:TWIITER]) {
                    [button setTitle:@"Following" forState:UIControlStateNormal];
                }

                [button addTarget:self
                           action:@selector(checkForTwitterSession:)
                 forControlEvents:UIControlEventTouchUpInside];

            }   break;
            case 1: //

                [button addTarget:self
                           action:@selector(openOnTwitter:)
                 forControlEvents:UIControlEventTouchUpInside];

                break;
            case 2:

                [button addTarget:self
                           action:@selector(tweet:)
                 forControlEvents:UIControlEventTouchUpInside];
                break;

            default:
                break;
        }


        [self styleButtonAndAnimateActions:button withColor:[UIColor colorWithHexString:@"00aced"]];


        [buttons addObject:button];

    }

    self.popUpView = [[SocialSharePopoverView alloc] initWithParentFrame:windowFrame andButtons:[NSArray arrayWithArray:buttons] andSocialSiteName:@"Twitter"];
    
    return self.popUpView;
    
}

- (void)tweet:(UIButton *)button {

    NSString *accountURLString = [[APIManager sharedManager] fetchSocialItem:TWIITER withProperty:kSocialAccountURL];

    NSString *blogName = [[APIManager sharedManager] fetchSocialItem:INSTAGRAM withProperty:kAccountName];

    BOOL didShare = [[SocialShareMethods sharedManager] shareToTwitter:[NSString stringWithFormat:@"%@ - %@", blogName, accountURLString]];

    if (!didShare) {

        [self.delegate socialWebView:[NSURL URLWithString:accountURLString]];
    }

    [self.popUpView animateOffScreen];
}


- (void)checkForTwitterSession:(UIButton *)button {

    if (![[Twitter sharedInstance] session]) {

        [self.delegate instantiateOAuthLoginView:TWIITER];
    } else {
        [self createFollowRelationshipWithTwitter:[[Twitter sharedInstance] session] withFollowButton:button];
    }

}


- (void)openOnTwitter:(UIButton *)button {

    [self openWithAppOrWebView:[NSString stringWithFormat:@"twitter://user?id=%@", [[APIManager sharedManager] fetchSocialItem:TWIITER withProperty:@"accountId"]]
                     andWebURL:[[APIManager sharedManager] fetchSocialItem:TWIITER withProperty:kSocialAccountURL]];
}


-(void)createFollowRelationshipWithTwitter:(TWTRSession *)twitterSession withFollowButton:(UIButton *)button {

    NSString *statusesShowEndpoint;

    BOOL isFollowing = [[APIManager sharedManager] hasInteractedWithSocialItem:TWIITER];

    if (!isFollowing) {

        statusesShowEndpoint = @"https://api.twitter.com/1.1/friendships/create.json?follow=true";

        [button setTitle:@"Following" forState:UIControlStateNormal];
    }else {

        statusesShowEndpoint = @"https://api.twitter.com/1.1/friendships/destroy.json?";

        [button setTitle:@"Follow" forState:UIControlStateNormal];
    }

    [[APIManager sharedManager] saveSocialInteraction:TWIITER withStatus:!isFollowing];

 //TODO add activity indicator in button to show request

    NSDictionary *params = @{@"user_id" : @"1630611914"};

    NSError *clientError;
    NSURLRequest *request = [[[Twitter sharedInstance] APIClient]
                             URLRequestWithMethod:@"POST"
                             URL:statusesShowEndpoint
                             parameters:params
                             error:&clientError];

    if (request) {
        [[[Twitter sharedInstance] APIClient]
         sendTwitterRequest:request
         completion:^(NSURLResponse *response,
                      NSData *data,
                      NSError *connectionError) {
             if (data) {
                 // handle the response data e.g.
                 NSError *jsonError;
                 NSDictionary *json = [NSJSONSerialization
                                       JSONObjectWithData:data
                                       options:0
                                       error:&jsonError];

                 NSLog(@"RESPONSE: %@",json);
             }
             else {
                 NSLog(@"Error: %@", connectionError);
             }
         }];
    }
    else {
        NSLog(@"Error: %@", clientError);
    }

}


// =========== GOOGLE PLUS =======

- (SocialSharePopoverView *) googlePlusPopConfig:(CGRect)windowFrame {

    NSArray *buttonItems = [[APIManager sharedManager] fetchSocialButtonsForItem:GOOGLEPLUS];

    NSMutableArray *buttons = [NSMutableArray array];

    for (Button *buttonItem in buttonItems) {

        UIButton *button = [[UIButton alloc] init];
        [button setTitle:buttonItem.title forState:UIControlStateNormal];

        switch ([buttonItem.id intValue]) {
            case 0: { //View

                [button addTarget:self action:@selector(googlePlusView:) forControlEvents:UIControlEventTouchUpInside];

            }   break;
            case 1: //Share

                [self.popUpView animateOffScreen];

                [button addTarget:self action:@selector(googlePlusShare:) forControlEvents:UIControlEventTouchUpInside];
            default:
                break;
        }


        [self styleButtonAndAnimateActions:button withColor:[UIColor colorWithHexString:@"dd4b39"]];


        [buttons addObject:button];

    }
    
    self.popUpView = [[SocialSharePopoverView alloc] initWithParentFrame:windowFrame andButtons:[NSArray arrayWithArray:buttons] andSocialSiteName:kGooglePlus];
    
    return self.popUpView;

}


- (void) googlePlusShare:(UIButton *)button {


    NSURL *sourceURL = [NSURL URLWithString:[[APIManager sharedManager] fetchSocialItem:GOOGLEPLUS withProperty:kSocialAccountURL]];

    BOOL didShare = [[SocialShareMethods sharedManager] shareToGooglePlus:sourceURL.absoluteString];

    if (!didShare) {

        [self.delegate instantiateOAuthLoginView:GOOGLEPLUS];
    }
}

- (void) googlePlusView:(UIButton *)button {

    NSURL *webURL = [NSURL URLWithString:[[APIManager sharedManager] fetchSocialItem:GOOGLEPLUS withProperty:kSocialAccountURL]];
    [self.delegate socialWebView:webURL];
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
