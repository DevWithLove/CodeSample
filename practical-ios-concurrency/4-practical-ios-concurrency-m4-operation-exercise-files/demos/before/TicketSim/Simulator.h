//
//  Simulator.h
//  TicketSim
//
//  Created by Brice Wilson on 5/20/14.
//  Copyright (c) 2014 Brice Wilson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Simulator : NSObject

+ (double) runSimulationWithMinTime:(int)min maxTime:(int)max;

@end
