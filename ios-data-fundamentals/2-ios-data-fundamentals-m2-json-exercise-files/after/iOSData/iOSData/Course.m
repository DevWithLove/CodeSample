//
//  Course.m
//  iOSData
//
//  Created by Wilson on 6/2/13.
//  Copyright (c) 2013 Brice Wilson. All rights reserved.
//

#import "Course.h"

@implementation Course

- (NSString *)description {
    
	return [NSString stringWithFormat:@"%@\n%@\n%@", [self title], [self category], [self shortDesc]];
}

- (NSData *)convertToJSONData {
    
    // convert Course object to Foundation objects before attempting serialization
    NSMutableDictionary *newCourse = [[NSMutableDictionary alloc] init];
    [newCourse setObject:[self title] forKey:@"Title"];
    [newCourse setObject:[self category] forKey:@"Category"];
    [newCourse setObject:[self shortDesc] forKey:@"ShortDescription"];
	
	NSData *jsonData;
    
    // verify that object graph is serializable
    if ([NSJSONSerialization isValidJSONObject:newCourse]) {
		NSError* jsonError;
        // convert Foundation objects to an NSData object containing JSON
		jsonData = [NSJSONSerialization dataWithJSONObject:newCourse options:NSJSONWritingPrettyPrinted error:&jsonError];
	}
    
    return jsonData;
}


@end
