//
//  SecondViewController.h
//  RareBuys
//
//  Created by Brice Wilson on 9/18/13.
//  Copyright (c) 2013 Brice Wilson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemCategory.h"

@interface SecondViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *itemNameTextField;

@property (weak, nonatomic) IBOutlet UIPickerView *picker;
- (IBAction)addItemClicked:(id)sender;

@property (nonatomic, strong) NSArray *allCategories;
@property (nonatomic, strong) ItemCategory *selectedCategory;
@end
