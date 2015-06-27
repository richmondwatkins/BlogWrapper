//
//  DDViewController.m
//  DailyDoll
//
//  Created by Richmond on 2/6/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "DDViewController.h"
#import "APIManager.h"
#import "ExternalWebModalViewController.h"
#import "OAuthWebView.h"
#import "OAuthSignInView.h"
#import "CenterVCTitleLabel.h"
#import "CenterVCActivityIndicator.h"


@interface DDViewController () < UIWebViewDelegate>

@property NSString *javascript;
@property NSString *domainString;
@property NSInteger webRequests;
@property NSInteger webResponses;
@end

@implementation DDViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:[[APIManager sharedManager] fetchThemeItem:NAVBAR withProperty:kBackgroundColor]];

    self.view.backgroundColor = [UIColor colorWithHexString:[[APIManager sharedManager] fetchThemeItem:NAVBAR withProperty:kBackgroundColor]];

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    NSString *jsFile = [[NSBundle mainBundle] pathForResource:@"webViewJS"
                                                       ofType:@"js"];
    self.javascript = [NSString stringWithContentsOfFile:jsFile encoding:NSUTF8StringEncoding error:NULL];
    
    self.domainString = [[APIManager sharedManager] fetchmetaDataVariables:kDomainString];
    
}

- (void)removeViewsFromWindow {

    NSArray *windowSubViews = [[[UIApplication sharedApplication] keyWindow] subviews];

    if (windowSubViews.count) {
        for (UIView *subView in windowSubViews) {
            if ([subView isKindOfClass:[OAuthSignInView class]]) {
                [((OAuthSignInView *)subView) animateOffScreen];
            }else if ([subView isKindOfClass:[SocialSharePopoverView class]]){
                [((SocialSharePopoverView *)subView) animateOffScreen];
            }
        }
    }
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if ([request.URL.absoluteString containsString:@"googleads"] ||
        [request.URL.absoluteString containsString:@"about:blank"]) {
        return NO;
    }
    
    if (self.blurOverlay == nil && !self.webRequests) {
        self.blurOverlay = [[BlurActivityOverlay alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        self.blurOverlay.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.blurOverlay.frame = webView.frame;
        
        [webView addSubview:self.blurOverlay];
    }


    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    return YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView {
    
    self.webRequests ++;
    
    if ([[webView.request.URL absoluteString] containsString:
         self.domainString]){
        
        if (self.blurOverlay == nil && self.webRequests <= 1) {
            self.blurOverlay = [[BlurActivityOverlay alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
            self.blurOverlay.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            self.blurOverlay.frame = webView.frame;

            [webView addSubview:self.blurOverlay];
        }
    }
}


-(void)webViewDidFinishLoad:(UIWebView *)webView {

    self.webResponses++;
    
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@", self.javascript]];
    
    if (self.webResponses == self.webRequests) {
        [self removeBlurLoader];
    }
    
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('id_username').select();"];

    if ([webView isKindOfClass:[OAuthWebView class]]) {
        [((OAuthWebView *) webView).activityIndicator stopAnimating];
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    self.webResponses++;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
//   [self removeBlurLoader];
}

- (void)removeBlurLoader {

    [self.blurOverlay animateAndRemove];
    
    self.blurOverlay = nil;
    self.webRequests = 0;
    self.webResponses = 0;
}

- (BOOL)adjustForStatusBar {
    return YES;
}

@end
