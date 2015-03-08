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

//-(void)socialWebView:(NSURL *)facebookURL {
//
//    [self.socialPopUp animateOffScreen];
//
//    ExternalWebModalViewController *externalVC = [[ExternalWebModalViewController alloc] initWithRequest:[NSURLRequest requestWithURL:facebookURL]];
//
//    [self presentViewController:externalVC animated:YES completion:nil];
//}

//- (void)instantiateOAuthLoginView:(int)socialType {
//
//    UIWindow* mainWindow = [[UIApplication sharedApplication] keyWindow];
//
//    switch (socialType) {
//        case TWIITER:
//
//            self.signInView = [[OAuthSignInView alloc] initWithSubview:[self returnTwitterLoginButton] andParentFrame:mainWindow.frame];
//
//            [self.signInView animateOntoScreen:mainWindow.frame];
//
//            break;
//
//        case INSTAGRAM: {
//            OAuthWebView *oAuthWV = [[OAuthWebView alloc] initForInstagram:mainWindow.frame];
//
//            oAuthWV.delegate = self;
//
//            [oAuthWV loadRequest:[NSURLRequest requestWithURL:oAuthWV.urlToLoad]];
//
//            self.signInView = [[OAuthSignInView alloc] initWithSubview:oAuthWV andParentFrame:mainWindow.frame];
//
//            [self.socialPopUp animateOffScreen];
//
//            [self.signInView animateOntoScreen:mainWindow.frame];
//        }
//            break;
//
//        case GOOGLEPLUS: {
//
//            GPPSignIn *signIn = [GPPSignIn sharedInstance];
//            signIn.shouldFetchGooglePlusUser = YES;
//            //signIn.shouldFetchGoogleUserEmail = YES;  // Uncomment to get the user's email
//
//            // You previously set kClientId in the "Initialize the Google+ client" step
//            signIn.clientID = [[ProjectSettings sharedManager] fetchSocialItem:GOOGLEPLUS withProperty:kSocialClientId];;
//
//            // Uncomment one of these two statements for the scope you chose in the previous step
//            signIn.scopes = @[ kGTLAuthScopePlusLogin ];  // "https://www.googleapis.com/auth/plus.login" scope
//            //signIn.scopes = @[ @"profile" ];            // "profile" scope
//
//            // Optional: declare signIn.actions, see "app activities"
//            signIn.delegate = self;
//
//            [signIn trySilentAuthentication];
//
//            if (![[GPPSignIn sharedInstance] authentication]) {
//
//                self.signInView = [[OAuthSignInView alloc] initWithSubview:[self returnGooglePlusLoginButton] andParentFrame:mainWindow.frame];
//                
//                [self.signInView animateOntoScreen:mainWindow.frame];
//
//            }
//            
//        }
//            
//            break;
//            
//        default:
//            break;
//            
//    }
//    
//    
//    [mainWindow addSubview:self.signInView];
//
//}

//
//- (GPPSignInButton *)returnGooglePlusLoginButton {
//
//    GPPSignInButton *googlePlusButton = [[GPPSignInButton alloc] init];
//
//    [googlePlusButton addTarget:self action:@selector(removeViewsFromWindow)
//          forControlEvents:UIControlEventTouchUpInside];
//
//    return googlePlusButton;
//}
//
//
//- (void)displaySocialPoUp {
//
//    UIWindow* mainWindow = [[UIApplication sharedApplication] keyWindow];
//
//    [mainWindow addSubview: self.socialPopUp];
//
//    self.socialPopUp.delegate = self;
//
//    [self.socialPopUp animateOnToScreen];
//
//    [self.socialPopUp.subviews[0] setCenter:CGPointMake(mainWindow.frame.size.width / 2, mainWindow.frame.size.height / 2)];
//}

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
