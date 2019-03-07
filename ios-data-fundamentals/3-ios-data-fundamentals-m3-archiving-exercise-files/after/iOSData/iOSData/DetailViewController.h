//
//  DetailViewController.h
//  iOSData
//
//  Created by Wilson on 6/2/13.
//  Copyright (c) 2013 Wilson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
- (IBAction)addToWatchListClicked:(id)sender;
@end
