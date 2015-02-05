//
//  ExternalWebModalViewController.m
//  DailyDoll
//
//  Created by Richmond on 2/1/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "ExternalWebModalViewController.h"

@interface ExternalWebModalViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *externalWebView;

@end

@implementation ExternalWebModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.externalWebView loadRequest:self.request];
}

- (IBAction)dissmissModal:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
