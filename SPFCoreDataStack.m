//
//  SPFCoreDataStack.m
//  ShowFlicrImage
//
//  Created by Jullia Sharaeva on 05.07.17.
//  Copyright © 2017 Julia Sharaeva. All rights reserved.
//

#import "SPFCoreDataStack.h"

static NSString *const SPFCoreDataSQLFileName = @"SPFModel";
static NSString *const SPFCoreDataModelFileName = @"Model";

@interface SPFCoreDataStack()
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end

@implementation SPFCoreDataStack


- (NSString *) applicationDocumentsDirectory{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (NSManagedObjectModel *) managedObjectModel{
    if (!_managedObjectModel){
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:SPFCoreDataModelFileName withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator{
    if (!_persistentStoreCoordinator){
        NSString *pathName = [[NSString alloc] initWithFormat:@"%@.sqlite", SPFCoreDataSQLFileName];
        NSString *storePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:pathName];
        NSURL *storeUrl = [NSURL fileURLWithPath:storePath];
        NSError *error;
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:@{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}  error:&error]){
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
    }
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext{
    if (!_managedObjectContext){
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    }
    return _managedObjectContext;
}
@end
