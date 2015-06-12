//
//  CenterShareView.h
//  DailyDoll
//
//  Created by Richmond on 2/15/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FacebookSDK.h"

@protocol ShareSliderProtocol

@optional

- (void)socialWebView:(NSURL *)facebookURL;
- (void)facebookShareInternal:(NSString *)shareContent;
- (void)facebookShareExternal:(FBLinkShareParams *)shareContent;
- (NSURL *)returnCurrentURL;
- (void)oAuthSetUpDelegate:(int)socialOAuth;
- (void)removeWindowViews;

@end

@interface ShareViewSlider : UIView

@property id<ShareSliderProtocol> delegate;

- (instancetype)initWithFrameAndStyle:(CGRect)parentFrame;

- (void)animateOntoScreen;

- (void)animateOffScreen;

- (void)slideUpOnDrag:(int)pixels;

- (void)slideDownOnDrag:(int)pixels;

@end
