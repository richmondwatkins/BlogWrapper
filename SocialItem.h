//
//  SocialItem.h
//  DailyDoll
//
//  Created by Richmond on 2/11/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Button, SocialContainer;

@interface SocialItem : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * pageId;
@property (nonatomic, retain) NSString * appId;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * urlString;
@property (nonatomic, retain) NSString * authURL;
@property (nonatomic, retain) NSString * authBaseURL;
@property (nonatomic, retain) NSString * authRedirect;
@property (nonatomic, retain) NSString * authClientId;
@property (nonatomic, retain) NSString * accountName;
@property (nonatomic, retain) NSNumber * hasInteracted;
@property (nonatomic, retain) SocialContainer *socialContainer;
@property (nonatomic, retain) NSSet *buttons;
@end

@interface SocialItem (CoreDataGeneratedAccessors)

- (void)addButtonsObject:(Button *)value;
- (void)removeButtonsObject:(Button *)value;
- (void)addButtons:(NSSet *)values;
- (void)removeButtons:(NSSet *)values;

@end
