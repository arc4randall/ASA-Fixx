//
//  ForGotPasswordViewController.m
//  Trankeytest
//
//  Created by Jaydev on 08/05/14.
//  Copyright (c) 2014 Jaydev. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "ValidationManager.h"
#import "CustomAlertView.h"

@interface ForgotPasswordViewController ()
{
    int isMobileNumerValid;
    CustomAlertView *customAlertView;
}
@end

@implementation ForgotPasswordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareLayout];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark custom methods
-(void)prepareLayout
{
    customAlertView = [CustomAlertView initAlertView];
    
    UIButton *btnBack=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setImage:[UIImage imageNamed:@"icon-52-left-arrow-normal.png"] forState:UIControlStateNormal];
    [btnBack setImage:[UIImage imageNamed:@"icon-52-left-arrow-hover.png"] forState:UIControlStateHighlighted];
    [btnBack setTintColor:[UIColor clearColor]];
    [btnBack setFrame:CGRectMake(0, 5, 26, 26)];
    [btnBack addTarget:self action:@selector(btnBackClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButton=[[UIBarButtonItem alloc]initWithCustomView:btnBack];
    [self.navigationItem setLeftBarButtonItem:leftBarButton];
    btnBack = nil;
    leftBarButton = nil;
    
    
    // Add custom lable to show title on navigation bar
    UILabel *titileview=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 130, 30)];
    [titileview setFont:[UIFont fontWithName:ProximaNovaBold size:16.0f]];
    titileview.textColor =[UIColor colorWithRed:236.0/255.0 green:128.0/255.0 blue:19.0/255.0 alpha:1.0];
   [titileview setTextAlignment:NSTextAlignmentCenter];
    [titileview setText:@"FORGOT PASSWORD"];
    [titileview setBackgroundColor:[UIColor clearColor]];
    [self.navigationItem setTitleView:titileview];
   
    UIButton *btnReset=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnReset setTitle:@"RESET"  forState:UIControlStateNormal];
    [btnReset.titleLabel setFont:[UIFont fontWithName:ProximaNovaBold size:14.0]];
    [btnReset setTitleColor:[UIColor colorWithRed:150.0/255.0 green:120/255.0 blue:108.0/255.0 alpha:1.0]  forState:UIControlStateNormal];
    [btnReset setTitleColor:[UIColor colorWithRed:150.0/255.0 green:120/255.0 blue:108.0/255.0 alpha:0.6]  forState:UIControlStateSelected];
    [btnReset setTitleColor:[UIColor colorWithRed:150.0/255.0 green:120/255.0 blue:108.0/255.0 alpha:0.6]  forState:UIControlStateHighlighted];
    [btnReset setTintColor:[UIColor clearColor]];
    [btnReset setFrame:CGRectMake(290,0, 45, 30)];
    [btnReset addTarget:self action:@selector(btnResetClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton=[[UIBarButtonItem alloc]initWithCustomView:btnReset];
    [self.navigationItem setRightBarButtonItem:rightBarButton];
    btnReset = nil;
    rightBarButton = nil;
   
    // set the scrollview frame and content size
    
    [_lblMobileMessage setFont:[UIFont fontWithName:ProximaNovaRegular size:17.0]];
    [_lblMobileMessage setTextColor:[UIColor colorWithRed:68.0f/255.0 green:68.0f/255.0  blue:68.0f/255.0  alpha:1.0]];
    
    NSAttributedString *strMobileNo = [[NSAttributedString alloc] initWithString:@"Enter Mobile Number" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0],NSFontAttributeName:[UIFont fontWithName:ProximaNovaRegular size:17.0f] }];
    [_txtMobileNumber setAttributedPlaceholder:strMobileNo];
    [_txtMobileNumber performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.2];
    
    [_btnCountryCode.titleLabel setFont:[UIFont fontWithName:ProximaNovaRegular size:17]];
    [_btnCountryCode setTitleColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0] forState:UIControlStateNormal];

}


-(void)btnBackClick {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)btnResetClick
{
    [self.view endEditing:YES];
    [customAlertView displayAlertViewWithView:self.view withTitle:@"Password Reset" withMessage:@"Please check your email or SMS for instructions." withButtonTitle:@"OK" withOtherButtonTitle:@""];
    
//    if ([_txtMobileNumber.text isEqualToString:@""]) {
//        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please Enter Mobile number" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//    } else  if (isMobileNumerValid==2) {
//        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please Enter Valid Mobile number" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//    } else {
//        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Password Reset" message:@"Please check your Email or SMS for instractions" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//    }
}

-(void)checkvalidation:(UITextField*)textField
{
    if (textField.tag==1) {
        if ([_txtMobileNumber.text isEqualToString:@""])
        {
            isMobileNumerValid=3;
        } else if (![ValidationManager validatePhoneNumber:_txtMobileNumber.text]) {
            isMobileNumerValid=2;
        } else if ([ValidationManager validatePhoneNumber:_txtMobileNumber.text])
        {
            isMobileNumerValid=1;
        }
    }
    
    if (isMobileNumerValid==1) {
        [_btnMobileNumberIcon setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:128.0/255.0 blue:0.0/255.0 alpha:1.0]];
    } else if(isMobileNumerValid==2) {
        [_btnMobileNumberIcon setBackgroundColor:[UIColor colorWithRed:210.0/255.0 green:25.0/255.0 blue:5.0/255.0 alpha:1.0]];
    } else if(isMobileNumerValid==3) {
        [_btnMobileNumberIcon setBackgroundColor:[UIColor clearColor]];
    }
}

#pragma mark setSelect Counrtycode delegate method
-(void)setselectedCountryCode:(NSMutableDictionary*)dict
{
    [_btnCountryCode setTitle:[NSString stringWithFormat:@"%@",[dict  objectForKey:@"code"]] forState:UIControlStateNormal];
    
}

#pragma mark UITextFeild delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
     return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField==_txtMobileNumber) {
        isMobileNumerValid=3;
        [self checkvalidation:textField];
    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    int nextTextTag=textField.tag +1;
    
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTextTag];
    if(nextTextTag==2)
    {
        [textField endEditing:YES];
        [_scrContainer setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else
    {
        if (nextResponder)
        {
            [nextResponder becomeFirstResponder];
        }
        else
            [textField resignFirstResponder];
    }
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField==_txtMobileNumber) {
        isMobileNumerValid = 3;
        [_btnMobileNumberIcon setBackgroundColor:[UIColor colorWithRed:175.0/255.0 green:175.0/255.0 blue:175.0/255.0 alpha:1.0]];
    }
    return YES;
}


@end
