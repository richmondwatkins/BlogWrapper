//
//  SideMenuViewController.m
//  DailyDoll
//
//  Created by Richmond on 2/4/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "SideMenuViewController.h"
#import "ViewController.h"
#import "UIColor+UIColor_Expanded.h"
#import <MMDrawerController.h>
#import "MenuTableViewCell.h"

@interface SideMenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property NSArray *dataSource;
@property UITableView *tableView;
@property UIImageView *headerImageView;
@end

@implementation SideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpHeaderView];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.headerImageView.frame.origin.y + self.headerImageView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f4f7fc"];
    [self.view addSubview:self.tableView];

    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"MenuItems" ofType:@"plist"]];

    self.dataSource = [dictionary objectForKey:@"MenuItems"];

    [self.tableView reloadData];
}

- (void)setUpHeaderView {

    self.headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    self.headerImageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.headerImageView.frame.size.width);
    [self.view addSubview:self.headerImageView];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataSource.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    if (!cell) {
        cell = [[MenuTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"cell"];
    }

    NSDictionary *menuItem = self.dataSource[indexPath.row];

    cell.textLabel.text = [menuItem objectForKey:@"Title"];
    cell.backgroundColor = [UIColor colorWithHexString:@"f4f7fc"];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [self.delegate selectedSideMenuItem:self.dataSource[indexPath.row]];

    MMDrawerController *drawController = (MMDrawerController *)[[UIApplication sharedApplication] keyWindow].rootViewController;

    [drawController closeDrawerAnimated:YES completion:nil];

}

@end
