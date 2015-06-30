//
//  DDViewController.h
//  DailyDoll
//
//  Created by Richmond on 2/6/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocialSharePopoverView.h"
#import "SocialShareMethods.h"
#import "OAuthSignInView.h"
#import "BlurActivityOverlay.h"
#import "UIView+Additions.h"

@interface DDViewController : UIViewController

@property BlurActivityOverlay *blurOverlay;
@property UIImageView *logoImageView;
@property (nonatomic, strong)  UIWebView *webView;

- (void)removeViewsFromWindow;
- (void)webViewDidFinishLoad:(UIWebView *)webView;
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
- (void)removeBlurLoader;

@end
