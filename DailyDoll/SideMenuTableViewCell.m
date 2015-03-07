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


- (void)addTextToMenu:(MenuItem *)menuItem {

    self.textLabel.text = [menuItem.title uppercaseString];

    self.textLabel.textAlignment = NSTextAlignmentCenter;

    NSString *fontName = [[ProjectSettings sharedManager] fetchThemeItem:SIDEMENUCELL withProperty:kFontFamily];

    [self.textLabel setFont:[UIFont fontWithName:fontName size:18]];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {


        self.backgroundColor = [UIColor colorWithHexString:[[ProjectSettings sharedManager] fetchThemeItem:SIDEMENUCELL withProperty:kBackgroundColor]];
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
