//
//  PreferencesViewController.h
//  iOSData
//
//  Created by Wilson on 6/30/13.
//  Copyright (c) 2013 Brice Wilson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreferencesViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISegmentedControl *sortOrderSegmentedControl;
- (IBAction)sortOrderChanged:(id)sender;
@end
