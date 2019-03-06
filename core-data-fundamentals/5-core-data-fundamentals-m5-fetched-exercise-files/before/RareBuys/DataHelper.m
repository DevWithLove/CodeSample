//
//  DataHelper.m
//  RareBuys
//
//  Created by Brice Wilson on 10/19/13.
//  Copyright (c) 2013 Brice Wilson. All rights reserved.
//

#import "DataHelper.h"
#import "ItemCategory.h"
#import "RetailStore.h"
#import "RareItem.h"

@implementation DataHelper

+ (void)createSampleData {
    
    DataStore *dataStore = [DataStore sharedDataStore];
    NSManagedObjectContext *context = [dataStore context];
    
    // Categories
    NSArray *catNames = @[@"Home Repair", @"Sporting Goods", @"Automobiles"];
    NSArray *catDescs = @[@"Stuff I need to replace around the house", @"Sports equipment", @"Parts and stuff for my cars"];
    
    NSMutableArray *categoryArray = [NSMutableArray array];
    [catNames enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ItemCategory *category = [NSEntityDescription insertNewObjectForEntityForName:@"ItemCategory"
                                                               inManagedObjectContext:context];
        [category setCategoryName:catNames[idx]];
        [category setCategoryDesc:catDescs[idx]];
        [categoryArray addObject:category];
    }];
    
    
    // Stores
    NSArray *storeNames = @[@"Joe's Home Repair", @"Smith Plumbing Supply", @"Mike's Sporting Goods", @"Jerseys and Stuff", @"Auto Care", @"Muffler Center"];
    NSArray *storeDescs = @[@"Lot's of stuff for the home.", @"Rare and hard to find supplies.", @"All the sports stuff you need.",
                            @"Lots of athletic gear", @"Every part imaginable", @"They have more than just mufflers"];
    
    NSMutableArray *storeArray = [NSMutableArray array];
    [storeNames enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        RetailStore *store = [NSEntityDescription insertNewObjectForEntityForName:@"RetailStore"
                                                           inManagedObjectContext:context];
        [store setStoreName:storeNames[idx]];
        [store setStoreDesc:storeDescs[idx]];
        [storeArray addObject:store];
    }];
    
    
    // Items
    NSArray *itemNames = @[@"Light Bulbs", @"Bicycle Tires", @"Air Filter", @"Garden Hose", @"Garden Seeds",
                           @"Baseball Glove", @"Baseballs", @"Air Pump", @"Wrenches", @"Kitchen Tile",
                           @"Television", @"Croquet Set", @"Upholstery Cleaner", @"Window Cleaner", @"Shoes"];
    NSArray *itemDescs = @[@"Non-starndard sizes", @"20-inch tubes", @"Honda Accord", @"50 ft.", @"Veggies",
                           @"Leather", @"Leather", @"Pump up the tires", @"Metric", @"Replacement tiles",
                           @"32-inch", @"Family games", @"clean the old car", @"cleaner", @"sports shoes"];
    
    NSMutableArray *itemArray = [NSMutableArray array];
    [itemNames enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        RareItem *item = [NSEntityDescription insertNewObjectForEntityForName:@"RareItem"
                                                       inManagedObjectContext:context];
        [item setItemName:itemNames[idx]];
        [item setItemDesc:itemDescs[idx]];
        [itemArray addObject:item];
    }];
    
    // add categories to items
    [itemArray[0] setCategory:categoryArray[0]];
    [itemArray[1] setCategory:categoryArray[1]];
    [itemArray[2] setCategory:categoryArray[1]];
    [itemArray[3] setCategory:categoryArray[0]];
    [itemArray[4] setCategory:categoryArray[0]];
    [itemArray[5] setCategory:categoryArray[1]];
    [itemArray[6] setCategory:categoryArray[1]];
    [itemArray[7] setCategory:categoryArray[1]];
    [itemArray[8] setCategory:categoryArray[2]];
    [itemArray[9] setCategory:categoryArray[0]];
    [itemArray[10] setCategory:categoryArray[0]];
    [itemArray[11] setCategory:categoryArray[1]];
    [itemArray[12] setCategory:categoryArray[2]];
    [itemArray[13] setCategory:categoryArray[2]];
    [itemArray[14] setCategory:categoryArray[1]];
    
    // add stores to items
    [itemArray[0] addStoresObject:storeArray[0]];
    [itemArray[0] addStoresObject:storeArray[1]];
    [itemArray[1] addStoresObject:storeArray[2]];
    [itemArray[1] addStoresObject:storeArray[3]];
    [itemArray[2] addStoresObject:storeArray[4]];
    [itemArray[3] addStoresObject:storeArray[1]];
    [itemArray[4] addStoresObject:storeArray[0]];
    [itemArray[5] addStoresObject:storeArray[3]];
    [itemArray[6] addStoresObject:storeArray[2]];
    [itemArray[7] addStoresObject:storeArray[4]];
    [itemArray[8] addStoresObject:storeArray[4]];
    [itemArray[9] addStoresObject:storeArray[1]];
    [itemArray[10] addStoresObject:storeArray[0]];
    [itemArray[11] addStoresObject:storeArray[3]];
    [itemArray[12] addStoresObject:storeArray[5]];
    [itemArray[13] addStoresObject:storeArray[5]];
    [itemArray[14] addStoresObject:storeArray[3]];
    
    [dataStore saveChanges];
}

