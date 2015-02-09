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

@interface SideMenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property NSArray *dataSource;
@property SideMenuTableView *tableView;
@property UIImageView *headerImageView;
@property CGRect cachedImageViewSize;
@property SideMenuTableHeaderView *headerView;
@property CGPoint imageViewCenter;

@end

@implementation SideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    self.tableView = [[SideMenuTableView alloc] initWithFrame:CGRectMake(0,
                                                                         self.headerImageView.frame.origin.y + self.headerImageView.frame.size.height + 20,
                                                                         [self returnWidthForMenuViewController] + 20,
                                                                         self.view.frame.size.height)
                                                        style:UITableViewStylePlain];

    [self.tableView removeInsetsAndStyle];

    [self setUpHeaderView];

    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;

    [self.view addSubview:self.tableView];

    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]
                                                                           pathForResource:@"MenuItems"
                                                                           ofType:@"plist"]];
    self.dataSource = [dictionary objectForKey:@"Menu"];

    [self.tableView reloadData];
}

-(void)viewDidLayoutSubviews {

    self.view.frame = CGRectMake(0,
                                 0,
                                 [self returnWidthForMenuViewController],
                                 self.view.frame.size.height);

    CGPoint headerCenter = CGPointMake(self.view.frame.size.width / 2,
                                       self.headerView.frame.size.height / 2);

    [self.headerImageView setCenter:headerCenter];

    self.imageViewCenter = headerCenter;

    self.cachedImageViewSize = self.headerImageView.frame;
}

- (void)setUpHeaderView {

    self.headerImageView = [[SideMenuHeaderImageView alloc] initWithParentFrame:self.view.frame
                                                                 andMenuVCWidth:[self returnWidthForMenuViewController] + 20];

    self.headerView = [[SideMenuTableHeaderView alloc] initWithFrame:self.view.frame
                                                           menuInset:[self returnWidthForMenuViewController]
                                                        andImageView:self.headerImageView.frame];

    [self.headerView addSubview:self.headerImageView];

    [self.headerImageView setCenter:CGPointMake(self.view.frame.size.width / 2, self.headerView.frame.size.height / 2)];


    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(displayHomePage:)];
    tapGesture.numberOfTapsRequired = 1;
    [self.headerView addGestureRecognizer:tapGesture];

    self.tableView.tableHeaderView = self.headerView;
}


#pragma mark - TableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSArray *menuItems = self.dataSource[section][1];

    return menuItems.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.dataSource.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    SideMenuTableSectionHeader *view = [[SideMenuTableSectionHeader alloc] initWithParentFrame:self.view.frame];

    SideMenuTableSectionLabel *label = [[SideMenuTableSectionLabel alloc] initWithHeight:view.frame.size.height
                                                                                andWidth:tableView.frame.size.width
                                                                                 andText:self.dataSource[section][0][0]];

    [view addSubview:label];

    return view;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    return self.dataSource[section][0][0];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    SideMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    if (!cell) {
        cell = [[SideMenuTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
                                            reuseIdentifier: @"cell"];
    }
    
    NSDictionary *menuItem = self.dataSource[indexPath.section][1][indexPath.row];

    [cell addTextToMenu: menuItem];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [self.delegate selectedSideMenuItem:self.dataSource[indexPath.section][1][indexPath.row]];

    MMDrawerController *drawController = (MMDrawerController *)[[UIApplication sharedApplication] keyWindow].rootViewController;

    [drawController closeDrawerAnimated:YES completion:nil];

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

//    // this formula is admittedly complicated - the objective is to return a float that is a round number when multiplied by the device screen scale ...
//    // ... includes separator height
//    static CGFloat separatorHeight = 1.0;
//    CGFloat defaultHeight = (ceilf((self.tableView.frame.size.height / (CGFloat)self.dataSource.count) * [UIScreen mainScreen].scale) - separatorHeight) / [UIScreen mainScreen].scale;
//
//    CGFloat rowHeight = defaultHeight;
//    self.tableView.estimatedRowHeight = rowHeight;
//
//    return rowHeight;
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
    }
}

- (void)displayHomePage:(id)sender {

    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]
                                                                           pathForResource:@"MenuItems"
                                                                           ofType:@"plist"]];
    
    [self.delegate selectedSideMenuItem:[dictionary objectForKey:@"Home"]];


    MMDrawerController *drawController = (MMDrawerController *)[[UIApplication sharedApplication] keyWindow].rootViewController;

    [drawController closeDrawerAnimated:YES completion:nil];
}

- (int)returnWidthForMenuViewController {

    return [[UIScreen mainScreen] bounds].size.width - [[UIScreen mainScreen] bounds].size.width * 0.2;
}

@end
