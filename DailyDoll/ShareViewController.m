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
#import "SocialSharingActionController.h"
#import "SocialSharePopoverView.h"
//#import <FacebookSDK/FacebookSDK.h>

@import Social;

@interface ShareViewController () <UITableViewDataSource, UITableViewDelegate, SocialProtocol>

@property ShareTableView *tableView;
@property NSArray *dataSource;
@property SocialSharingActionController *actionController;
@property SocialSharePopoverView *socialPopUp;

@end

@implementation ShareViewController

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

    UIWindow* mainWindow = [[UIApplication sharedApplication] keyWindow];

    self.actionController = [[SocialSharingActionController alloc] init];
    self.actionController.delegate = self;

    switch ([self.dataSource[indexPath.row][@"socialId"] intValue]) {
        case 0:

           self.socialPopUp = [self.actionController facebookPopConfig:mainWindow.frame];
            break;
        case 1:
            [SocialSharingActionController handlePintrestShare];
            break;
        case 2:
            [SocialSharingActionController handleTwitterShare];
            break;
        case 3:
            [SocialSharingActionController handleInstagramShare];
            break;
        case 4:
            [SocialSharingActionController handleGooglePlusShare];
            break;

        default:
            break;
    }
    

    [mainWindow addSubview: self.socialPopUp];

    [self.socialPopUp animateOnToScreen];

    [self.socialPopUp.subviews[0] setCenter:CGPointMake(mainWindow.frame.size.width / 2, mainWindow.frame.size.height / 2)];
}

- (int)returnWidthForShareVC {

    return [[UIScreen mainScreen] bounds].size.width * 0.15;
}

- (void)facebookShare:(NSString *)shareContent{
    
    [self.socialPopUp animateOffScreen];

    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];

        [controller setInitialText:shareContent];
        [self presentViewController:controller animated:YES completion:Nil];
    }
}

-(void)facebookLike {



}



@end
