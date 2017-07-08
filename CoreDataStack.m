//
//  CoreDataStack.m
//  ShowFlicrImage
//
//  Created by Jullia Sharaeva on 03.07.17.
//  Copyright © 2017 Julia Sharaeva. All rights reserved.
//

#import "CoreDataStack.h"
static NSString *const SPFCoreDataSQLFileName = @"SPFModel";
static NSString *const SPFCoreDataModelFileName = @"SPFModel";


@interface CoreDataStack()
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSManagedObjectContext *mainObjectContext;
@property (strong, nonatomic) NSManagedObjectContext *privateObjectContext;
@property (strong, nonatomic) NSPersistentStoreCoordinator *mainCoordinator;
@property (strong, nonatomic) NSPersistentStoreCoordinator *backgroundCoordinator;

@end
@implementation CoreDataStack{
    NSURL *_storeURL;
}
- (instancetype) initStack{
    self = [super init];
    if (self){
        _storeURL = [self storeURL];
        if (!(nil == self.mainCoordinator)){
            _mainObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
            [_mainObjectContext setPersistentStoreCoordinator:self.mainCoordinator];
        }
        
        if (!(nil == self.backgroundCoordinator)){
            _privateObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
            [_privateObjectContext setPersistentStoreCoordinator:self.backgroundCoordinator];
        }
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSaveNotification:) name:NSManagedObjectContextDidSaveNotification object:_privateObjectContext];
    }
    
    return self;
}

- (NSURL *)storeURL{
    NSString *storeFileName = [NSString stringWithFormat:@"%@.sqlite", SPFCoreDataSQLFileName];
    return [[self applicationDocumentsDirectory] URLByAppendingPathComponent:storeFileName];
}

- (NSURL *)applicationDocumentsDirectory{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *applicationDocumentsDirectory = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].lastObject;
    
    if (![fileManager fileExistsAtPath:applicationDocumentsDirectory.path]){
        [fileManager createDirectoryAtPath:applicationDocumentsDirectory.path withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    return applicationDocumentsDirectory;
}

- (NSManagedObjectModel *)managedObjectModel{
    if (!_managedObjectModel){
        NSURL *modeURl = [[NSBundle mainBundle] URLForResource:SPFCoreDataModelFileName withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modeURl];
    }
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)mainCoordinator{
    if (!_mainCoordinator){
        NSError *error = nil;
        _mainCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        if (![_mainCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                            configuration:nil
                                                      URL:_storeURL
                                                  options:nil
                                                    error:&error]){
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            return nil;
        }
    }
    return _mainCoordinator;
}

- (NSPersistentStoreCoordinator *)backgroundCoordinator{
    if (!_backgroundCoordinator){
        NSError *error = nil;
        _backgroundCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        if (![_mainCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                            configuration:nil
                                                      URL:_storeURL
                                                  options:nil
                                                    error:&error]){
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            return nil;
        }
    }
    return _mainCoordinator;
}

- (void) didSaveNotification:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        for (NSManagedObject *object in [[notification userInfo] objectForKey:NSUpdatedObjectsKey]){
            [[_mainObjectContext objectWithID:[object objectID]] willAccessValueForKey:nil];
        }
        [_mainObjectContext mergeChangesFromContextDidSaveNotification:notification];
    });
}
@end
