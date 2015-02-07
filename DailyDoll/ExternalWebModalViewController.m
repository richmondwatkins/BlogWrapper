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

@end
