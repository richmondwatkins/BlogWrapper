//
//  MenuTableViewCell.m
//  DailyDoll
//
//  Created by Richmond on 2/4/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "SideMenuTableViewCell.h"
#import "ProjectSettings.h"

@implementation SideMenuTableViewCell


- (void)addTextToMenu:(NSDictionary *)menuItem {

    self.textLabel.text = menuItem[@"Title"];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {


        self.backgroundColor = [UIColor colorWithHexString:[[ProjectSettings sharedManager] sideMenuCell:kBackgroundColor]];

        if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
            [self setSeparatorInset:UIEdgeInsetsZero];
        }

        if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
            [self setLayoutMargins:UIEdgeInsetsZero];
        }
        
    }
    
    return self;
}



- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
