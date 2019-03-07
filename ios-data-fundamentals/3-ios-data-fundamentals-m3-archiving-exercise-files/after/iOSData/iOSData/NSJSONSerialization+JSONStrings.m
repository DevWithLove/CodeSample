//
//  NSJSONSerialization+JSONStrings.m
//  iOSData
//
//  Created by Wilson on 6/6/13.
//  Copyright (c) 2013 Brice Wilson. All rights reserved.
//

#import "NSJSONSerialization+JSONStrings.h"

@implementation NSJSONSerialization (JSONStrings)

+ (void)logJSONWithData:(NSData *)data label:(NSString *)dataLabel {
    
    NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@:  \n%@", dataLabel, jsonString);
    
}


@end
