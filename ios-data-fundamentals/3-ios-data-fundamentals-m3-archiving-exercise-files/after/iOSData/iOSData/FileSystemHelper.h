//
//  FileSystemHelper.h
//  iOSData
//
//  Created by Wilson on 6/22/13.
//  Copyright (c) 2013 Brice Wilson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileSystemHelper : NSObject

+(void)logSandboxDirectories; // just for demo purposes
+(void)logDocumentsDirectory; // just for demo purposes
+(NSURL *)pathForDocumentsFile:(NSString *)filename;

@end
