//
//  NotificationWebView.m
//  DailyDoll
//
//  Created by Richmond on 3/5/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "NotificationWebView.h"
#import "UIView+Additions.h"
#import "NotificationWebViewHeader.h"
#import "APIManager.h"

@interface NotificationWebView () <NotifcationHeader>

@property CGRect parentFrame;
@property CGRect originalRect;
@property NotificationWebViewHeader *header;


@end

@implementation NotificationWebView

- (instancetype)initWithCellRect:(CGRect)touchPoint andParentFrame:(CGRect)parentFrame andContent:(Notification *)notification{

    if (self= [super init]) {

        self.originalRect = touchPoint;

        self.parentFrame = parentFrame;

        self.frame = CGRectMake(parentFrame.origin.x, touchPoint.origin.y, touchPoint.size.width, touchPoint.size.height);

        [self loadHTMLString:notification.text baseURL:nil];

        self.backgroundColor = [UIColor whiteColor];
    }

    return self;
}

- (void)animateOpen:(CGRect)parentRect withNotification:(Notification *)notification {

    self.header = [[NotificationWebViewHeader alloc] initWithDate:notification.receivedDate andFrame:self.frame];
    self.header.backgroundColor = [UIColor colorWithHexString:
                                   [[APIManager sharedManager] fetchMetaThemeItemWithProperty:kPrimaryColor]];
    self.header.delegate = self;

    [self addSubview:self.header];

    [UIView animateWithDuration:0.3 animations:^{

        self.frame = CGRectMake(0, 0, parentRect.size.width, parentRect.size.height);

        self.header.frame = CGRectMake(0, 0, parentRect.size.width, parentRect.size.height * 0.1);

        self.header.closeButton.height = self.header.height;

        [self.header.dateLabel setCenter:CGPointMake(self.header.width/2, self.header.height/2)];
        
        [[self scrollView] setContentInset:UIEdgeInsetsMake(self.header.height, 0, 0, 0)];

    }];

}

- (void)animateClose {

    [UIView animateWithDuration:0.3 animations:^{
        
        self.alpha = 0;

    }completion:^(BOOL finished) {

        [self removeFromSuperview];
    }];
    
}

@end
