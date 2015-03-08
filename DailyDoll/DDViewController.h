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

@interface DDViewController : UIViewController

@property UIView *statusBarBackground;

- (void)removeViewsFromWindow;

-(void)webViewDidFinishLoad:(UIWebView *)webView;

@end
