//
//  DetailViewController.m
//  DailyDoll
//
//  Created by Richmond on 3/1/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "DetailViewController.h"
#import "ShareViewSlider.h"
#import "BlurActivityOverlay.h"

@interface DetailViewController () <UIWebViewDelegate, ShareSliderProtocol, UIScrollViewDelegate>

@property NSURLRequest *request;
@property ShareViewSlider *shareSlideUp;
@property CGPoint lastScrollPosition;
@property (nonatomic)  BOOL isScrollingDown;
@property BlurActivityOverlay *detailBlurOverlay;

@end

@implementation DetailViewController

-(instancetype)initWithRequest:(NSURLRequest *)request {

    if(self= [super init]) {

        self.request = request;

    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];

    self.webView.delegate = self;

    self.webView.scrollView.delegate = self;

    [self.webView loadRequest:self.request];

    [self.view addSubview:self.webView];

    [self setUpShareSlideUpView];

    UIButton *backButton = [[UIButton alloc] init];
    UIImage *backImage = [UIImage imageNamed:@"back_arrow"];
    [backButton setBackgroundImage:backImage  forState:UIControlStateNormal];
    [backButton sizeToFit];
    [backButton addTarget:self action:@selector(popVC) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
}

- (void)setUpShareSlideUpView {
    if ([[APIManager sharedManager] projectHasSocialAccounts]) {

        self.shareSlideUp = [[ShareViewSlider alloc] initWithFrameAndStyle:self.view.frame];

        self.shareSlideUp.delegate = self;

        [self.view addSubview:self.shareSlideUp];
    }
}

- (void)oAuthSetUpDelegate:(int)socialOAuth {

        [self instantiateOAuthLoginView:socialOAuth];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [super webViewDidFinishLoad:webView];
    
    [self.shareSlideUp animateOntoScreen];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [super webView:webView didFailLoadWithError:error];
}

- (void)popVC {
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)adjustForStatusBar {
    return NO;
}

- (void)removeWindowViews {

    [self removeViewsFromWindow];
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

@end
