//
//  ItemCategory.m
//  RareBuys
//
//  Created by Brice Wilson on 10/23/13.
//  Copyright (c) 2013 Brice Wilson. All rights reserved.
//

#import "ItemCategory.h"


@implementation ItemCategory

@dynamic categoryDesc;
@dynamic name;
@dynamic items;

- (void)awakeFromInsert {
    
    [self setCategoryDesc:@"No description provided."];
}

@end
