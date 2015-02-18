//
//  CenterShareView.h
//  DailyDoll
//
//  Created by Richmond on 2/15/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@protocol CenterShare

@optional

- (void)socialWebView:(NSURL *)facebookURL;
- (void)facebookShareInternal:(NSString *)shareContent;
- (void)facebookShareExternal:(FBLinkShareParams *)shareContent;
- (NSURL *)returnCurrentURL;
- (void)oAuthSetUpDelegate:(int)socialOAuth;

@end

@interface CenterShareView : UIView

@property id<CenterShare> delegate;

- (instancetype)initWithFrameAndStyle:(CGRect)parentFrame;

- (void)animateOntoScreen;

- (void)animateOffScreen;

- (void)slideUpOnDrag:(int)pixels;

- (void)slideDownOnDrag:(int)pixels;

@end
