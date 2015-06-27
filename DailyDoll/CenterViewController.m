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
#import "APIManager.h"
#import "ShareViewController.h"
#import "CenterVCTitleLabel.h"
#import "ShareViewSlider.h"
#import "PushRequestViewController.h"
#import "DetailViewController.h"
#import "SocialStreamViewController.h"
#import <Fabric/Fabric.h>
#import <TwitterKit/TwitterKit.h>
#import <Crashlytics/Crashlytics.h>

@interface CenterViewController () <UIWebViewDelegate, SideMenuProtocol, ShareSliderProtocol, UIScrollViewDelegate>

@property (nonatomic, strong)  UIWebView *webView;
@property NSURLRequest *externalRequest;
@property MMDrawerController *drawerController;
@property ShareViewSlider *shareSlideUp;
@property CGFloat scrollViewOffset;

@end

@implementation CenterViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self setUpWebView];

    [self setUpDrawControllerAndButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setRightNavigationItem)
                                                 name:@"coreDataUpdated" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadWebView)
                                                 name:@"coreDataUpdated" object:nil];
    
    self.logoImageView = [[UIImageView alloc] initWithImage:
                          [[APIManager sharedManager] fetchLogoImage]];
    
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat navHeight = self.navigationController.navigationBar.height + statusBarHeight + 20;
    CGFloat navWidth = self.navigationController.navigationBar.width;
    
    self.logoImageView.frame = CGRectMake(
                                          navWidth / 2 - navHeight / 2,
                                          0 - statusBarHeight,
                                          navHeight,
                                          navHeight
                                          );
    
    
    
    [self.navigationController.navigationBar addSubview: self.logoImageView];
}

- (void)viewDidAppear:(BOOL)animated {
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:kFirstStartUp]) {
        PushRequestViewController *pushVC = [[PushRequestViewController alloc] init];
        [self presentViewController:pushVC animated:YES completion:nil];
    }
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
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor colorWithHexString: [[APIManager sharedManager] fetchMetaThemeItemWithProperty:kSecondaryColor]];
}

- (void)setRightNavigationItem {

    ShareViewController *shareViewController = [[ShareViewController alloc] init];
    
    self.drawerController.rightDrawerViewController = shareViewController;
    self.drawerController.maximumRightDrawerWidth = [shareViewController returnWidthForShareVC];
    
    UIBarButtonItem *rightBarButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"share"]
                                                          style:UIBarButtonItemStylePlain
                                                         target:self
                                                                   action:@selector(presentShareVC:)];

    self.navigationItem.rightBarButtonItem= rightBarButton;

    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithHexString: [[APIManager sharedManager] fetchMetaThemeItemWithProperty:kSecondaryColor]];
}

- (void)setUpWebView {
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.webView];

    self.webView.delegate = self;
    
    self.webView.scrollView.delegate = self;
    
    [self loadWebView];
}

- (void)loadWebView {
    
    NSString *urlString = [[APIManager sharedManager] fetchmetaDataVariables:kURLString];
    
    if (urlString != nil) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    }
    
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    [super webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];

    NSString *domainString = [[APIManager sharedManager] fetchmetaDataVariables:kDomainString];
    
    if (domainString == nil) {
        return NO;
    }
    
    if ([request.URL.absoluteString containsString:@"googleads"] ||
        [request.URL.absoluteString containsString:@"about:blank"]) {
        return NO;
    }
    
    if (![[request.URL absoluteString] containsString:domainString]) {
        
        ExternalWebModalViewController *externalVC = [[ExternalWebModalViewController alloc] initWithRequest:request];

        [self presentViewController:externalVC animated:YES completion:nil];
        
        [self removeBlurLoader];

        return NO;
    }

    if ([[request.URL absoluteString] containsString:domainString] &&
         ![[request.URL absoluteString] isEqualToString:[[APIManager sharedManager] fetchmetaDataVariables: kURLString]] &&
        self.isFromSideMenu == NO) {

        DetailViewController *detailVC = [[DetailViewController alloc] initWithRequest:request];
        
        [self.navigationController pushViewController:detailVC animated:YES];

        [self.blurOverlay animateAndRemove];
        
        return NO;
    }

    self.isFromSideMenu = NO;

    [self removeWindowViews];

    
    return YES;
}

- (void)showSideMenu {

    [self.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)presentShareVC:(id)sender {

    [self.drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
    
//    [self presentViewController:[[SocialStreamViewController alloc] init] animated:YES completion:nil];
}

- (void)selectedSideMenuItem:(NSString *)urlString {

    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
}

- (void)removeWindowViews {

    [self removeViewsFromWindow];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.scrollViewOffset = -scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat y = -scrollView.contentOffset.y;
    
    CGFloat minHeight = self.navigationController.navigationBar.height +
    [UIApplication sharedApplication].statusBarFrame.size.height;
    
    if (y < self.scrollViewOffset && self.logoImageView.height > minHeight) {
        CGFloat amountToMove = (self.scrollViewOffset - y) / 100;
        
        self.logoImageView.frame = CGRectMake(
                                              self.logoImageView.frame.origin.x + (amountToMove / 2),
                                              self.logoImageView.frame.origin.y,
                                              self.logoImageView.width - amountToMove,
                                              self.logoImageView.height - amountToMove
                                              );
    }
}

-(void)didReceiveMemoryWarning {
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}


@end
