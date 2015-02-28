//
//  PushRequestViewController.m
//  DailyDoll
//
//  Created by Richmond on 2/28/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "PushRequestViewController.h"
#import "ProjectSettings.h"
#import "UIView+Additions.h"

@interface PushRequestViewController ()

@property UIImageView *logoImageView;

@property UIScrollView *scrollView;

@property UILabel *descriptionLabel;

@property UIView *contorlSwitchContainer;

@end

@implementation PushRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    self.scrollView.scrollEnabled=YES;
    self.scrollView.userInteractionEnabled=YES;
    self.scrollView.contentSize = CGSizeMake(self.view.width, [[UIScreen mainScreen] bounds].size.height + 100);

    [self.view addSubview:self.scrollView];

    [self setUpImageView];

    [self setUpDescriptionLabel];

    [self setUpControlSwitch];

    [self setUpContinueButton];
}

- (void)setUpDescriptionLabel {

    self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.width * 0.8, 10)];

    self.descriptionLabel.numberOfLines = 0;

    self.descriptionLabel.textAlignment = NSTextAlignmentCenter;

    self.descriptionLabel.text = [NSString stringWithFormat:@"To alert you when new content is available, %@ would like to send you push notifications",[[ProjectSettings sharedManager] metaDataVariables:kBlogName]];

    NSString *fontName = [[ProjectSettings sharedManager] fetchMetaThemeItemWithProperty:kFontFamily];

    [self.descriptionLabel setFont:[UIFont fontWithName:fontName size:18]];

    [self.descriptionLabel sizeToFit];

    [self.scrollView addSubview:self.descriptionLabel];

    [self.descriptionLabel setCenter:CGPointMake(self.view.width/2, self.logoImageView.bottom + 40)];
}

- (void)setUpImageView {

    self.logoImageView = [[UIImageView alloc] initWithImage:[[ProjectSettings sharedManager] fetchLogoImage]];

    self.logoImageView.frame = CGRectMake(0, 0, self.logoImageView.width/2, self.logoImageView.height/2);

    [self.scrollView addSubview:self.logoImageView];

    //20 is the height of the status bar
    [self.logoImageView setCenter:CGPointMake(self.view.frame.size.width/2, self.logoImageView.frame.size.height/2 + 20)];
}

- (void)setUpControlSwitch {

    CGFloat viewHeight = 30;

    self.contorlSwitchContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width * 0.8, viewHeight)];
    [self.contorlSwitchContainer setCenter:CGPointMake(self.view.frame.size.width / 2, self.descriptionLabel.bottom + 40)];

    UISwitch *controlSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(self.contorlSwitchContainer.width-60, 0, viewHeight, viewHeight)];

    [controlSwitch addTarget:self action:@selector(askForPushPermission) forControlEvents:UIControlEventValueChanged];

    [self.contorlSwitchContainer addSubview:controlSwitch];

    UILabel *permissionLabel = [[UILabel alloc] init];

    permissionLabel.text = @"Receive pushes";

    [permissionLabel sizeToFit];

    permissionLabel.frame = CGRectMake(0, 0, permissionLabel.width, viewHeight);

    NSString *fontName = [[ProjectSettings sharedManager] fetchMetaThemeItemWithProperty:kFontFamily];

    [permissionLabel setFont:[UIFont fontWithName:fontName size:16]];

    [self.contorlSwitchContainer addSubview:permissionLabel];

    [self.scrollView addSubview:self.contorlSwitchContainer];
}

- (void)setUpContinueButton {

    UIButton *continueButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width * 0.8, 40)];

    continueButton.backgroundColor = [UIColor colorWithHexString:[[ProjectSettings sharedManager] fetchMetaThemeItemWithProperty:kPrimaryColor]];

    NSString *buttonText = [NSString stringWithFormat:@"Contine on to the %@",
                            [[ProjectSettings sharedManager] metaDataVariables:kBlogName]];

    continueButton.layer.cornerRadius = 5;

    continueButton.titleLabel.font = [UIFont systemFontOfSize:14.0];

    [continueButton setTitle:buttonText forState:UIControlStateNormal];

    [self boldFontForLabel:continueButton.titleLabel];

    [self.scrollView addSubview:continueButton];

    [continueButton setCenter:CGPointMake(self.view.frame.size.width / 2, self.contorlSwitchContainer.bottom + 40)];

    [continueButton addTarget:self action:@selector(dismissVC:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)askForPushPermission {

    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];

    [[UIApplication sharedApplication] registerForRemoteNotifications];
}


- (void)dismissVC:(id)sender {

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    [userDefaults setBool:YES forKey:kFirstStartUp];

    [userDefaults synchronize];

    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)boldFontForLabel:(UILabel *)label{
    UIFont *currentFont = label.font;
    UIFont *newFont = [UIFont fontWithName:[NSString stringWithFormat:@"%@-Bold",currentFont.fontName] size:currentFont.pointSize];
    label.font = newFont;
}

@end
