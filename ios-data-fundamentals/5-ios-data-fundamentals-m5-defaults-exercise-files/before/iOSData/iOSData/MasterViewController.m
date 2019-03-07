//
//  MasterViewController.m
//  iOSData
//
//  Created by Wilson on 6/2/13.
//  Copyright (c) 2013 Wilson. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"
#import "Course.h"
#import "NSJSONSerialization+JSONStrings.h"

@interface MasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation MasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // create HTTP request and download JSON from the service
    NSURL *url = [NSURL URLWithString:@"http://www.pluralsight.com/odata/Courses"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
       
        // parse the JSON into Foundation objects
        NSError* jsonError;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        
        if (json) {
            NSArray* allCourses = [json objectForKey:@"d"];
            
            _objects = [[NSMutableArray alloc] init];
            
            // convert Foundation objects into an array of Course objects
            for (NSDictionary* jsonCourse in allCourses) {
                
                Course *course = [[Course alloc] init];
                [course setTitle:[jsonCourse objectForKey:@"Title"]];
                [course setCategory:[jsonCourse objectForKey:@"Category"]];
                [course setShortDesc:[jsonCourse objectForKey:@"ShortDescription"]];
                
                [_objects addObject:course];
                
            }
            
            // return to the main thread and update the table view
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[self tableView] reloadData];
            });
        }
        else {
            NSLog(@"An error occurred: %@", jsonError);
        }
        

        
    }];
    
    // simulate POSTing JSON to a service
    [self postJSONCourse];
}

- (void)postJSONCourse {
    
    // create a new course object
    Course *newCourse = [[Course alloc] init];
    [newCourse setTitle:@"iOS Data Fundamentals"];
    [newCourse setCategory:@"iOS"];
    [newCourse setShortDesc:@"Learn cool stuff about iOS data."];
    
    // convert object to an NSData object containing JSON
    NSData *jsonData = [newCourse convertToJSONData];
    
    // create an HTTP request to send JSON to the server
    NSURL *url = [NSURL URLWithString:@"http://www.pluralsight.com/odata/Courses"];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:jsonData];
	
    // Pluralsight service does not support creating new courses!!!!
//	[NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//        
//        // do something with the response here
//        
//    }];
    
    // print JSON to the console
    [NSJSONSerialization logJSONWithData:jsonData label:@"New Course"];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    Course *object = _objects[indexPath.row];
    cell.textLabel.text = [object title];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

@end
