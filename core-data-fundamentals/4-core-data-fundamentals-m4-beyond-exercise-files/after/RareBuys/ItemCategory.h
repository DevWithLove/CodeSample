//
//  ItemCategory.h
//  RareBuys
//
//  Created by Brice Wilson on 10/23/13.
//  Copyright (c) 2013 Brice Wilson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ItemCategory : NSManagedObject

@property (nonatomic, retain) NSString * categoryDesc;
@property (nonatomic, retain) NSString * categoryName;
@property (nonatomic, retain) NSSet *items;
@end

@interface ItemCategory (CoreDataGeneratedAccessors)

- (void)addItemsObject:(NSManagedObject *)value;
- (void)removeItemsObject:(NSManagedObject *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

@end
