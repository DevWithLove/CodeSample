//
//  RetailStore.h
//  RareBuys
//
//  Created by Brice Wilson on 10/23/13.
//  Copyright (c) 2013 Brice Wilson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RareItem;

@interface RetailStore : NSManagedObject

@property (nonatomic, retain) NSString * storeDesc;
@property (nonatomic, retain) NSString * storeName;
@property (nonatomic, retain) NSSet *items;
@end

@interface RetailStore (CoreDataGeneratedAccessors)

- (void)addItemsObject:(RareItem *)value;
- (void)removeItemsObject:(RareItem *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

@end
