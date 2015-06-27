//
//  MenuTableViewCell.m
//  DailyDoll
//
//  Created by Richmond on 2/4/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "SideMenuTableViewCell.h"
#import "APIManager.h"
#import "DropDownImageView.h"
#import "UIView+Additions.h"

@interface SideMenuTableViewCell()

@property DropDownImageView *dropDownImageView;
@property UILabel *titleLabel;

@end

@implementation SideMenuTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {


        self.backgroundColor = [UIColor colorWithHexString:[[APIManager sharedManager] fetchThemeItem:SIDEMENUCELL withProperty:kBackgroundColor]];
        
        self.dropDownImageView = [[DropDownImageView alloc] initWithImage:[UIImage imageNamed:@"dropDown"]];
        self.dropDownImageView.userInteractionEnabled = YES;
        
        self.titleLabel = [[UILabel alloc] init];
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.dropDownImageView];
    }


    return self;
}

- (void)configureCell:(MenuItem *)menuItem {
    
    [self configureTitleLabel:menuItem];
    
    if (menuItem.isHeader.boolValue) {
        [self setUpSectionHeader:menuItem];
    } else {
        self.backgroundColor = [UIColor colorWithHexString:[[APIManager sharedManager] fetchThemeItem:SIDEMENUCELL withProperty:kBackgroundColor]];
        self.titleLabel.textColor = [UIColor blackColor];
    }
    
    if (menuItem.collapsable.boolValue) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.dropDownImageView.hidden = NO;
        CGFloat dropWidth = self.dropDownImageView.width;
        CGFloat dropHeight = self.dropDownImageView.height;
        
        self.dropDownImageView.frame = CGRectMake(
                                            self.dropDownImageView.frame.origin.x,
                                            self.contentView.height / 2 - dropHeight / 2,
                                            dropWidth,
                                            dropHeight
                                        );
        
    } else {
        self.dropDownImageView.hidden = YES;
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
}

- (void)configureTitleLabel:(MenuItem *)menuItem {
    self.titleLabel.text = [menuItem.title uppercaseString];
    
    NSString *fontName = [[APIManager sharedManager] fetchThemeItem:SIDEMENUCELL withProperty:kFontFamily];
    
    UIFont *font = [UIFont fontWithName:fontName size:18];
    
    [self.titleLabel setFont:font];
    
    CGSize titleStringSize = [self.titleLabel.text sizeWithAttributes: @{NSFontAttributeName: font}];
    
    CGFloat titleMaxWidth = self.width * 0.75;
    
    CGFloat titleWidth;
    
    if (titleStringSize.width > titleMaxWidth) {
        titleWidth = titleMaxWidth;
    } else {
        titleWidth = titleStringSize.width;
    }
    
    CGFloat height;
    
    if (menuItem.isHeader.boolValue) {
        height = 30;
    } else {
        height = 40;
    }
    
    self.titleLabel.frame = CGRectMake(
                                self.width / 2 - titleWidth / 2,
                                0,
                                titleWidth,
                                height
                            );
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.dropDownImageView.right = self.titleLabel.left - 12;
}

- (void)setUpSectionHeader:(MenuItem *)menuItem {

    self.titleLabel.textColor = [UIColor whiteColor];
    
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

- (void)flipArrowOrientation:(MenuItem *)menuItem {
    if (menuItem.isExpanded.boolValue) {
        self.dropDownImageView.image = [UIImage imageNamed:@"upArrow"];
    } else {
        self.dropDownImageView.image = [UIImage imageNamed:@"dropDown"];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    for (UIView *subview in self.contentView.superview.subviews) {
        if ([NSStringFromClass(subview.class) hasSuffix:@"SeparatorView"]) {
            subview.hidden = NO;
        }
    }
}


@end
