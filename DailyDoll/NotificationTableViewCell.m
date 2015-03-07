//
//  NotificationTableViewCell.m
//  DailyDoll
//
//  Created by Richmond on 3/5/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "NotificationTableViewCell.h"

@implementation NotificationTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCell:(Notification *)cellContents {

    UILabel *notificationTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, self.frame.size.width * 0.65, self.frame.size.height)];

    [self addSubview:notificationTextLabel];

    notificationTextLabel.text = cellContents.text;
}

@end
