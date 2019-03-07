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

+(NSMutableDictionary *)appStatsPlist {
    
    // get the app_stats.data file and create a dictionary to store the data
    NSError *error;
    NSURL *appStatsPath = [FileSystemHelper pathForDocumentsFile:@"app_stats.data"];
    NSMutableDictionary *appStats = [[NSMutableDictionary alloc] init];
    
    NSData *appStatsData = [NSData dataWithContentsOfURL:appStatsPath];
    
    // if the file does not already exist
    if (!appStatsData) {
        
        // add default values to the new plist
        [appStats setObject:[NSNumber numberWithInt:0] forKey:@"RunCount"];
        [appStats setObject:@"No Courses Viewed" forKey:@"LastCourseViewed"];
        
    } else {
        
        // read the existing plist
        appStats = [NSPropertyListSerialization propertyListWithData:appStatsData
                                                             options:NSPropertyListMutableContainersAndLeaves
                                                              format:NULL
                                                               error:&error];
        if (!appStats) {
            NSLog(@"Problem converting data to plist. Error: %@", error);
        }
    }
    
    return appStats;
    
}

+(void)saveAppStatsPlist:(NSMutableDictionary *)plist {
    
    NSError *error;
    
    // convert the plist to an NSData object
    NSData *appStatsData = [NSPropertyListSerialization dataWithPropertyList:plist
                                                                      format:NSPropertyListBinaryFormat_v1_0
                                                                     options:0
                                                                       error:&error];
    if (!appStatsData) {
        NSLog(@"Problem converting plist to data. Error: %@", error);
    }
    
    // get the path to the file and save it back to the file system
    NSURL *appStatsPath = [FileSystemHelper pathForDocumentsFile:@"app_stats.data"];
    [appStatsData writeToURL:appStatsPath atomically:YES];
    
}




@end
