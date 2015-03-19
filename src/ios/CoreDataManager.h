//
//  CoreDataManager.h
//  Push_notification
//
//  Created by Debanjan on 11/03/15.
//  Copyright (c) 2015 Debanjan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreData/CoreData.h"
#import <UIKit/UIKit.h>
@interface CoreDataManager : UIView

@property(nonatomic,strong)NSString *isSaved;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(readonly,strong,nonatomic)NSManagedObjectContext *childObjectContext;
- (void)saveContext:(NSString *)pushMessage;
-(NSArray *)fetchPushMessage;
+(CoreDataManager*)sharedInstance;
@end