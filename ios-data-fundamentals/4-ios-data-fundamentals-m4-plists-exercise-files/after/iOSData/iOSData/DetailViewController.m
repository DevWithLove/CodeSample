//
//  DetailViewController.m
//  iOSData
//
//  Created by Wilson on 6/2/13.
//  Copyright (c) 2013 Wilson. All rights reserved.
//

#import "DetailViewController.h"
#import "FileSystemHelper.h"
#import "Course.h"

@interface DetailViewController ()
- (void)configureView;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)viewWillAppear:(BOOL)animated {
    
    Course *detailCourse = (Course *)[self detailItem];
    
    NSMutableDictionary *appStats = [FileSystemHelper appStatsPlist];
    
    [appStats setObject:[detailCourse title] forKey:@"LastCourseViewed"];
    
    [FileSystemHelper saveAppStatsPlist:appStats];
}


- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addToWatchListClicked:(id)sender {
    NSURL *dataFile = [FileSystemHelper pathForDocumentsFile:@"watchlist.data"];
    NSString *filePath = [dataFile path];
    
    NSMutableArray *coursesToWatch = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
    if (!coursesToWatch) {
        coursesToWatch = [NSMutableArray array];
    }
    
    [coursesToWatch addObject:_detailItem];
    
    BOOL success = [NSKeyedArchiver archiveRootObject:coursesToWatch toFile:filePath];
    
    if (success) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[_detailItem title]
                                                        message:@"Course added to watch list."
                                                       delegate:nil cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
    }
    else {
        NSLog(@"Unable to archive course to watch list.");
    }

}
@end
