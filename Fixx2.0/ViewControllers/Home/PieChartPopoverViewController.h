//
//  PieChartPopoverViewController.h
//  Fixx2.0
//
//  Created by Randall Spence on 4/6/15.
//  Copyright (c) 2015 Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PieChartPopoverViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIView *piechartView;
@property (strong, nonatomic) IBOutlet UIScrollView *summaryScrollview;

@end
