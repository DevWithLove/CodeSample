//
//  Course.h
//  iOSData
//
//  Created by Wilson on 6/2/13.
//  Copyright (c) 2013 Brice Wilson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Course : NSObject <NSCoding>

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *shortDesc;

- (NSData *)convertToJSONData;

typedef NS_ENUM(int, CourseListSortOrder) {
    CourseListSortOrderByTitle = 0,
    CourseListSortOrderByCategory = 1
};



@end
