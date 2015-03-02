//
//  DetailViewController.m
//  DailyDoll
//
//  Created by Richmond on 3/1/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController () <UIWebViewDelegate>

@property NSURLRequest *request;

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

    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.frame];

    [self.view addSubview:webView];

    webView.delegate = self;

    [webView loadRequest:self.request];

    UIButton *backButton = [[UIButton alloc] init];
    UIImage *backImage = [UIImage imageNamed:@"back_arrow"];
    [backButton setBackgroundImage:backImage  forState:UIControlStateNormal];
    [backButton sizeToFit];
    [backButton addTarget:self action:@selector(popVC) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
}

- (void)popVC {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
