//
//  DeleteIncomeViewController.m
//  Fixx2.0
//
//  Created by Randall Spence on 3/30/15.
//  Copyright (c) 2015 Tech. All rights reserved.
//

#import "DeleteIncomeViewController.h"
#import "Income.h"
#import "DBManager.h"
#import "GlobalManager.h"

@interface DeleteIncomeViewController () <UITextFieldDelegate,  UIPickerViewDelegate, UIPickerViewDataSource> {
    
}
@property(nonatomic, strong) UIToolbar *pickerToolBar;
@end

@implementation DeleteIncomeViewController
@synthesize incomeBoardController, incomeObj, popover;

-(instancetype)initWithIncomeSource:(NSString*)source value:(double)value duration:(NSString*)duration category:(NSString*)category
{
    self = [super init];
    if (self) {
        [self viewDidLoad];
        self.incomeSourceTextField.text = source;
        self.incomeValueTextField.text = [NSString stringWithFormat:@"%.2f",fabs(value)];
        self.categoryTextField.text = category;
        if ([duration  isEqual: @"Weekly"]) {
            self.timeFrameSegmentedControl.selectedSegmentIndex = 0;
        } else if ([duration isEqualToString:@"Monthly"]){
            self.timeFrameSegmentedControl.selectedSegmentIndex = 1;
        } else if ([duration isEqualToString:@"Yearly"]){
            self.timeFrameSegmentedControl.selectedSegmentIndex = 2;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.timeFrameSegmentedControl.frame = CGRectMake(-5,0,self.view.frame.size.width * 0.81, self.view.frame.size.height * 0.10);
    self.timeFrameSegmentedControl.tintColor = [UIColor blackColor];
    
    self.incomeValueTextField.frame = CGRectMake(self.view.frame.size.width / 12 + 15,(self.view.frame.size.height /12 - 10) * 3, self.view.frame.size.width / 2, self.view.frame.size.height / 15);
    [self.incomeValueTextField setKeyboardType:UIKeyboardTypeNumberPad];
    
    self.incomeSourceTextField.frame = CGRectMake(self.view.frame.size.width / 12 + 15,(self.view.frame.size.height / 12) * 4, self.view.frame.size.width / 2, self.view.frame.size.height / 15);
    
    self.saveButton.frame = CGRectMake(self.view.frame.size.width * 0.3333333,(self.view.frame.size.height / 12) * 6 - 2, self.view.frame.size.width / 2, self.view.frame.size.height / 15);
    
    self.saveButton.tintColor = [UIColor blackColor];
    
    self.deleteButton.frame = CGRectMake(self.view.frame.size.width * -0.1 + 18,(self.view.frame.size.height / 12) * 6 - 2, self.view.frame.size.width / 2, self.view.frame.size.height / 15);
    NSLog(@"X: %f Y: %f Width: %f Height: %f ",self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height);
    
    self.deleteButton.tintColor = [UIColor blackColor];
    
    self.categoryTextField.frame = CGRectMake(self.view.frame.size.width / 12 + 15,70,self.view.frame.size.width / 2, self.view.frame.size.height / 15);

    [self createPickerView];
    if (self.incomeBoardController.isExpenseController) {
        [self.incomeSourceTextField setPlaceholder:@"Expense Source"];
    }
    
    NSLog(@"save x: %f del x: %f",self.saveButton.frame.origin.x,self.deleteButton.frame.origin.x);

}

-(void) createPickerView {
    _categoryPicker = [[UIPickerView alloc] init];
    _categoryPicker.delegate = self;
    _categoryPicker.dataSource = self;
    
    _pickerToolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,320,44)];
    [_pickerToolBar setBarStyle:UIBarStyleBlackOpaque];
    UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(changeFromLabel)];
    UIBarButtonItem *flexiblePlaceHolder = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    barButtonDone.tintColor=[UIColor blackColor];
    [_pickerToolBar setItems:[NSArray arrayWithObjects:flexiblePlaceHolder, barButtonDone, nil]];
    self.categoryTextField.inputAccessoryView = _pickerToolBar;
    
}

