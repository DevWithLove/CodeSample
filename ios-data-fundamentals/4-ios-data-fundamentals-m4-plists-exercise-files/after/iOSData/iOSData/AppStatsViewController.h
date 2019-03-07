//
//  AppStatsViewController.h
//  iOSData
//
//  Created by Wilson on 6/27/13.
//  Copyright (c) 2013 Brice Wilson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppStatsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *runCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastRunDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastCourseViewedLabel;
@end
