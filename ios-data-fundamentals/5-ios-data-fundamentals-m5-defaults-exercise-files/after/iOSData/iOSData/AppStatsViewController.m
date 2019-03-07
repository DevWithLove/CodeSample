//
//  AppStatsViewController.m
//  iOSData
//
//  Created by Wilson on 6/27/13.
//  Copyright (c) 2013 Brice Wilson. All rights reserved.
//

#import "AppStatsViewController.h"
#import "FileSystemHelper.h"

@interface AppStatsViewController ()

@end

@implementation AppStatsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    
    // retrieve the property list
    NSMutableDictionary *appStats = [FileSystemHelper appStatsPlist];
    
    // retrieve the data to display from the list
    NSString *runCount = [(NSNumber *)[appStats objectForKey:@"RunCount"] stringValue];
    
    NSDate *lastRunDate = (NSDate *)[appStats objectForKey:@"LastRunTime"];
    NSString *lastRunDateString = [lastRunDate descriptionWithLocale:[NSLocale currentLocale]];
    
    NSString *lastCourseViewed = [appStats objectForKey:@"LastCourseViewed"];
    
    // display the data
    [[self runCountLabel] setText:runCount];
    [[self lastRunDateLabel] setText:lastRunDateString];
    [[self lastCourseViewedLabel] setText:lastCourseViewed];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