+ (void)logAllCategories {
    
    DataStore *dataStore = [DataStore sharedDataStore];
    NSManagedObjectContext *context = [dataStore context];
    
    NSFetchRequest *req;
    req = [NSFetchRequest fetchRequestWithEntityName:@"ItemCategory"];
    
    NSError *error;
    NSArray *allCategories = [context executeFetchRequest:req error:&error];
    
    if (!allCategories) {
        NSLog(@"An error occurred. Error: %@", [error localizedDescription]);
    }
    
    NSLog(@"Logging Categories");
    
    for (ItemCategory *cat in allCategories) {
        NSLog(@"Category Name:  %@ (%@)",
              [cat categoryName],
              [cat categoryDesc]);
    }
}

+ (void)logAllItems {
    
    DataStore *dataStore = [DataStore sharedDataStore];
    NSManagedObjectContext *context = [dataStore context];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"RareItem"];
    
    NSSortDescriptor *primarySort = [NSSortDescriptor sortDescriptorWithKey:@"itemName"
                                                                  ascending:YES];
    
    NSSortDescriptor *secondarySort = [NSSortDescriptor sortDescriptorWithKey:@"itemDesc"
                                                                    ascending:NO];
    
    NSArray *sortArray = [NSArray arrayWithObjects:primarySort, secondarySort, nil];
    
    [request setSortDescriptors:sortArray];

    
    NSError *error;
    NSArray *allItems = [context executeFetchRequest:request error:&error];
    
    if (!allItems) {
        NSLog(@"Error occurred while fetching categories. Error: %@", [error localizedDescription]);
    }
    
    NSLog(@"Logging All Items");
    
    for (RareItem *item in allItems) {
        
        NSLog(@"Item:  %@", [item itemName]);
        
        ItemCategory *category = [item category];
        
        NSLog(@"\tCategory: %@", [category categoryName]);
        
        NSLog(@"\tStores:");
        
        NSSet *retailStores = [item stores];
        
        for (RetailStore *store in retailStores) {
            NSLog(@"\t\tStore Name:  %@", [store storeName]);
        }

        
    }
    
}

+ (void)addSuperStore {
    
    DataStore *dataStore = [DataStore sharedDataStore];
    NSManagedObjectContext *context = [dataStore context];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"RareItem"];
    
    NSError *error;
    NSArray *allItems = [context executeFetchRequest:request error:&error];
    
    if (!allItems) {
        NSLog(@"Error occurred while fetching categories. Error: %@", [error localizedDescription]);
    }
    
    RetailStore *store = [NSEntityDescription insertNewObjectForEntityForName:@"RetailStore"
                                                       inManagedObjectContext:context];
    [store setStoreName:@"Giant-Mart"];
    [store setStoreDesc:@"Sells every item ever made."];
    
    for (RareItem *item in allItems) {
        
        [item addStoresObject:store];
    }
    
    [dataStore saveChanges];
}

+ (void)logAllGardenItems {
    
    DataStore *dataStore = [DataStore sharedDataStore];
    NSManagedObjectContext *context = [dataStore context];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"RareItem"];
    
    NSString *searchString = @"Garden";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"itemName CONTAINS %@", searchString];
    
    [request setPredicate:pred];
    
    NSError *error;
    NSArray *allItems = [context executeFetchRequest:request error:&error];
    
    if (!allItems) {
        NSLog(@"Error occurred while fetching categories. Error: %@", [error localizedDescription]);
    }
    
    NSLog(@"Logging All Garden Items");
    
    for (RareItem *item in allItems) {
        NSLog(@"Garden Item:  %@", [item itemName]);
    }
}

+ (void)logAllCleaningItems {
    
    DataStore *dataStore = [DataStore sharedDataStore];
    NSManagedObjectContext *context = [dataStore context];
    
    NSPersistentStoreCoordinator *ps = [context persistentStoreCoordinator];
    
    NSManagedObjectModel *model = [ps managedObjectModel];
    
    NSFetchRequest *request = [model fetchRequestTemplateForName:@"allCleaningItems"];
    
    NSError *error;
    NSArray *allItems = [context executeFetchRequest:request error:&error];
    
    if (!allItems) {
        NSLog(@"Error occurred while fetching categories. Error: %@", [error localizedDescription]);
    }
    
    NSLog(@"Logging All Cleaning Items");
    
    for (RareItem *item in allItems) {
        NSLog(@"Cleaning Item:  %@", [item itemName]);
    }
}




@end
