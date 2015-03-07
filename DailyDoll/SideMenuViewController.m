//
//  SideMenuViewController.m
//  DailyDoll
//
//  Created by Richmond on 2/4/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "SideMenuViewController.h"
#import "CenterViewController.h"
#import <MMDrawerController.h>
#import "SideMenuTableViewCell.h"
#import "SideMenuTableView.h"
#import "SideMenuTableHeaderView.h"
#import "SideMenuHeaderImageView.h"
#import "SideMenuTableSectionHeader.h"
#import "SideMenuTableSectionLabel.h"
#import "ProjectSettings.h"
#import "AccessoryPagesView.h"
#import "NotificationViewController.h"

#import "UIView+Additions.h"

@interface SideMenuViewController () <UITableViewDataSource, UITableViewDelegate, AccessoryPageProtocol>

@property NSArray *dataSource;
@property SideMenuTableView *tableView;
@property UIImageView *headerImageView;
@property CGRect cachedImageViewSize;
@property SideMenuTableHeaderView *headerView;
@property CGPoint imageViewCenter;
@property UIButton *aboutButton;
@property AccessoryPagesView *accessoryPageView;
@property UIButton *notificationButton;

@end

int const kTopButtonPadding = 4;

@implementation SideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView = [[SideMenuTableView alloc] initWithFrame:CGRectMake(0,
                                                                         self.headerImageView.frame.origin.y + self.headerImageView.frame.size.height + 20,
                                                                         [self returnWidthForMenuViewController],
                                                                         self.view.frame.size.height)
                                                        style:UITableViewStylePlain];

    [self.tableView removeInsetsAndStyle];

    [self setUpHeaderView];

    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;

    [self.view addSubview:self.tableView];

    self.dataSource = [[ProjectSettings sharedManager] fetchMenuItemsAndHeaders];

    [self.tableView reloadData];
}

-(void)viewDidLayoutSubviews {

    CGPoint headerCenter = CGPointMake(self.tableView.frame.size.width / 2,
                                       self.headerView.frame.size.height / 2);

    [self.headerImageView setCenter:headerCenter];

    self.imageViewCenter = headerCenter;

    self.cachedImageViewSize = self.headerImageView.frame;
}

- (void)setUpHeaderView {

    int viewControllerWidth = [self returnWidthForMenuViewController];

    self.headerImageView = [[SideMenuHeaderImageView alloc] initWithParentFrame:self.view.frame
                                                                 andMenuVCWidth:viewControllerWidth + 20];

    self.headerView = [[SideMenuTableHeaderView alloc] initWithFrame:self.view.frame
                                                           menuInset:viewControllerWidth
                                                        andImageView:self.headerImageView.frame];

    [self.headerView addSubview:self.headerImageView];

    [self.headerImageView setCenter:CGPointMake(self.view.frame.size.width / 2, self.headerView.frame.size.height / 2)];


    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(displayHomePage:)];
    tapGesture.numberOfTapsRequired = 1;
    [self.headerView addGestureRecognizer:tapGesture];

    self.tableView.tableHeaderView = self.headerView;

    CGSize accessoryButtonSize = CGSizeMake(30, 30);

    self.aboutButton = [[UIButton alloc] initWithFrame:CGRectMake(kTopButtonPadding,
                                                                  kTopButtonPadding,
                                                                  accessoryButtonSize.width,
                                                                  accessoryButtonSize.height)];

    [self.aboutButton setImage:[UIImage imageNamed:@"about"]
                      forState:UIControlStateNormal];

    [self.aboutButton addTarget:self action:@selector(displayAboutPagePopOut)
               forControlEvents:UIControlEventTouchUpInside];

    [self.headerView addSubview:self.aboutButton];


    int notifButtonPadding = 4;
    self.notificationButton = [[UIButton alloc] initWithFrame:CGRectMake((viewControllerWidth - accessoryButtonSize.width) - notifButtonPadding,
                                                                         kTopButtonPadding,
                                                                         accessoryButtonSize.width,
                                                                         accessoryButtonSize.height)];

    [self.notificationButton setImage:[UIImage imageNamed:@"notification"]
                             forState:UIControlStateNormal];

    [self.notificationButton addTarget:self action:@selector(displayNotifications:)
                      forControlEvents:UIControlEventTouchUpInside];

    [self.headerView addSubview:self.notificationButton];

}

- (void)displayAboutPagePopOut {

    self.accessoryPageView = [[AccessoryPagesView alloc] initWithFrameAndButtons:self.view.frame];

    self.accessoryPageView.delegate = self;

    [self.view addSubview:self.accessoryPageView];

    [self.accessoryPageView animateOnToScreen:self.view.frame];
}

- (void)displayNotifications:(UIButton *)sender {

    CGFloat popUpWidth = self.view.width * 0.8;

    NotificationViewController *notifVC = [[NotificationViewController alloc] initWithStyleAndFrame:CGRectMake(sender.center.x - popUpWidth, sender.height + kTopButtonPadding, self.view.width * 0.8, 200) andParentWidth:self.view.width];

    [self addChildViewController:notifVC];
    [self.view addSubview:notifVC.view];

    [notifVC didMoveToParentViewController:self];
}


#pragma mark - TableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSArray *menuItems = [self.dataSource[section] valueForKey:@"menuItems"];

    return menuItems.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.dataSource.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    SideMenuTableSectionHeader *view = [[SideMenuTableSectionHeader alloc] initWithParentFrame:self.view.frame andMenuItem:self.dataSource[section]];

    return view;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    return [self.dataSource[section] valueForKey:@"title"];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    SideMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    if (!cell) {
        cell = [[SideMenuTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
                                            reuseIdentifier: @"cell"];
    }

    MenuItem *menuItem = [[self.dataSource[indexPath.section] valueForKey:@"menuItems"] allObjects][indexPath.row];
    
    [cell addTextToMenu: menuItem];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    MenuItem *menuItem = [[self.dataSource[indexPath.section] valueForKey:@"menuItems"] allObjects][indexPath.row];

    [self.delegate selectedSideMenuItem:menuItem.urlString];

    [self closeDrawController];

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return (self.tableView.frame.size.height / 4) / self.dataSource.count;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    CGFloat y = -scrollView.contentOffset.y;
    
    if (y > 0) {

        self.headerImageView.frame = CGRectMake(0, self.cachedImageViewSize.origin.y,
                                                self.cachedImageViewSize.size.width+y,
                                                self.cachedImageViewSize.size.height+y);

        self.headerImageView.center = CGPointMake(self.imageViewCenter.x,
                                                  self.imageViewCenter.y - (y/2));

        [self.aboutButton holdPositionDuringScroll:-y withOriginalY:kTopButtonPadding];

        [self.notificationButton holdPositionDuringScroll:-y withOriginalY:kTopButtonPadding];
    }
}

- (void)displayHomePage:(id)sender {

    NSString *homeUrl = [[ProjectSettings sharedManager] fetchmetaDataVariables:kURLString];

    [self.delegate selectedSideMenuItem:homeUrl];

    [self closeDrawController];
}

- (void)showAccessoryPage:(NSString *)urlString {

    [self.delegate selectedSideMenuItem:urlString];

    [self closeDrawController];
}

- (int)returnWidthForMenuViewController {

    return [[UIScreen mainScreen] bounds].size.width - [[UIScreen mainScreen] bounds].size.width * 0.2;
}

- (void)closeDrawController {

    MMDrawerController *drawController = (MMDrawerController *)[[UIApplication sharedApplication] keyWindow].rootViewController;

    [drawController closeDrawerAnimated:YES completion:nil];
}

@end
