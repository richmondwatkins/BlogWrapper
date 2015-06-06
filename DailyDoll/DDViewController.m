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
#import "UIView+Additions.h"


@interface DDViewController () < UIWebViewDelegate>

@property CenterVCActivityIndicator *acitivityIndicator;
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
    NSLog(@"==============");
    NSLog(request.URL.absoluteString);
    NSLog(@"==============");
    if ([request.URL.absoluteString containsString:@"googleads"] || [request.URL.absoluteString containsString:@"about:blank"]) {
        return NO;
    } else {
        return YES;
    }
}

-(void)webViewDidStartLoad:(UIWebView *)webView {
    
    self.webRequests ++;
    
    if (self.blurOverlay == nil && self.webRequests <= 1) {
        self.blurOverlay = [[BlurActivityOverlay alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        self.blurOverlay.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.blurOverlay.frame = webView.bounds;
        self.acitivityIndicator = [[CenterVCActivityIndicator alloc] initWithStyle];
        self.navigationItem.titleView = self.acitivityIndicator;
        
        [webView addSubview:self.blurOverlay];
    }
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {

    self.webResponses++;
    
    if ([[webView.request.URL absoluteString] containsString:
         self.domainString]){
        
        [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@", self.javascript]];
    }
    
    if (self.webResponses == self.webRequests) {
        [self.blurOverlay animateAndRemove];
        self.blurOverlay = nil;
        self.webRequests = 0;
        self.webResponses = 0;
    }

    
    [self.acitivityIndicator stopAnimating];

    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('id_username').select();"];

    if ([webView isKindOfClass:[OAuthWebView class]]) {
        [((OAuthWebView *) webView).activityIndicator stopAnimating];
    }

    //TODO check if meta title exists. If not check for h1 or h2
    CenterVCTitleLabel *titleLabel = [[CenterVCTitleLabel alloc]
                                      initWithStyleAndTitle:[webView stringByEvaluatingJavaScriptFromString:@"document.title"]];

    self.navigationItem.titleView = titleLabel;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    self.webResponses++;
    
    [self.acitivityIndicator stopAnimating];
    
    CenterVCTitleLabel *titleLabel = [[CenterVCTitleLabel alloc]
                                      initWithStyleAndTitle:[webView stringByEvaluatingJavaScriptFromString:@"document.title"]];
    
    self.navigationItem.titleView = titleLabel;
    
    [self.blurOverlay animateAndRemove];
    self.blurOverlay = nil;
    self.webRequests = 0;
    self.webResponses = 0;
}

- (BOOL)adjustForStatusBar {
    return YES;
}

@end
