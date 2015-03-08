//
//  OAuthWebView.h
//  DailyDoll
//
//  Created by Richmond on 2/13/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CenterVCActivityIndicator.h"
@interface OAuthWebView : UIWebView

@property CenterVCActivityIndicator *activityIndicator;

@property NSURL *urlToLoad;

- (instancetype)initForInstagram:(CGRect)parentFrame;

@end
