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

@end
