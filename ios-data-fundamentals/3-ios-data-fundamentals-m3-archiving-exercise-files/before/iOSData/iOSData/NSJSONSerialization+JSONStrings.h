//
//  NSJSONSerialization+JSONStrings.h
//  iOSData
//
//  Created by Wilson on 6/6/13.
//  Copyright (c) 2013 Brice Wilson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSJSONSerialization (JSONStrings)

+ (void)logJSONWithData:(NSData *)data label:(NSString *)dataLabel;

@end
