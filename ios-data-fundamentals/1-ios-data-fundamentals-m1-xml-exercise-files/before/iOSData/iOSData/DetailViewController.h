//
//  DetailViewController.h
//  iOSData
//
//  Created by Brice Wilson on 5/19/13.
//  Copyright (c) 2013 Brice Wilson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
