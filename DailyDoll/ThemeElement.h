//
//  ThemeElement.h
//  DailyDoll
//
//  Created by Richmond on 2/10/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ThemeElement : NSManagedObject

@property (nonatomic, retain) NSString * primaryColor;
@property (nonatomic, retain) NSString * secondaryColor;
@property (nonatomic, retain) NSManagedObject *shareTableView;
@property (nonatomic, retain) NSManagedObject *shareView;
@property (nonatomic, retain) NSManagedObject *activityIndicator;
@property (nonatomic, retain) NSManagedObject *navBar;
@property (nonatomic, retain) NSManagedObject *statusBar;
@property (nonatomic, retain) NSManagedObject *sideMenuHeader;
@property (nonatomic, retain) NSManagedObject *sideMenutableView;
@property (nonatomic, retain) NSManagedObject *sideMenuCell;
@property (nonatomic, retain) NSManagedObject *sideMenuSectionHeader;

@end
