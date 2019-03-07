//
//  Course.m
//  iOSData
//
//  Created by Brice Wilson on 5/13/13.
//  Copyright (c) 2013 Brice Wilson. All rights reserved.
//

#import "Course.h"

@implementation Course

- (NSString *)description {
	return [NSString stringWithFormat:@"%@\n%@\n%@\n", [self title], [self category], [self shortDesc]];
}

@end
