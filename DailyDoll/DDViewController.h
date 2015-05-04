//
//  DDViewController.h
//  DailyDoll
//
//  Created by Richmond on 2/6/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocialSharePopoverView.h"
#import "SocialSharingActionController.h"
#import "SocialSharePopoverView.h"
#import "SocialShareMethods.h"
#import "OAuthSignInView.h"
#import "BlurActivityOverlay.h"

@interface DDViewController : UIViewController

@property (nonatomic, strong) UIView *statusBarBackground;
@property BlurActivityOverlay *blurOverlay;


- (void)removeViewsFromWindow;

-(void)webViewDidFinishLoad:(UIWebView *)webView;

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;

@end
