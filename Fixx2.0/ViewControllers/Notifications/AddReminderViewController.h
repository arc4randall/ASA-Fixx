//
//  AddReminderViewController.h
//  Fixx2.0
//
//  Created by Randall Spence on 5/4/15.
//  Copyright (c) 2015 Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReminderViewController.h"

@interface AddReminderViewController : UIViewController
@property(strong, nonatomic) ReminderViewController *incomeBoardController;
@property (strong, nonatomic) FPPopoverKeyboardResponsiveController *popover;
@property (strong, nonatomic) IBOutlet UITextField *reminderNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *reminderDaysTextField;
@property (strong, nonatomic) IBOutlet UITextField *reminderStartDateTextField;
@property (strong, nonatomic) IBOutlet UITextField *reminderEndDateTextField;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;
@property (strong,nonatomic) UIDatePicker *datePicker;
- (IBAction)saveButtonPressed:(id)sender;
@end
