//
//  DeleteIncomeViewController.h
//  Fixx2.0
//
//  Created by Randall Spence on 3/30/15.
//  Copyright (c) 2015 Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Income.h"
#import "OnboardIncomeViewController.h"
#import "FPPopoverKeyboardResponsiveController.h"

@interface DeleteIncomeViewController : UIViewController
{
    FPPopoverKeyboardResponsiveController *popover;
    OnboardIncomeViewController *incomeBoardController;
    Income *incomeObj;
}
@property(strong, nonatomic) OnboardIncomeViewController *incomeBoardController;
@property (strong, nonatomic) FPPopoverKeyboardResponsiveController *popover;
@property (strong, nonatomic) IBOutlet UISegmentedControl *timeFrameSegmentedControl;
@property (strong, nonatomic) IBOutlet UITextField *incomeValueTextField;
@property (strong, nonatomic) IBOutlet UITextField *incomeSourceTextField;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;
- (IBAction)deleteButtonPressed:(id)sender;
- (IBAction)saveButtonPressed:(id)sender;
@property (strong, nonatomic) NSMutableArray* incomeObjectArray;
@property (nonatomic, strong) Income *incomeObj;
-(instancetype)initWithIncomeSource:(NSString*)source value:(double)value duration:(NSString*)duration NS_DESIGNATED_INITIALIZER;
@property (strong, nonatomic) IBOutlet UIButton *categoryButton;
- (IBAction)categoryButtonPressed:(id)sender;
@end
