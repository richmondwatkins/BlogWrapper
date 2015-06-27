//
//  ExternalWebModalViewController.m
//  DailyDoll
//
//  Created by Richmond on 2/1/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "ExternalWebModalViewController.h"
#import "APIManager.h"
#import "DetailNavigationBar.h"

@interface ExternalWebModalViewController () <UIWebViewDelegate>

@property NSURLRequest *request;

@end

@implementation ExternalWebModalViewController


-(instancetype)initWithRequest:(NSURLRequest *)request {

    if(self= [super init]) {

        self.request = request;
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    DetailNavigationBar *customNav = [[DetailNavigationBar alloc] initWithCloseButtonAndFrame:CGRectMake(0, 0, self.view.frame.size.width, 65)];

    customNav.rightBarButton.target = self;
    customNav.rightBarButton.action = @selector(dissmissModal:);

    [self.view addSubview:customNav];

    UIWebView *externalWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, customNav.frame.origin.y + customNav.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];

    externalWebView.delegate = self;

    [self.view addSubview:externalWebView];

    [externalWebView loadRequest:self.request];
}

- (void)dissmissModal:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"REQUEST %@",webView.request.URL);
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"URL %@", webView.request.URL.absoluteString);
}



@end
