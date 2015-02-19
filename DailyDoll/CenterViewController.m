//
//  ViewController.m
//  DailyDoll
//
//  Created by Richmond on 2/1/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "CenterViewController.h"
#import "ExternalWebModalViewController.h"
#import "SideMenuViewController.h"
#import <MMDrawerController.h>
#import <MMDrawerBarButtonItem.h>
#import "ProjectSettings.h"
#import "BlurActivityOverlay.h"
#import "CenterVCActivityIndicator.h"
#import "CenterVCTitleLabel.h"
#import "ShareViewController.h"
#import "CenterShareView.h"

@interface CenterViewController () <UIWebViewDelegate, SideMenuProtocol, UIScrollViewDelegate, CenterShare>
@property UIWebView *webView;
@property NSURLRequest *externalRequest;
@property MMDrawerController *drawerController;
@property BlurActivityOverlay *blurOverlay;
@property CenterVCActivityIndicator *acitivityIndicator;
@property CGPoint lastScrollPosition;
@property BOOL isScrollingDown;
@property CenterShareView *shareSlideUp;

@end

@implementation CenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpWebView];

    [self setUpDrawControllerAndButton];

    self.shareSlideUp = [[CenterShareView alloc] initWithFrameAndStyle:self.view.frame];
    
    self.shareSlideUp.delegate = self;

    [self.view addSubview:self.shareSlideUp];

    [[ProjectSettings sharedManager] listFonts];
}

- (void)setUpDrawControllerAndButton {

    self.drawerController = (MMDrawerController *)[[UIApplication sharedApplication] keyWindow].rootViewController;

    SideMenuViewController *sideMenuVC = (SideMenuViewController *) self.drawerController.leftDrawerViewController;
    sideMenuVC.delegate = self;

    [self setLeftNavigationItem];
}

- (void)setLeftNavigationItem {

    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"left-menu"]
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(showSideMenu)];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor colorWithHexString: [[ProjectSettings sharedManager] fetchMetaThemeItemWithProperty:kSecondaryColor]];
}

- (void)setRightNavigationItem {
    //TODO move colors to theme manager and find share imag

    UIBarButtonItem *rightBarButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"share"]
                                                          style:UIBarButtonItemStylePlain
                                                         target:self
                                                                   action:@selector(presentShareVC:)];

    self.navigationItem.rightBarButtonItem= rightBarButton;

    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithHexString: [[ProjectSettings sharedManager] fetchMetaThemeItemWithProperty:kSecondaryColor]];
}

- (void)setUpWebView {

    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.webView];

    self.webView.delegate = self;
    self.webView.scrollView.delegate = self;

    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[[ProjectSettings sharedManager] metaDataVariables:kURLString]]]];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

    self.acitivityIndicator = [[CenterVCActivityIndicator alloc] initWithStyle];
    self.navigationItem.titleView = self.acitivityIndicator;

    if (![[request.URL absoluteString] containsString:[[ProjectSettings sharedManager] metaDataVariables:kDomainString]]) {
        
        ExternalWebModalViewController *externalVC = [[ExternalWebModalViewController alloc] initWithRequest:request];

        [self presentViewController:externalVC animated:YES completion:nil];

        return NO;
    }

    [self.shareSlideUp animateOffScreen];

    return YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView {

    self.blurOverlay = [[BlurActivityOverlay alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    self.blurOverlay.frame = webView.bounds;
    [webView addSubview:self.blurOverlay];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {

    [self.acitivityIndicator stopAnimating];

    NSString *jsFile = [[NSBundle mainBundle] pathForResource:@"webViewJS"
                                                     ofType:@"js"];
    NSString *javascript = [NSString stringWithContentsOfFile:jsFile encoding:NSUTF8StringEncoding error:NULL];

    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@", javascript]];

    CenterVCTitleLabel *titleLabel = [[CenterVCTitleLabel alloc]
                                      initWithStyleAndTitle:[webView stringByEvaluatingJavaScriptFromString:@"document.title"]];
    self.navigationItem.titleView = titleLabel;


    [self.blurOverlay animateAndRemove];

    [self.shareSlideUp animateOntoScreen];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {

    if (self.blurOverlay) {
        [self.blurOverlay animateAndRemove];
    }
}

-(NSURL *)returnCurrentURL {
    return self.webView.request.URL;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {


    CGPoint currentPosition = scrollView.contentOffset;

    if (currentPosition.y > self.lastScrollPosition.y){

//        [self.shareSlideUp slideDownOnDrag:[scrollView.panGestureRecognizer translationInView:scrollView].y / 10];

        self.isScrollingDown = YES;
    }else{

//        [self.shareSlideUp slideUpOnDrag:[scrollView.panGestureRecognizer translationInView:scrollView].y / 10];

        self.isScrollingDown = NO;
    }
    

    self.lastScrollPosition = currentPosition;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

    
    if (self.isScrollingDown) {

        [self.shareSlideUp animateOffScreen];
    }else{

        [self.shareSlideUp animateOntoScreen];
    }

}

- (void)showSideMenu {

    [self.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)presentShareVC:(id)sender {

    [self.drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

- (void)selectedSideMenuItem:(NSString *)urlString {

    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
}

- (void)oAuthSetUpDelegate:(int)socialOAuth {

    [self instantiateOAuthLoginView:socialOAuth];
}




@end
