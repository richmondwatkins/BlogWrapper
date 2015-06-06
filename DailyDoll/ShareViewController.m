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
#import "APIManager.h"
#import "SocialSharingActionController.h"
#import "SocialSharePopoverView.h"
#import "ExternalWebModalViewController.h"
#import "OAuthSignInView.h"
#import <TwitterKit/TwitterKit.h>
#import "OAuthWebView.h"
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>

#import "UIView+Additions.h"

@import Social;
@class GPPSignInButton;

@interface ShareViewController () <UITableViewDataSource, UITableViewDelegate, SocialProtocol>

@property ShareTableView *tableView;
@property NSArray *dataSource;

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setTop:20];

    self.tableView = [[ShareTableView alloc] initWithStyleAndFrame:self.view.frame];

    [self.view addSubview:self.tableView];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self reloadTableView];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadTableView)
                                                 name:@"coreDataUpdated" object:nil];
}

- (void) reloadTableView {
    self.dataSource = [[APIManager sharedManager] fetchShareItems];
    
    [self.tableView reloadData];
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataSource.count;
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

    if (!self.actionController) {
        self.actionController = [[SocialSharingActionController alloc] init];
    }

    self.actionController.delegate = self;

    switch ([[self.dataSource[indexPath.row] valueForKey:kPlatformId] intValue]) {
            
        case FACEBOOK:

           self.socialPopUp = [self.actionController facebookPopConfig:mainWindow.frame];

            [self displaySocialPoUp];

            break;
        case PINTEREST:

            self.socialPopUp = [self.actionController pintrestPopConfig:mainWindow.frame];

            [self displaySocialPoUp];

            break;
        case TWIITER:

            self.socialPopUp = [self.actionController twitterPopConfig:mainWindow.frame];

            [self displaySocialPoUp];

            break;
        case INSTAGRAM:
            
            self.socialPopUp = [self.actionController instagramPopConfig:mainWindow.frame];

            [self displaySocialPoUp];

            break;
        case GOOGLEPLUS:
            
            self.socialPopUp = [self.actionController googlePlusPopConfig:mainWindow.frame];

            [self displaySocialPoUp];

            break;

        case EMAIL: {

            NSString *blogName = [[APIManager sharedManager] fetchmetaDataVariables:kBlogName];
            NSString *blogUrl = [[APIManager sharedManager] fetchmetaDataVariables:kURLString];

            [[SocialShareMethods sharedManager] shareViaEmail: @{@"message": blogUrl, @"subject": blogName}];

        }
            break;

        case SMS: {

            NSString *blogName = [[APIManager sharedManager] fetchmetaDataVariables:kBlogName];
            NSString *blogUrl = [[APIManager sharedManager] fetchmetaDataVariables:kURLString];

            [[SocialShareMethods sharedManager] shareViaSMS: @{@"message": blogUrl, @"subject": blogName}];

        }
            break;

        default:
            break;
    }
}

- (int)returnWidthForShareVC {

    return [[UIScreen mainScreen] bounds].size.width * 0.15;
}


-(void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {

    if (self.view.frame.size.height > self.view.frame.size.width) {
        //view is in portrait about to transtion to landscape
        if (self.socialPopUp) {
            [self.socialPopUp animateOffScreen];
        }
    }
}


@end