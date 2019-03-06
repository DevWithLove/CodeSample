//
//  DataStore.m
//  RareBuys
//
//  Created by Brice Wilson on 10/15/13.
//  Copyright (c) 2013 Brice Wilson. All rights reserved.
//

#import "DataStore.h"
#import "FileSystemHelper.h"

@implementation DataStore

+(id)sharedDataStore {
    
    static DataStore *sharedDataStore = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedDataStore = [[self alloc] init];
    });
    
    return sharedDataStore;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        model = [NSManagedObjectModel mergedModelFromBundles:nil];
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        
        // create a URL-based path to the passed in filename located in the Documents directory
        NSURL *dataStoreURL = [FileSystemHelper pathForDocumentsFile:@"rarebuys.sqlite"];
        
        // start with a clean slate each time the app starts
        //[[NSFileManager defaultManager] removeItemAtURL:dataStoreURL error:nil];
        
        NSMutableDictionary *pscOptions = [NSMutableDictionary dictionary];
        
        [pscOptions setValue:[NSNumber numberWithBool:YES]
                      forKey:NSMigratePersistentStoresAutomaticallyOption];
        [pscOptions setValue:[NSNumber numberWithBool:YES]
                      forKey:NSInferMappingModelAutomaticallyOption];
        
        NSError *error = nil;
        [psc addPersistentStoreWithType:NSSQLiteStoreType
                          configuration:nil
                                    URL:dataStoreURL
                                options:pscOptions
                                  error:&error];

        
//        NSError *error = nil;
//        if (![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:dataStoreURL options:pscOptions error:&error]) {
//            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//            abort();
//        }
        
        // Create the managed object context
        _context = [[NSManagedObjectContext alloc] init];
        [_context setPersistentStoreCoordinator:psc];
    }
    return self;
}

- (BOOL)saveChanges {
    
    NSError *error = nil;
    BOOL saveSuccessful = [_context save:&error];
    if (!saveSuccessful) {
        NSLog(@"An error occurred while saving data. Error: %@", [error localizedDescription]);
    }
    return saveSuccessful;
}

@end
