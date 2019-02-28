//
//  ViewController.m
//  TicketSim
//
//  Created by Brice Wilson on 2/6/14.
//  Copyright (c) 2014 Brice Wilson. All rights reserved.
//

#import "ViewController.h"
#import "Simulator.h"

@interface ViewController () {
    
    NSArray *customers;
    int currentCustomerIndex;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    customers = [NSArray arrayWithObjects:@"Audrey", @"Bub", @"Leigh Ann", @"Darshan", @"Evan", nil];
    currentCustomerIndex = 0;
    [[self customerNameLabel] setText:[customers objectAtIndex:currentCustomerIndex]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buyTicketsClicked:(id)sender {
    
    NSString *currentCustomerName = [customers objectAtIndex:currentCustomerIndex];

    double time = [Simulator runSimulationWithMinTime:2 maxTime:5];
    [self logResult:[NSString stringWithFormat:@"%@ bought tickets in %.02f seconds.", currentCustomerName, time]];
    
    if (currentCustomerIndex == [customers count] - 1) {
        [[self customerNameLabel] setText:@"No more customers"];
        [[self buyTicketsButton] setEnabled:NO];
    } else {
        [[self customerNameLabel] setText:[customers objectAtIndex:++currentCustomerIndex]];
    }
}

- (IBAction)resetClicked:(id)sender {
    [[self outputTextView] setText:@""];
    currentCustomerIndex = 0;
    [[self customerNameLabel] setText:[customers objectAtIndex:currentCustomerIndex]];
    [[self buyTicketsButton] setEnabled:YES];
}

- (IBAction)alphaChanged:(id)sender {
    UIColor *currentColor = [[self view] backgroundColor];
    [[self view] setBackgroundColor:[currentColor colorWithAlphaComponent:[[self alphaSlider] value]]];
}

- (void)logResult:(NSString *)message {
    
    NSString *contents = [[NSString alloc] init];
    
    if ([[self outputTextView] hasText]) {
        contents = [[[self outputTextView] text] stringByAppendingString:@"\n"];
    }
    
	contents = [contents stringByAppendingString:message];
	[[self outputTextView] setText:contents];
    
}

@end
