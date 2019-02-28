//
//  ViewController.m
//  TicketSim
//
//  Created by Brice Wilson on 5/2014.
//  Copyright (c) 2014 Brice Wilson. All rights reserved.
//

#import "ViewController.h"
#import "Simulator.h"

@interface ViewController () {
    
    NSArray *customers;
    int currentCustomerIndex;
    dispatch_queue_t ticketQueue;
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
    ticketQueue = dispatch_queue_create("net.bricewilson.ticketQueue", DISPATCH_QUEUE_SERIAL);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buyTicketsClicked:(id)sender {
    
    NSString *currentCustomerName = [customers objectAtIndex:currentCustomerIndex];

    dispatch_async(ticketQueue, ^{
        
        double time = [Simulator runSimulationWithMinTime:2 maxTime:5];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self logResult:[NSString stringWithFormat:@"%@ bought tickets in %.02f seconds.", currentCustomerName, time]];
            
        });
        
        [self submitPaymentForCustomer:currentCustomerName];
        
    });
    
    if (currentCustomerIndex == [customers count] - 1) {
        [[self customerNameLabel] setText:@"No more customers"];
        [[self buyTicketsButton] setEnabled:NO];
    } else {
        [[self customerNameLabel] setText:[customers objectAtIndex:++currentCustomerIndex]];
    }
}

- (void)submitPaymentForCustomer:(NSString *)customer {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        double time = [Simulator runSimulationWithMinTime:4 maxTime:10];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self logResult:[NSString stringWithFormat:@"%@ paid in %.02f seconds.", customer, time]];
            
        });
        
    });
    
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
