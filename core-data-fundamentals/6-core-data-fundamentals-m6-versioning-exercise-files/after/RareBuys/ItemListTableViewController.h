//
//  ItemListTableViewController.h
//  RareBuys
//
//  Created by Brice Wilson on 11/3/13.
//  Copyright (c) 2013 Brice Wilson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface ItemListTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@end
