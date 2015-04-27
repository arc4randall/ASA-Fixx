//
//  AddNewExpenseViewController.h
//  Fixx2.0
//
//  Created by vivek soni on 21/05/14.
//  Copyright (c) 2014 Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Income.h"
#import "OnboardIncomeViewController.h"
#import "FPPopoverKeyboardResponsiveController.h"

@interface AddNewIncomeViewController : UIViewController
{
    FPPopoverKeyboardResponsiveController *popover;
    OnboardIncomeViewController *incomeBoardController;
}
@property(strong, nonatomic) OnboardIncomeViewController *incomeBoardController;
@property (strong, nonatomic) FPPopoverKeyboardResponsiveController *popover;
@property (strong, nonatomic) IBOutlet UISegmentedControl *timeFrameSegmentedControl;
@property (strong, nonatomic) IBOutlet UITextField *earningAmountTextField;
@property (strong, nonatomic) IBOutlet UITextField *nameOfFixxTextField;
- (IBAction)segmentedControlValueChanged:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;
- (IBAction)saveButtonPressed:(id)sender;
@property (strong,nonatomic) NSMutableArray* incomeObjectArray;

@property (strong,nonatomic) UIPickerView* categoryPicker;
@property (strong, nonatomic) IBOutlet UITextField *categoryTextField;
@end
