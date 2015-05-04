//
//  AddReminderViewController.m
//  Fixx2.0
//
//  Created by Randall Spence on 5/4/15.
//  Copyright (c) 2015 Tech. All rights reserved.
//

#import "AddReminderViewController.h"

@interface AddReminderViewController ()

@end

@implementation AddReminderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.reminderStartDateTextField = [[UITextField alloc] init];
    self.reminderEndDateTextField = [[UITextField alloc] init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.reminderNameTextField resignFirstResponder];
    [self.reminderDaysTextField resignFirstResponder];
    [self.reminderStartDateTextField resignFirstResponder];
    [self.reminderEndDateTextField resignFirstResponder];
}

-(void) createPickerView {
    _datePicker = [[UIDatePicker alloc] init];
    
    UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(changeFromLabel)];
    barButtonDone.tintColor=[UIColor blackColor];
    
}

-(IBAction)changeFromLabel
{
    NSLog(@"changefromlabel");
}

- (IBAction)saveButtonPressed:(id)sender
{
  
}

@end
