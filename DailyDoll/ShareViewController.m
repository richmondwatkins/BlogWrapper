//
//  ShareViewController.m
//  DailyDoll
//
//  Created by Richmond on 2/7/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "ShareViewController.h"
#import "ShareView.h"
#import "ShareTableView.h"
#import "ShareTableViewCell.h"
#import "ProjectSettings.h"

@interface ShareViewController () <UITableViewDataSource, UITableViewDelegate>

@property ShareTableView *tableView;
@property NSArray *dataSource;

@end

@implementation ShareViewController {
    SocialShare theSocialShareOption;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    ShareView *shareView = [[ShareView alloc] initWithStyleAndFrame:CGRectMake(0, 20, [self returnWidthForShareVC], self.view.frame.size.height)];

    self.tableView = [[ShareTableView alloc] initWithStyleAndFrame:shareView.frame];

    [shareView addSubview:self.tableView];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    self.view = shareView;

    self.dataSource = [[ProjectSettings sharedManager] shareItems];

    [self.tableView reloadData];
}


#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

//    return self.tableView.customDataSource.count;

    return 4;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    ShareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shareCell"];

    if (!cell) {
        cell = [[ShareTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"shareCell"];
    }

    [cell addShareButtonAndAdjustFrame:self.view.frame
                        withCellObject:self.dataSource[indexPath.row]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    switch (indexPath.row) {
        case 0:
            theSocialShareOption = FACEBOOK;
            break;
        case 1:
            theSocialShareOption = PINTREST;
            break;
        case 2:
            theSocialShareOption = TWITTER;
            break;
        case 3:
            theSocialShareOption = INSTAGRAM;
            break;
        case 4:
            theSocialShareOption = GOOGLEPLUS;
            break;

        default:
            break;
    }

    [self handleSocialAction];
}


- (void)handleSocialAction {

    switch (theSocialShareOption) {
        case FACEBOOK:

            break;

        case PINTREST:

            break;
        case TWITTER:

            break;
        case INSTAGRAM:

            break;
        case GOOGLEPLUS:

            break;

        default:
            break;
    }
}

- (int)returnWidthForShareVC {

    return [[UIScreen mainScreen] bounds].size.width * 0.15;
}

@end
