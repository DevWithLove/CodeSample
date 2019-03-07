//
//  MasterViewController.m
//  iOSData
//
//  Created by Brice Wilson on 5/13/13.
//  Copyright (c) 2013 Brice Wilson. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"
#import "Course.h"

@interface MasterViewController () {
    NSMutableArray *_objects;
	Course *currentCourse;
	NSMutableString *currentValue;
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
	
	NSURL *url = [NSURL URLWithString:@"http://www.pluralsight.com/odata/Courses"];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	[NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
		
		// parse XML here!!!
		NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:data];
		[xmlParser setDelegate:self];
		[xmlParser parse];
		
	}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NSXMLParserDelegate Methods

- (void)parserDidStartDocument:(NSXMLParser *)parser {
	
	currentValue = [[NSMutableString alloc] init];
	_objects = [[NSMutableArray alloc] init];
}


- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
	attributes:(NSDictionary *)attributeDict {
	
	[currentValue setString:@""];
    if ([elementName isEqualToString:@"entry"])
    {
		currentCourse = [[Course alloc] init];
    }

}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	
	[currentValue appendString:string];
}


- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {
	
	if ([elementName isEqualToString:@"d:Title"])
    {
        [currentCourse setTitle:[currentValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    }
	if ([elementName isEqualToString:@"d:Category"])
    {
        [currentCourse setCategory:[currentValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    }
	if ([elementName isEqualToString:@"d:ShortDescription"])
    {
        [currentCourse setShortDesc:[currentValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    }
    
    // finished parsing job - add it to the array
    if ([elementName isEqualToString:@"entry"])
    {
        [_objects addObject:currentCourse];
    }
	

}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	
	// return to the main thread and update the table view
	dispatch_async(dispatch_get_main_queue(), ^{
		
		// refresh table view here
		[[self tableView] reloadData];
	});

}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	
	NSLog(@"Error Code: %d", [parseError code]);
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
