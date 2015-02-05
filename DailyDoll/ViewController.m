//
//  ViewController.m
//  DailyDoll
//
//  Created by Richmond on 2/1/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "ViewController.h"
#import "ExternalWebModalViewController.h"
#import "SideMenuViewController.h"
#import <MMDrawerController.h>
#import <MMDrawerBarButtonItem.h>
#import "UIColor+UIColor_Expanded.h"

@interface ViewController () <UIWebViewDelegate, SideMenuProtocol>
@property UIWebView *webView;
@property NSURLRequest *externalRequest;
@property MMDrawerController *drawerController;
@property UIActivityIndicatorView *acitivityIndicator;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.webView];
    self.webView.delegate = self;

    self.drawerController = (MMDrawerController *)[[UIApplication sharedApplication] keyWindow].rootViewController;

    SideMenuViewController *sideMenuVC = (SideMenuViewController *) self.drawerController.leftDrawerViewController;
    sideMenuVC.delegate = self;

    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://thedailydoll.com/"]]];

    self.navigationItem.leftBarButtonItem = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(showSideMenu)];

    self.acitivityIndicator =  [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.acitivityIndicator hidesWhenStopped];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.acitivityIndicator];
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithHexString:@"f4f7fc"];
    self.title = @"The Daily Doll";
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

    [self.acitivityIndicator startAnimating];

    if (![[request.URL absoluteString] containsString:@"dailydoll"]) {

        self.externalRequest = request;
        [self performSegueWithIdentifier:@"ExternalWeb" sender:self];
    }


    return YES;
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"ExternalWeb"]) {
        ExternalWebModalViewController *ewVC = segue.destinationViewController;
        ewVC.request = self.externalRequest;
    }
}


@end
