//
//  CenterVCTitleLabel.m
//  DailyDoll
//
//  Created by Richmond on 2/7/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "CenterVCTitleLabel.h"

@implementation CenterVCTitleLabel

- (instancetype)initWithStyleAndTitle:(NSString *)title {

    if (self = [super init]) {

        self.text = title;

        [self sizeToFit];
        //TODO add font color and family
    }

    return self;
}
@end
