//
//  DDViewController.m
//  DailyDoll
//
//  Created by Richmond on 2/6/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "DDViewController.h"
#import "ProjectSettings.h"
#import "ExternalWebModalViewController.h"
#import "OAuthWebView.h"
#import "OAuthSignInView.h"
#import "CenterVCTitleLabel.h"
#import "BlurActivityOverlay.h"
#import "CenterVCActivityIndicator.h"
#import "UIView+Additions.h"


@interface DDViewController () < UIWebViewDelegate>

@property BlurActivityOverlay *blurOverlay;
@property CenterVCActivityIndicator *acitivityIndicator;

@end

@implementation DDViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.statusBarBackground == nil) {

        self.statusBarBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
        self.statusBarBackground.backgroundColor = [UIColor colorWithHexString:[[ProjectSettings sharedManager] fetchThemeItem:STATUSBAR withProperty:kBackgroundColor]];
        self.statusBarBackground.autoresizingMask =  UIViewAutoresizingFlexibleWidth;
        [self.view addSubview:self.statusBarBackground];
        [[[UIApplication sharedApplication] keyWindow] addSubview:self.statusBarBackground];
    }

    if ([self adjustForStatusBar]) {
        self.view.top = self.statusBarBackground.bottom;
    }

    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:[[ProjectSettings sharedManager] fetchThemeItem:NAVBAR withProperty:kBackgroundColor]];

    self.view.backgroundColor = [UIColor colorWithHexString:[[ProjectSettings sharedManager] fetchThemeItem:NAVBAR withProperty:kBackgroundColor]];

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

}


-(void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {

    if (self.view.frame.size.height > self.view.frame.size.width) {
        //view is in portrait about to transtion to landscape
        self.statusBarBackground.hidden = YES;
    }else {

        self.statusBarBackground.hidden = NO;
    }
}


- (void)removeViewsFromWindow {

    NSArray *windowSubViews = [[[UIApplication sharedApplication] keyWindow] subviews];

    if (windowSubViews.count) {
//        [self.socialPopUp animateOffScreen];
//
//        [self.signInView animateOffScreen];
//        
        for (UIView *subView in windowSubViews) {
            if ([subView isKindOfClass:[OAuthSignInView class]]) {
                [((OAuthSignInView *)subView) animateOffScreen];
            }else if ([subView isKindOfClass:[SocialSharePopoverView class]]){
                [((SocialSharePopoverView *)subView) animateOffScreen];
            }
        }
    }
    
}

-(void)webViewDidStartLoad:(UIWebView *)webView {
    self.blurOverlay = [[BlurActivityOverlay alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    self.blurOverlay.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.blurOverlay.frame = webView.bounds;
    [webView addSubview:self.blurOverlay];
    self.acitivityIndicator = [[CenterVCActivityIndicator alloc] initWithStyle];
    self.navigationItem.titleView = self.acitivityIndicator;
}


-(void)webViewDidFinishLoad:(UIWebView *)webView {

    [self.blurOverlay animateAndRemove];

    [self.acitivityIndicator stopAnimating];

    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('id_username').select();"];

    if ([webView isKindOfClass:[OAuthWebView class]]) {
        [((OAuthWebView *) webView).activityIndicator stopAnimating];
    }

    if ([[webView.request.URL absoluteString] containsString:
         [[ProjectSettings sharedManager] fetchmetaDataVariables:kDomainString]]){

        NSString *jsFile = [[NSBundle mainBundle] pathForResource:@"webViewJS"
                                                           ofType:@"js"];
        NSString *javascript = [NSString stringWithContentsOfFile:jsFile encoding:NSUTF8StringEncoding error:NULL];

        [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@", javascript]];
    }

    //TODO check if meta title exists. If not check for h1 or h2
    CenterVCTitleLabel *titleLabel = [[CenterVCTitleLabel alloc]
                                      initWithStyleAndTitle:[webView stringByEvaluatingJavaScriptFromString:@"document.title"]];

    self.navigationItem.titleView = titleLabel;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {

    if (self.blurOverlay) {
        [self.blurOverlay animateAndRemove];
    }
}

- (BOOL)adjustForStatusBar {
    return YES;
}

@end
