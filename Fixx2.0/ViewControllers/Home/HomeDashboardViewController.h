//
//  HomeDashboardViewController.h
//  Fixx2.0
//
//  Created by vivek soni on 24/05/14.
//  Copyright (c) 2014 Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebserviceHandler.h"
#import "XYPieChart.h"
#import "FPPopoverKeyboardResponsiveController.h"

@interface HomeDashboardViewController : UIViewController <WebServiceHandlerDelegate, XYPieChartDelegate, XYPieChartDataSource> {
    FPPopoverKeyboardResponsiveController *popover;
    CGFloat _keyboardHeight;
}

@property (strong, nonatomic) IBOutlet UISegmentedControl *timeFrameSegmentedControl;

@property (nonatomic,weak) IBOutlet UILabel *lblSpendValue;
@property (nonatomic,weak) IBOutlet UILabel *lblEarnValue;
@property (nonatomic,weak) IBOutlet UILabel *lblAvgBalance;

@property (nonatomic,weak) IBOutlet UIView *graphContainer;

@property (strong, nonatomic) UIView* incomePieChartView;
@property (strong, nonatomic) UIView* expensePieChartView;

@property (strong, nonatomic) XYPieChart *incomePieChart;
@property (strong, nonatomic) XYPieChart *expensePieChart;

@property (strong, nonatomic) NSMutableArray* slices;
@property (nonatomic, strong) NSArray *sliceColors;

- (IBAction)segmentedControlValueChanged:(id)sender;

@property (nonatomic,strong) NSMutableArray* incomeObjectArray;
@property (nonatomic,strong) NSMutableArray* expenseObjectArray;

@property (nonatomic,strong) NSNumberFormatter* numberFormatter;

@end
