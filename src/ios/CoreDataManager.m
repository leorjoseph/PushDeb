//
//  CoreDataManager.m
//  Push_notification
//
//  Created by Debanjan on 11/03/15.
//  Copyright (c) 2015 Debanjan. All rights reserved.
//

#import "CoreDataManager.h"
#import "PushMessage.h"
@implementation CoreDataManager
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize childObjectContext= _childObjectContext;


+(CoreDataManager*)sharedInstance
{
    static CoreDataManager *dataManager;
    static dispatch_once_t once;
    dispatch_once(&once,^{
        if(!dataManager)
            dataManager=[[CoreDataManager alloc]init];
    });
    return dataManager;
    }

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"PushMessage" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSString *storePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"PushMessageDb.sqlite"];
    NSURL *storeURL= [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"PushMessageDb.sqlite"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:storePath]) {
        NSString *defaultStorePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"PushMessageDb.sqlite"];
        if (defaultStorePath) {
            [fileManager copyItemAtPath:defaultStorePath toPath:storePath error:NULL];
        }
    }

    NSError *error = nil;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];

    /*_persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];

    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"persistentStoreCoordinator" message:[NSString stringWithFormat:@"%@",[error userInfo]] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }*/
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    NSLog(@"%@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]);
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)saveContext:(NSString *)pushMessage
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        NSManagedObject *newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"PushMessage" inManagedObjectContext:managedObjectContext];
        
        [newDevice setValue:pushMessage forKey:@"message"];
    }
}
-(NSArray *)fetchPushMessage
{
    NSError *error;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    NSFetchRequest* request=[[NSFetchRequest alloc]init];
    NSEntityDescription *description=[NSEntityDescription entityForName:@"PushMessage" inManagedObjectContext:managedObjectContext];
    [request setEntity:description];
    [request setReturnsObjectsAsFaults:NO];
    
   NSArray *messageArray = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    NSLog(@"eventArray is %@\n",messageArray);
    return messageArray;
}

@end
