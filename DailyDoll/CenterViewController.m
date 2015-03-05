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
#import "CenterVCTitleLabel.h"
#import "ShareViewController.h"
#import "CenterShareView.h"
#import "PushRequestViewController.h"
#import "DetailViewController.h"

@interface CenterViewController () <UIWebViewDelegate, SideMenuProtocol, UIScrollViewDelegate, CenterShare>

@property (nonatomic, strong)  UIWebView *webView;
@property NSURLRequest *externalRequest;
@property MMDrawerController *drawerController;
@property CGPoint lastScrollPosition;
@property (nonatomic)  BOOL isScrollingDown;
@property CenterShareView *shareSlideUp;

@end

@implementation CenterViewController


- (void)viewDidLoad {

    [super viewDidLoad];

    [self setUpWebView];

    [self setUpDrawControllerAndButton];

    [self setUpShareSlideUpView];

//    [[ProjectSettings sharedManager] listFonts];
}

- (void)viewDidAppear:(BOOL)animated {

    if (![[NSUserDefaults standardUserDefaults] boolForKey:kFirstStartUp]) {
        PushRequestViewController *pushVC = [[PushRequestViewController alloc] init];
        [self presentViewController:pushVC animated:YES completion:nil];
    }

}

- (void)setUpShareSlideUpView {

    if ([[ProjectSettings sharedManager] projectHasSocialAccounts]) {

        self.shareSlideUp = [[CenterShareView alloc] initWithFrameAndStyle:self.view.frame];

        self.shareSlideUp.delegate = self;

        [self.view addSubview:self.shareSlideUp];
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
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor colorWithHexString: [[ProjectSettings sharedManager] fetchMetaThemeItemWithProperty:kSecondaryColor]];
}

- (void)setRightNavigationItem {

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

    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[[ProjectSettings sharedManager] fetchmetaDataVariables:kURLString]]]];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

    NSString *domainString = [[ProjectSettings sharedManager] fetchmetaDataVariables:kDomainString];

    if (![[request.URL absoluteString] containsString:domainString]) {
        
        ExternalWebModalViewController *externalVC = [[ExternalWebModalViewController alloc] initWithRequest:request];

        [self presentViewController:externalVC animated:YES completion:nil];

        return NO;
    }

    if ([[request.URL absoluteString] containsString:domainString] &&
         ![[request.URL absoluteString] isEqualToString:[[ProjectSettings sharedManager] fetchmetaDataVariables: kURLString]]) {

        DetailViewController *detailVC = [[DetailViewController alloc] initWithRequest:request];

        [self.navigationController pushViewController:detailVC animated:YES];

        return NO;
    }

    [self.shareSlideUp animateOffScreen];

    [self removeWindowViews];

    return YES;
}


-(void)webViewDidFinishLoad:(UIWebView *)webView {

    [super webViewDidFinishLoad:webView];

    [self.shareSlideUp animateOntoScreen];
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
    

    [self removeViewsFromWindow];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

    
    if (self.isScrollingDown) {

        [self.shareSlideUp animateOffScreen];
    }else{

        [self.shareSlideUp animateOntoScreen];
    }
}

- (void)showSideMenu {

    [self.shareSlideUp animateOffScreen];

    [self.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)presentShareVC:(id)sender {

    [self.shareSlideUp animateOffScreen];

    [self.drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

- (void)selectedSideMenuItem:(NSString *)urlString {

    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
}

- (void)oAuthSetUpDelegate:(int)socialOAuth {

    [self instantiateOAuthLoginView:socialOAuth];
}

- (void)removeWindowViews {

    [self removeViewsFromWindow];
}


@end
