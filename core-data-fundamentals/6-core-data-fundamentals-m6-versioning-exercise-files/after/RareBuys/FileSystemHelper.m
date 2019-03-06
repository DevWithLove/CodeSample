//
//  FileSystemHelper.m
//
//  Created by Wilson on 6/22/13.
//  Copyright (c) 2013 Brice Wilson. All rights reserved.
//

#import "FileSystemHelper.h"

@implementation FileSystemHelper

+(NSURL *)pathForDocumentsFile:(NSString *)filename {
    
    // create a URL-based path to the passed in filename located in the Documents directory
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *directories = [fm URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *documentPath = [directories objectAtIndex:0];
    
    return [documentPath URLByAppendingPathComponent:filename];
    
}

@end
