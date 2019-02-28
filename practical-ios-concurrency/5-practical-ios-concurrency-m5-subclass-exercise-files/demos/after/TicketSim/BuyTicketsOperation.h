//
//  BuyTicketsOperation.h
//  TicketSim
//
//  Created by Brice Wilson on 6/22/14.
//  Copyright (c) 2014 Brice Wilson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimulationResult.h"
#import "Simulator.h"

@protocol BuyTicketsDelegate <NSObject>

- (void)displayBuyTicketsResult:(SimulationResult *)result;

@end

@interface BuyTicketsOperation : NSOperation

- (id)initWithCustomerName:(NSString *)name;

@property NSString *customerName;
@property id<BuyTicketsDelegate> delegate;

@end

