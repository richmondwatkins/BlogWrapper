//
//  NotificationTableViewCell.m
//  DailyDoll
//
//  Created by Richmond on 3/5/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "NotificationTableViewCell.h"
#import "UIColor+UIColor_Expanded.h"
#import "UIView+Additions.h"
#import "ProjectSettingsKeys.h"

@interface NotificationTableViewCell ()

@end

@implementation NotificationTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.notificationTextLabel = [[UILabel alloc] init];
        self.dateLabel = [[UILabel alloc] init];
        
        [self addSubview:self.dateLabel];
        [self addSubview:self.notificationTextLabel];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
