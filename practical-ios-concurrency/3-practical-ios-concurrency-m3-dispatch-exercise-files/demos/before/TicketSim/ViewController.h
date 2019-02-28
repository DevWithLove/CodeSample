//
//  ViewController.h
//  TicketSim
//
//  Created by Brice Wilson on 2/6/14.
//  Copyright (c) 2014 Brice Wilson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *customerNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *buyTicketsButton;
@property (weak, nonatomic) IBOutlet UISlider *alphaSlider;
@property (weak, nonatomic) IBOutlet UITextView *outputTextView;
- (IBAction)buyTicketsClicked:(id)sender;
- (IBAction)resetClicked:(id)sender;
- (IBAction)alphaChanged:(id)sender;
@end
