//
//  Course.h
//  iOSData
//
//  Created by Wilson on 6/2/13.
//  Copyright (c) 2013 Brice Wilson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Course : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *shortDesc;

- (NSData *)convertToJSONData;

@end
