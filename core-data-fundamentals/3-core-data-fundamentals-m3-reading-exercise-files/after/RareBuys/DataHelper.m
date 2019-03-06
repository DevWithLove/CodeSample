//
//  DataHelper.m
//  RareBuys
//
//  Created by Brice Wilson on 10/19/13.
//  Copyright (c) 2013 Brice Wilson. All rights reserved.
//

#import "DataHelper.h"

@implementation DataHelper

+ (void)createSampleData {
    
    DataStore *dataStore = [DataStore sharedDataStore];
    NSManagedObjectContext *context = [dataStore context];
    
    // Categories
    NSManagedObject *category1;
    category1 = [NSEntityDescription insertNewObjectForEntityForName:@"ItemCategory"
                                              inManagedObjectContext:context];
    
    [category1 setValue:@"Home Repair" forKey:@"categoryName"];
    [category1 setValue:@"Stuff I need to replace around the house." forKey:@"categoryDesc"];
    
    
    NSManagedObject *category2;
    category2 = [NSEntityDescription insertNewObjectForEntityForName:@"ItemCategory"
                                              inManagedObjectContext:context];
    
    [category2 setValue:@"Automobiles" forKey:@"categoryName"];
    [category2 setValue:@"Parts and stuff for my cars." forKey:@"categoryDesc"];
    
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
    
    for (NSManagedObject *cat in allCategories) {
        NSLog(@"Category Name:  %@ (%@)",
              [cat valueForKey:@"categoryName"],
              [cat valueForKey:@"categoryDesc"]);
    }
}

@end
