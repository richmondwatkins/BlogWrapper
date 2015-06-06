//
//  NotificationWebViewHeader.m
//  DailyDoll
//
//  Created by Richmond on 3/7/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "NotificationWebViewHeader.h"
#import "UIView+Additions.h"
#import "APIManager.h"

@implementation NotificationWebViewHeader

- (instancetype)initWithDate:(NSDate *)date andFrame:(CGRect)frame {

    if (self = [super init]) {

        self.frame = CGRectMake(0, 0, frame.size.width, 20);

        self.closeButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 0, self.width * 0.1, self.height)];
        [self.closeButton setImage:[UIImage imageNamed:@"exit"] forState:UIControlStateNormal];
        [self.closeButton sizeToFit];

        [self.closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];

        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];

        self.dateLabel.text = [self converDateToString:date];

        self.dateLabel.textColor = [UIColor colorWithHexString:[[APIManager sharedManager] fetchMetaThemeItemWithProperty:kSecondaryColor]];

        [self.dateLabel sizeToFit];

        [self addSubview:self.dateLabel];

        [self.dateLabel setCenter:CGPointMake(self.width/2, self.height/2)];

        [self addSubview:self.closeButton];
    }

    return self;
}

- (NSString *)converDateToString:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"MMMM dd yyyy hh:mm"];
    return [dateFormatter stringFromDate:date];
}

- (void)close {
    [self.delegate animateClose];
}

@end
