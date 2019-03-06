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
    NSOperationQueue *ticketQueue;
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
    ticketQueue = [[NSOperationQueue alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buyTicketsClicked:(id)sender {
    
    NSString *currentCustomerName = [customers objectAtIndex:currentCustomerIndex];
    
    NSBlockOperation *buyTicketsOp = [NSBlockOperation blockOperationWithBlock:^{
        
        double time = [Simulator runSimulationWithMinTime:2 maxTime:5];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self logResult:[NSString stringWithFormat:@"%@ bought tickets in %.02f seconds.", currentCustomerName, time]];
            
        });
    }];


    [buyTicketsOp setCompletionBlock:^{
        
        NSLog(@"Buy tickets operation completed for %@", currentCustomerName);
        
    }];
    
    
    NSBlockOperation *payOp = [NSBlockOperation blockOperationWithBlock:^{
        
        double time = [Simulator runSimulationWithMinTime:4 maxTime:10];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self logResult:[NSString stringWithFormat:@"%@ paid for tickets in %.02f seconds.", currentCustomerName, time]];
            
        });
        
    }];
    

    [payOp addObserver:self
            forKeyPath:@"isCancelled"
               options:NSKeyValueObservingOptionNew
               context:(__bridge void *)(currentCustomerName)];
    
    
    [payOp addDependency:buyTicketsOp];

    [ticketQueue addOperation:payOp];

    [ticketQueue addOperation:buyTicketsOp];
    
    
    if (currentCustomerIndex == [customers count] - 1) {
        [[self customerNameLabel] setText:@"No more customers"];
        [[self buyTicketsButton] setEnabled:NO];
    } else {
        [[self customerNameLabel] setText:[customers objectAtIndex:++currentCustomerIndex]];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    if ([keyPath isEqualToString:@"isCancelled"]) {
        
        NSLog(@"Payment for %@ is cancelled", context);
        
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


- (IBAction)cancelClicked:(id)sender {
    
    [ticketQueue cancelAllOperations];
    
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
