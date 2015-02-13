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
#import "Button.h"

@interface SocialSharingActionController () <SocialPopUp>

@end

@import Social;

@implementation SocialSharingActionController

- (SocialSharePopoverView *)facebookPopConfig:(CGRect)windowFrame {

    NSArray *buttonItems = [[ProjectSettings sharedManager] fetchSocialButtonsForItem:FACEBOOK];

    NSMutableArray *buttons = [NSMutableArray array];

    for (Button *buttonItem in buttonItems) {

        UIButton *button = [[UIButton alloc] init];
        [button setTitle:buttonItem.title forState:UIControlStateNormal];

        switch ([buttonItem.id intValue]) {
            case 0:  //Like

                [button addTarget:self action:@selector(faceBookLikeDelegate:)
                 forControlEvents:UIControlEventTouchUpInside];

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

    SocialSharePopoverView *popUpView = [[SocialSharePopoverView alloc] initWithParentFrame:windowFrame andButtons:[NSArray arrayWithArray:buttons]];

    return popUpView;
}

- (void)facebookViewDelegate:(UIButton *)button {

    [self openWithAppOrWebView:[NSString stringWithFormat:@"fb://profile/%@",
                                [[ProjectSettings sharedManager] fetchSocialItem:FACEBOOK withProperty:@"pageId"]]
                     andWebURL:[NSString stringWithFormat:@"https://www.facebook.com/%@",
                                                           [[ProjectSettings sharedManager] fetchSocialItem:FACEBOOK withProperty:@"pageId"]]];
}

- (void)facebookShareDelegate:(UIButton *)button {

    FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
    
    params.link = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.facebook.com/%@",
                                        [[ProjectSettings sharedManager] fetchSocialItem:FACEBOOK withProperty:@"pageId"]]];

    // If the Facebook app is installed and we can present the share dialog
    if ([FBDialogs canPresentShareDialogWithParams:params]) {

        [self.delegate facebookShareExternal:params];
    } else {
        //TODO add share items ... text and images
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {

            [self.delegate facebookShareInternal:[[ProjectSettings sharedManager] metaDataVariables:kSiteName]];
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

    NSArray *buttonItems = [[ProjectSettings sharedManager] fetchSocialButtonsForItem:PINTEREST];

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

    SocialSharePopoverView *popUpView = [[SocialSharePopoverView alloc] initWithParentFrame:windowFrame andButtons:[NSArray arrayWithArray:buttons]];
    popUpView.delegate = self;

    return popUpView;

}

- (void)pinIt:(UIButton *)button {

    //TODO setup s3 to host images
    NSURL *imageURL     = [NSURL URLWithString:@"http://placekitten.com/500/400"];
    NSURL *sourceURL    = [NSURL URLWithString:[[ProjectSettings sharedManager] fetchSocialItem:PINTEREST withProperty:kURLString]];


    if ([self.pinterest canPinWithSDK]) {
        [self.pinterest createPinWithImageURL:imageURL
                                    sourceURL:sourceURL
                                  description:[[ProjectSettings sharedManager] metaDataVariables:kBlogName]];
    } else {

        [self.delegate socialWebView:sourceURL];
    }

}

- (void)viewBoards:(UIButton *)button {

    NSString *pintrestAccountName = [[ProjectSettings sharedManager] fetchSocialItem:PINTEREST withProperty:kAccountName];

    [self openWithAppOrWebView:[NSString stringWithFormat:@"pinterest://user/%@/", pintrestAccountName]
                     andWebURL:[NSString stringWithFormat:@"https://www.pinterest.com/%@/pins/", pintrestAccountName]];

}

//TODO save instagram auth token to keychain

// ======= Instagram ======

-(SocialSharePopoverView *)instagramPopConfig:(CGRect)windowFrame {

    NSArray *buttonItems = [[ProjectSettings sharedManager] fetchSocialButtonsForItem:INSTAGRAM];

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

                if ([[ProjectSettings sharedManager] hasInteractedWithSocialItem:INSTAGRAM]) {
                    [button setTitle:@"UnFollow" forState:UIControlStateNormal];
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

    SocialSharePopoverView *popUpView = [[SocialSharePopoverView alloc] initWithParentFrame:windowFrame andButtons:[NSArray arrayWithArray:buttons]];
    popUpView.delegate = self;

    return popUpView;

}

- (void)viewOnInstagram:(UIButton *)button {

    NSString *instagramAccountName = [[ProjectSettings sharedManager] fetchSocialItem:INSTAGRAM withProperty:kAccountName];

    [self openWithAppOrWebView:[NSString stringWithFormat:@"instagram://user?username=%@", instagramAccountName]
                     andWebURL:[NSString stringWithFormat:@"http://instagram.com/%@", instagramAccountName]];
}

- (void)authenticateAndFollowWithInstagram:(UIButton *) button {

//    NSString *authorizationURLConfigKey = [[ProjectSettings sharedManager] fetchSocialItem:INSTAGRAM withProperty:kInstagramAuthorizationUrl];
//    NSString *instagramKitAppClientId = [[ProjectSettings sharedManager]fetchSocialItem:INSTAGRAM withProperty:kInstagramAppClientId];
//    NSString *instagramKitAppRedirectURL = [[ProjectSettings sharedManager]fetchSocialItem:INSTAGRAM withProperty:kInstagramAppRedirectURL];
//
//    NSURL *instagramURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@&response_type=token&scope=relationships", authorizationURLConfigKey, instagramKitAppClientId, instagramKitAppRedirectURL]];

    [self.delegate instantiateOAuthLoginView:INSTAGRAM];

//    [self.delegate socialWebView:instagramURL];
}

//TODO save twitter auth token to keychain
// ========   Twitter =======

-(SocialSharePopoverView *)twitterPopConfig:(CGRect)windowFrame {

    NSArray *buttonItems = [[ProjectSettings sharedManager] fetchSocialButtonsForItem:TWIITER];

    NSMutableArray *buttons = [NSMutableArray array];

    for (Button *buttonItem in buttonItems) {

        UIButton *button = [[UIButton alloc] init];
        [button setTitle:buttonItem.title forState:UIControlStateNormal];

        switch ([buttonItem.id intValue]) {
            case 0: { //Follow

                if ([[ProjectSettings sharedManager] hasInteractedWithSocialItem:TWIITER]) {
                    [button setTitle:@"UnFollow" forState:UIControlStateNormal];
                }

                [button addTarget:self
                           action:@selector(checkForTwitterSession:)
                 forControlEvents:UIControlEventTouchUpInside];

            }   break;
            case 1: //

                [button addTarget:self
                           action:@selector(openOnTwitter:)
                 forControlEvents:UIControlEventTouchUpInside];

            default:
                break;
        }


        [self styleButtonAndAnimateActions:button withColor:[UIColor colorWithHexString:@"00aced"]];


        [buttons addObject:button];

    }

    SocialSharePopoverView *popUpView = [[SocialSharePopoverView alloc] initWithParentFrame:windowFrame andButtons:[NSArray arrayWithArray:buttons]];
    
    return popUpView;
    
}


- (void)checkForTwitterSession:(UIButton *)button {

    if (![[Twitter sharedInstance] session]) {

        [self.delegate instantiateOAuthLoginView:TWIITER];
    } else {
        [self createFollowRelationshipWithTwitter:[[Twitter sharedInstance] session] withFollowButton:button];
    }

}


- (void)openOnTwitter:(UIButton *)button {

    [self openWithAppOrWebView:[NSString stringWithFormat:@"twitter://user?id=%@", [[ProjectSettings sharedManager] fetchSocialItem:TWIITER withProperty:@"pageId"]]
                     andWebURL:[[ProjectSettings sharedManager] fetchSocialItem:TWIITER withProperty:kURLString]];
}

//TODO remove hard coded page id
- (void)checkForCurrentTwitterRelationshipWithCompletion:(void(^)(BOOL))isFollowing {

    NSString *statusesShowEndpoint = @"https://api.twitter.com/1.1/friendships/create.json?";

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

                 if (json[@"following"]) {

                     isFollowing(YES);
                 }else {

                     isFollowing(NO);
                 }
                 
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


-(void)createFollowRelationshipWithTwitter:(TWTRSession *)twitterSession withFollowButton:(UIButton *)button {

    NSString *statusesShowEndpoint;

    BOOL isFollowing = [[ProjectSettings sharedManager] hasInteractedWithSocialItem:TWIITER];

    if (!isFollowing) {

        statusesShowEndpoint = @"https://api.twitter.com/1.1/friendships/create.json?follow=true";

        [button setTitle:@"UnFollow" forState:UIControlStateNormal];
    }else {

        statusesShowEndpoint = @"https://api.twitter.com/1.1/friendships/destroy.json?";

        [button setTitle:@"Follow" forState:UIControlStateNormal];
    }

    [[ProjectSettings sharedManager] saveSocialInteraction:TWIITER withStatus:!isFollowing];

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
