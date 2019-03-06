//
//  RareItem.h
//  RareBuys
//
//  Created by Brice Wilson on 10/23/13.
//  Copyright (c) 2013 Brice Wilson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ItemCategory;

@interface RareItem : NSManagedObject

@property (nonatomic, retain) NSDecimalNumber * cost;
@property (nonatomic, retain) NSDate * createdDate;
@property (nonatomic, retain) NSString * itemDesc;
@property (nonatomic, retain) NSString * itemName;
@property (nonatomic, retain) NSDate * lastPurchased;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) ItemCategory *category;
@property (nonatomic, retain) NSSet *stores;
@property (nonatomic, retain) NSString *detailedName;
@end

@interface RareItem (CoreDataGeneratedAccessors)

- (void)addStoresObject:(NSManagedObject *)value;
- (void)removeStoresObject:(NSManagedObject *)value;
- (void)addStores:(NSSet *)values;
- (void)removeStores:(NSSet *)values;

@end
