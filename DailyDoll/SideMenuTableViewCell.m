//
//  MenuTableViewCell.m
//  DailyDoll
//
//  Created by Richmond on 2/4/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "SideMenuTableViewCell.h"
#import "APIManager.h"

@implementation SideMenuTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {


        self.backgroundColor = [UIColor colorWithHexString:[[APIManager sharedManager] fetchThemeItem:SIDEMENUCELL withProperty:kBackgroundColor]];
    }


    return self;
}

- (void)configureCell:(MenuItem *)menuItem {
    
    self.textLabel.text = [menuItem.title uppercaseString];
    
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    
    NSString *fontName = [[APIManager sharedManager] fetchThemeItem:SIDEMENUCELL withProperty:kFontFamily];
    
    [self.textLabel setFont:[UIFont fontWithName:fontName size:18]];
    
    if (menuItem.isHeader.boolValue) {
        [self setUpSectionHeader:menuItem];
    }
    
    if (menuItem.collapsable.boolValue) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
}

- (void)setUpSectionHeader:(MenuItem *)menuItem {

    self.textLabel.textColor = [UIColor whiteColor];
    
    if ([menuItem.title isEqualToString:@"THE LIFE STUFF"]) {
        self.backgroundColor = [UIColor colorWithHexString:@"7b7285"];
     
    } else if([menuItem.title isEqualToString:@"THE WELLNESS STUFF"]) {
        self.backgroundColor = [UIColor colorWithHexString:@"22756b"];
    } else {
        self.backgroundColor = [UIColor colorWithHexString:@"b7a7cb"];
    }
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
     //beauty c392b0
    //wellness 22756b
    //life stuff b7a7cb
}


@end
