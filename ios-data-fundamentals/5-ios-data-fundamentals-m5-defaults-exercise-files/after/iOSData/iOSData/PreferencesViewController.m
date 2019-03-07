//
//  PreferencesViewController.m
//  iOSData
//
//  Created by Wilson on 6/30/13.
//  Copyright (c) 2013 Brice Wilson. All rights reserved.
//

#import "PreferencesViewController.h"
#import "Course.h"

@interface PreferencesViewController ()

@end

@implementation PreferencesViewController

- (void)viewWillAppear:(BOOL)animated {
    
    NSInteger currentSortOrder = [[NSUserDefaults standardUserDefaults] integerForKey:@"CourseListSortOrder"];
    [[self sortOrderSegmentedControl] setSelectedSegmentIndex:currentSortOrder];
}

- (IBAction)sortOrderChanged:(id)sender {
    
    UISegmentedControl *sortOrderControl = (UISegmentedControl *)sender;
    
    switch ([sortOrderControl selectedSegmentIndex]) {
        case CourseListSortOrderByTitle:
            [[NSUserDefaults standardUserDefaults] setInteger:CourseListSortOrderByTitle forKey:@"CourseListSortOrder"];
            break;
            
        case CourseListSortOrderByCategory:
            [[NSUserDefaults standardUserDefaults] setInteger:CourseListSortOrderByCategory forKey:@"CourseListSortOrder"];
            break;
            
        default:
            break;
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