-(void)changeFromLabel{
    // do dismiss here.
    NSLog(@"done clicked");
    [self.categoryTextField resignFirstResponder];
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

- (IBAction)deleteButtonPressed:(id)sender {
    if ([[DBManager getSharedInstance] deleteByID:self.incomeObj]) {
        NSLog(@"DELETE INCOMEOBJ: %@",self.incomeObj);
        NSLog(@"DELETE UPDATE SHOULD HAVE WORKED");
        [self reloadTableDismissCurrent];
    }
}

- (IBAction)saveButtonPressed:(id)sender {
    
    if ([self.incomeSourceTextField.text isEqualToString:@""]) {
        CABasicAnimation *animationOnLoginEmail = [CABasicAnimation animationWithKeyPath:@"position"];
        [animationOnLoginEmail setDuration:0.15];
        [animationOnLoginEmail setRepeatCount:3];
        [animationOnLoginEmail setAutoreverses:YES];
        [animationOnLoginEmail setFromValue:[NSValue valueWithCGPoint: CGPointMake([self.incomeSourceTextField center].x - 7.0f, [self.incomeSourceTextField center].y)]];
        [[self.incomeSourceTextField layer] addAnimation:animationOnLoginEmail forKey:@"position"];
    }
    if ([self.incomeValueTextField.text isEqualToString:@""]) {
        CABasicAnimation *animationOnLoginEmail = [CABasicAnimation animationWithKeyPath:@"position"];
        [animationOnLoginEmail setDuration:0.15];
        [animationOnLoginEmail setRepeatCount:3];
        [animationOnLoginEmail setAutoreverses:YES];
        [animationOnLoginEmail setFromValue:[NSValue valueWithCGPoint: CGPointMake([self.incomeValueTextField center].x - 7.0f, [self.incomeValueTextField center].y)]];
        [[self.incomeValueTextField layer] addAnimation:animationOnLoginEmail forKey:@"position"];
    }
    if ([self.categoryTextField.text isEqualToString:@""]) {
        CABasicAnimation *animationOnLoginEmail = [CABasicAnimation animationWithKeyPath:@"position"];
        [animationOnLoginEmail setDuration:0.15];
        [animationOnLoginEmail setRepeatCount:3];
        [animationOnLoginEmail setAutoreverses:YES];
        [animationOnLoginEmail setFromValue:[NSValue valueWithCGPoint: CGPointMake([self.categoryTextField center].x - 7.0f, [self.categoryTextField center].y)]];
        [[self.categoryTextField layer] addAnimation:animationOnLoginEmail forKey:@"position"];
    }
    if (![self.incomeSourceTextField.text isEqualToString:@""] && ![self.incomeValueTextField.text isEqualToString:@""] && ![self.categoryTextField.text isEqualToString:@""]) {
    
    self.incomeObj.name = self.incomeSourceTextField.text;
    if (self.incomeBoardController.isExpenseController) {
        self.incomeObj.amount = fabs([self.incomeValueTextField.text doubleValue]) * -1.0;
    }
        
    {
        self.incomeObj.amount = fabs([self.incomeValueTextField.text doubleValue]);
    }
    
    NSString* durationString = [[NSString alloc] init];
    switch (self.timeFrameSegmentedControl.selectedSegmentIndex) {
        case 0:
            durationString = @"Weekly";
            break;
        case 1:
            durationString = @"Monthly";
            break;
        case 2:
            durationString = @"Yearly";
            break;
    }
    self.incomeObj.duration = durationString;
    self.incomeObj.category = self.categoryTextField.text;
    if ([[DBManager getSharedInstance]updateByID:self.incomeObj]) {
        [self reloadTableDismissCurrent];
        }
    }
}
-(void) reloadTableDismissCurrent {
    if (self.incomeBoardController.isExpenseController) {
        self.incomeBoardController.incomeExpenseDictionary = [[DBManager getSharedInstance] returnAllByType:@"expense"];

    } else {
        self.incomeBoardController.incomeExpenseDictionary = [[DBManager getSharedInstance] returnAllByType:@"income"];
    }
    [self.incomeBoardController viewWillAppear:YES];
    [self.popover dismissPopoverAnimated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.incomeValueTextField resignFirstResponder];
    [self.incomeSourceTextField resignFirstResponder];
}
#pragma mark UITextField Methods
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.categoryTextField){
        self.categoryTextField.inputView = _categoryPicker;
        if ([self.incomeBoardController isExpenseController]){
        self.categoryTextField.text = @"Rent";
        } else {
        self.categoryTextField.text = @"Job";
        }
        
    }
    textField.placeholder = nil;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    textField.placeholder = @"";
}

#pragma mark Pickerview Methods
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [[[GlobalManager sharedManager]incomeCategoryArray] count];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[[GlobalManager sharedManager]incomeCategoryArray] objectAtIndex:row];
}

//-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
//{
//    return 100;
//}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.categoryTextField.text = [[GlobalManager sharedManager]incomeCategoryArray][row];
}

@end
