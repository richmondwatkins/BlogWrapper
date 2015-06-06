//
//  SideMenuTableSectionHeader.m
//  DailyDoll
//
//  Created by Richmond on 2/6/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "SideMenuTableSectionHeader.h"
#import "APIManager.h"
#import "SideMenuTableSectionLabel.h"

@implementation SideMenuTableSectionHeader

- (instancetype)initWithParentFrame:(CGRect)parentFrame andMenuItem:(MenuItem *)menuItem{

    if (self = [super init]) {
        
        self.frame = CGRectMake(0, 0, parentFrame.size.width, 20);

//        self.backgroundColor = [UIColor colorWithHexString:[[ProjectSettings sharedManager] fetchThemeItem:SIDEMENUSECTIONHEADER withProperty:kBackgroundColor]];

        switch ([menuItem.position intValue]) {
            case 0:
                self.backgroundColor = [UIColor colorWithHexString:@"7b7285"];
                break;
            case 1:
                self.backgroundColor = [UIColor colorWithHexString:@"00827c"];
                break;

            case 2:
                self.backgroundColor = [UIColor colorWithHexString:@"ed86cf"];
                break;

            case 3:
                self.backgroundColor = [UIColor colorWithHexString:@"dabb82"];
                break;
            default:
                break;
        }
        //beauty c392b0
        //wellness 22756b
        //life stuff b7a7cb
        SideMenuTableSectionLabel *label = [[SideMenuTableSectionLabel alloc] initWithParentFrame:parentFrame andText:menuItem.title];

        [self addSubview:label];
    }


    return self;
}


@end
