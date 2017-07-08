//
//  SPFCoreDataStack.h
//  ShowFlicrImage
//
//  Created by Jullia Sharaeva on 05.07.17.
//  Copyright © 2017 Julia Sharaeva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface SPFCoreDataStack: NSObject
@property (nonatomic, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@end
