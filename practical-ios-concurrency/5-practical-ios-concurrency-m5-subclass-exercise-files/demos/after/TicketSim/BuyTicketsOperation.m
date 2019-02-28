//
//  BuyTicketsOperation.m
//  TicketSim
//
//  Created by Brice Wilson on 6/22/14.
//  Copyright (c) 2014 Brice Wilson. All rights reserved.
//

#import "BuyTicketsOperation.h"

@implementation BuyTicketsOperation

- (id)initWithCustomerName:(NSString *)name {
    
    if (self = [super init])
    {
        [self setCustomerName:name];
    }
    return self;
}

-(void)main {
    
    double totalTime = 0.0;
    
    for (int i = 0; i < 5; i++) {
        
        if ([self isCancelled]) {
            return;
        }
        
        totalTime += [Simulator runSimulationWithMinTime:1 maxTime:3];
        
    }
    
    SimulationResult *result = [[SimulationResult alloc] init];
    [result setCustomerName:[self customerName]];
    [result setSimulationTime:totalTime];
    
    [(NSObject *)self.delegate performSelectorOnMainThread:(@selector(displayBuyTicketsResult:)) withObject:result waitUntilDone:NO];
}

@end

