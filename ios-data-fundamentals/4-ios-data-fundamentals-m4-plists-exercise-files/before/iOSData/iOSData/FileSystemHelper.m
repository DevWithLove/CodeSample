//
//  FileSystemHelper.m
//  iOSData
//
//  Created by Wilson on 6/22/13.
//  Copyright (c) 2013 Brice Wilson. All rights reserved.
//

#import "FileSystemHelper.h"

@implementation FileSystemHelper

+(void)logSandboxDirectories {
    
    // get the app home directory path
    NSString *home = NSHomeDirectory();
    
    // use the default NSFileManager to get an array of all of the root directories
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *rootDirectories = [fm contentsOfDirectoryAtURL:[NSURL fileURLWithPath:home]
                                 includingPropertiesForKeys:nil
                                                    options:NSDirectoryEnumerationSkipsHiddenFiles
                                                      error:nil];
    
    // log the path of each root directory to the console
    for (NSURL *url in rootDirectories) {
        NSLog(@"Root Directory: %@", [url path]);
    }
}

+(void)logDocumentsDirectory {
    
    // use the default NSFileManager to get the path to the Documents directory
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *directories = [fm URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *docDirectory = [directories objectAtIndex:0]; // there will only ever be one Documents directory in iOS
    NSLog(@"Documents Directory: %@", [docDirectory path]); // log the path to the console
    
}

+(NSURL *)pathForDocumentsFile:(NSString *)filename {
    
    // create a URL-based path to the passed in filename located in the Documents directory
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *directories = [fm URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *documentPath = [directories objectAtIndex:0];
    
    return [documentPath URLByAppendingPathComponent:filename];
    
}


@end
