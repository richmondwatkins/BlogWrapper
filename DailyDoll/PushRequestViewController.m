//
//  PushRequestViewController.m
//  DailyDoll
//
//  Created by Richmond on 2/28/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "PushRequestViewController.h"
#import "APIManager.h"
#import "UIView+Additions.h"

@interface PushRequestViewController ()

@property UIScrollView *scrollView;

@property UILabel *descriptionLabel;

@property UIView *contorlSwitchContainer;

@property UISwitch *controlSwitch;

@end

@implementation PushRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    self.scrollView.scrollEnabled=YES;
    self.scrollView.userInteractionEnabled=YES;
    
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

    self.descriptionLabel.text = [NSString stringWithFormat:@"The %@ would like to notify you when new content is available",[[APIManager sharedManager] fetchmetaDataVariables:kBlogName]];

    NSString *fontName = [[APIManager sharedManager] fetchMetaThemeItemWithProperty:kFontFamily];

    [self.descriptionLabel setFont:[UIFont fontWithName:fontName size:18]];

    [self.descriptionLabel sizeToFit];

    [self.scrollView addSubview:self.descriptionLabel];

    [self.descriptionLabel setCenter:CGPointMake(self.view.width/2, self.logoImageView.bottom + 40)];
}

- (void)setUpImageView {

    self.logoImageView = [[UIImageView alloc] initWithImage:[[APIManager sharedManager] fetchLogoImage]];

    self.logoImageView.frame = CGRectMake(0, 0, self.logoImageView.width/2, self.logoImageView.height/2);

    [self.scrollView addSubview:self.logoImageView];

    //20 is the height of the status bar
    [self.logoImageView setCenter:CGPointMake(self.view.frame.size.width/2, self.logoImageView.frame.size.height/2 + 20)];
}

- (void)setUpControlSwitch {

    CGFloat viewHeight = 30;

    self.contorlSwitchContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width * 0.8, viewHeight)];
    [self.contorlSwitchContainer setCenter:CGPointMake(self.view.frame.size.width / 2, self.descriptionLabel.bottom + 40)];

    self.controlSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(self.contorlSwitchContainer.width-60, 0, viewHeight, viewHeight)];

    [self.controlSwitch setOn:NO];

    [self.contorlSwitchContainer addSubview:self.controlSwitch];

    UILabel *permissionLabel = [[UILabel alloc] init];

    permissionLabel.text = @"Receive notifications";

    [permissionLabel sizeToFit];

    permissionLabel.frame = CGRectMake(0, 0, permissionLabel.width, viewHeight);

    NSString *fontName = [[APIManager sharedManager] fetchMetaThemeItemWithProperty:kFontFamily];

    [permissionLabel setFont:[UIFont fontWithName:fontName size:16]];

    [self.contorlSwitchContainer addSubview:permissionLabel];

    [self.scrollView addSubview:self.contorlSwitchContainer];
}

- (void)setUpContinueButton {
    
    CGFloat continueWidth = (CGFloat) self.view.frame.size.width * 0.8;
    CGFloat continueHeight = 40;
    CGFloat bottomPadding = 30;
    
    UIButton *continueButton = [[UIButton alloc] initWithFrame:
                                CGRectMake(self.view.width / 2 - continueWidth / 2,
                                           self.view.height - continueHeight - bottomPadding,
                                           continueWidth,
                                           continueHeight)];

    continueButton.backgroundColor = [UIColor colorWithHexString:[[APIManager sharedManager] fetchMetaThemeItemWithProperty:kPrimaryColor]];

    NSString *buttonText = [NSString stringWithFormat:@"Continue on to the %@",
                            [[APIManager sharedManager] fetchmetaDataVariables:kBlogName]];

    continueButton.layer.cornerRadius = 5;

    continueButton.titleLabel.font = [UIFont systemFontOfSize:14.0];

    [continueButton setTitle:buttonText forState:UIControlStateNormal];

    [self boldFontForLabel:continueButton.titleLabel];

    [self.scrollView addSubview:continueButton];
    
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

    if ([self.controlSwitch isOn]) {
        [self askForPushPermission];
    }

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
