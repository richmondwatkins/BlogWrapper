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
#import "CenterViewControllerActivityIndicator.h"

@interface CenterViewController () <UIWebViewDelegate, SideMenuProtocol>
@property UIWebView *webView;
@property NSURLRequest *externalRequest;
@property MMDrawerController *drawerController;
@property CenterViewControllerActivityIndicator *acitivityIndicator;
@end

@implementation CenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpWebView];

    [self setUpDrawControllerAndButton];

    self.acitivityIndicator =  [[CenterViewControllerActivityIndicator alloc] initWithStyle];

 

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.acitivityIndicator];

    self.title = [[ProjectSettings sharedManager] homeVariables:@"Title"];
}

- (void)setUpDrawControllerAndButton {

    self.drawerController = (MMDrawerController *)[[UIApplication sharedApplication] keyWindow].rootViewController;

    SideMenuViewController *sideMenuVC = (SideMenuViewController *) self.drawerController.leftDrawerViewController;
    sideMenuVC.delegate = self;

    self.navigationItem.leftBarButtonItem = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(showSideMenu)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
}

- (void)setUpWebView {

    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];

    [self.view addSubview:self.webView];

    self.webView.delegate = self;

    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[[ProjectSettings sharedManager] homeVariables:@"URLString"]]]];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

    [self.acitivityIndicator startAnimating];

    if (![[request.URL absoluteString] containsString:[[ProjectSettings sharedManager] homeVariables:@"DomainString"]]) {
        
        ExternalWebModalViewController *externalVC = [[ExternalWebModalViewController alloc] initWithRequest:request];

        [self presentViewController:externalVC animated:YES completion:nil];

        [self.acitivityIndicator stopAnimating];
        
        return NO;
    } else {

        return YES;

    }
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.acitivityIndicator stopAnimating];

    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('site-header')[0].style.display='none';"];
}

- (void)showSideMenu {

    [self.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];

}

- (void)selectedSideMenuItem:(NSDictionary *)navigationObject {

    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[navigationObject objectForKey:@"URL"]]]];
    self.title = [navigationObject objectForKey:@"Title"];
}




@end
