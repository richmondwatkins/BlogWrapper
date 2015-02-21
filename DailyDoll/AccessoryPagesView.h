//
//  AccessoryPagesView.h
//  DailyDoll
//
//  Created by Richmond on 2/20/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AccessoryPageProtocol <NSObject>

- (void)showAccessoryPage:(NSString *)urlString;

@end

@interface AccessoryPagesView : UIView

@property UIView *popUp;

@property id<AccessoryPageProtocol> delegate;

- (instancetype)initWithFrameAndButtons:(CGRect)parentFrame;

- (void)animateOnToScreen:(CGRect)parentFrame;

- (void)animateOffOfScreen;

@end
