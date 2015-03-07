//
//  BATableViewCell.m
//  DailyDoll
//
//  Created by Richmond on 3/5/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "BATableViewCell.h"

@implementation BATableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {

    [super layoutSubviews];

    //prevents label line from showing up on iPhone 5
    self.textLabel.frame = self.contentView.frame;

    if ([self respondsToSelector:@selector(setSeparatorInset:)])
        [self setSeparatorInset:UIEdgeInsetsZero];

    if ([self respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [self setPreservesSuperviewLayoutMargins:NO];;
    }

    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        [self setLayoutMargins:UIEdgeInsetsZero];
    }
}


@end
