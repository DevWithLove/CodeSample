//
//  Simulator.m
//  TicketSim
//
//  Created by Brice Wilson on 5/20/14.
//  Copyright (c) 2014 Brice Wilson. All rights reserved.
//

#import "Simulator.h"

@implementation Simulator

+ (double)runSimulationWithMinTime:(int)min maxTime:(int)max {
    
    // calculate random thread wait time
    int ms = (arc4random() % ((max - min) * 1000)) + (min * 1000);
	double waitTime = ms / 1000.0;
	
	[NSThread sleepForTimeInterval:waitTime];
	
	return waitTime;
}

@end
