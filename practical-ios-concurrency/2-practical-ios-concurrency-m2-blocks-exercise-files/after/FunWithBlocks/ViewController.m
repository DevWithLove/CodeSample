//
//  ViewController.m
//  FunWithBlocks
//
//  Created by Brice Wilson on 2/1/14.
//  Copyright (c) 2014 Brice Wilson. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

typedef int (^IntBlock)(int);

-(void)declareAndCallBlock {
    
    IntBlock squareBlock = ^(int num) {
        return num * num;
    };
    
    NSLog(@"Block return value: %d", squareBlock(6));
}

- (void)shareScopeVars {
    
    __block NSString *weather = @"rainy";
    
    NSLog(@"Weather before block: %@", weather);
    
    void (^changeWeather)(void) = ^{
        weather = @"sunny";
        NSLog(@"Weather inside block: %@", weather);
    };
    
    changeWeather();
}

- (void)useInlineBlock {
    
    NSArray *names = [NSArray arrayWithObjects:@"Desai", @"Tolstoy", @"Austen", @"Hemingway", @"Dickens", nil];
    
    [names enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop) {
        NSString *person = (NSString *)obj;
        NSLog(@"Name: %@", [person uppercaseString]);
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self useInlineBlock];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
