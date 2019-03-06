//
//  SecondViewController.m
//  RareBuys
//
//  Created by Brice Wilson on 9/18/13.
//  Copyright (c) 2013 Brice Wilson. All rights reserved.
//

#import "SecondViewController.h"
#import "DataStore.h"
#import "RareItem.h"
#import "ItemCategory.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    DataStore *dataStore = [DataStore sharedDataStore];
    NSManagedObjectContext *context = [dataStore context];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ItemCategory"];
    
    NSError *error;
    [self setAllCategories:[context executeFetchRequest:request error:&error]];
    
    [[self picker] setDelegate:self];
    [[self picker] setDataSource:self];
    
    [[self picker] selectRow:0 inComponent:0 animated:NO];
    [self setSelectedCategory:[[self allCategories] objectAtIndex:0]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addItemClicked:(id)sender {
    [[self itemNameTextField] resignFirstResponder];
    
    DataStore *dataStore = [DataStore sharedDataStore];
    NSManagedObjectContext *context = [dataStore context];
    
    RareItem *newItem = [NSEntityDescription insertNewObjectForEntityForName:@"RareItem"
                                                      inManagedObjectContext:context];
    
    
    NSString *newItemName = [[self itemNameTextField] text];
    
    [newItem setItemName:newItemName];
    [newItem setCategory:[self selectedCategory]];
    
    [dataStore saveChanges];
    
    [[self tabBarController] setSelectedIndex:0];
    
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [[self allCategories] count];
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
    
    ItemCategory *category = [[self allCategories] objectAtIndex:row];
    return [category categoryName];
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component {
    
    ItemCategory *selected = [[self allCategories] objectAtIndex:row];
    [self setSelectedCategory:selected];
}

@end
