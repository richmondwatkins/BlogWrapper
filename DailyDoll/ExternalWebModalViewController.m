//
//  ExternalWebModalViewController.m
//  DailyDoll
//
//  Created by Richmond on 2/1/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "ExternalWebModalViewController.h"
#import "ExternalWebNavBar.h"
#import "ProjectSettings.h"

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

    ExternalWebNavBar *customNav = [[ExternalWebNavBar alloc] initWithCustomFrameAndStyling:self.view.frame.size.width];

    CGFloat buttonWidth = 20;
    CGFloat buttonPadding = 5;

    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(customNav.frame.size.width -  (buttonWidth + buttonPadding), 25, buttonWidth, buttonWidth)];
    [closeButton setTitle:@"X" forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(dissmissModal:) forControlEvents:UIControlEventTouchUpInside];

    [customNav addSubview:closeButton];

    [self.view addSubview:customNav];

    UIWebView *externalWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, customNav.frame.origin.y + customNav.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];

    externalWebView.delegate = self;

    [self.view addSubview:externalWebView];

    [externalWebView loadRequest:self.request];
}

- (IBAction)dissmissModal:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

    NSString *URLString = [request.URL absoluteString];
    if ([URLString hasPrefix:[[ProjectSettings sharedManager] fetchSocialItem:INSTAGRAM withProperty:kInstagramAppRedirectURL]]) {
        NSString *delimiter = @"access_token=";
        NSArray *components = [URLString componentsSeparatedByString:delimiter];
        if (components.count > 1) {
            NSString *accessToken = [components lastObject];
            NSLog(@"ACCESS TOKEN = %@",accessToken);
//            [[InstagramEngine sharedEngine] setAccessToken:accessToken];

            NSString *urlString=[NSString stringWithFormat:@"https://api.instagram.com/v1/users/%@/relationship?access_token=%@",@"486292136",accessToken];

            NSURL* url = [NSURL URLWithString:urlString];
            NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:1000.0];
            NSString *parameters=@"action=follow";
            [theRequest setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
            [theRequest setHTTPMethod:@"POST"];

            [NSURLConnection sendAsynchronousRequest:theRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                NSLog(@"Response %@",dict);
            }];
        }
        return NO;
    }

    return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {

    NSLog(@"URL %@", webView.request.URL.absoluteString);
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"Error %@",error);
}

@end
