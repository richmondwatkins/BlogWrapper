//
//  SideMenuTableView.m
//  DailyDoll
//
//  Created by Richmond on 2/6/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "SideMenuTableView.h"
#import "APIManager.h"

@implementation SideMenuTableView


-(void)removeInsetsAndStyle {

    self.backgroundColor = [UIColor colorWithHexString:[[APIManager sharedManager] fetchThemeItem:SIDEMENUTABLEVIEW withProperty:kBackgroundColor]];
    self.showsVerticalScrollIndicator = NO;

    CGFloat bottomInset = 40;
    self.contentInset = UIEdgeInsetsMake(0, 0 , bottomInset, 0);
    
    self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];


}


- (UIEdgeInsets)layoutMargins
{
    return UIEdgeInsetsZero;
}
@end
