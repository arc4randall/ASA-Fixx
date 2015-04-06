//
//  UpdateProfileViewController.m
//  Fixx2.0
//
//  Created by vivek soni on 12/07/14.
//  Copyright (c) 2014 Tech. All rights reserved.
//

#import "UpdateProfileViewController.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import "AppLoader.h"
#import "CustomAlertView.h"
#import "ValidationManager.h"


@interface UpdateProfileViewController () {
    UIButton *btnSliderLeft;
    AppLoader *appLoader;
    CustomAlertView *alertView;
    NSMutableDictionary *dicMyProfile;
}

@end

@implementation UpdateProfileViewController

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

- (void) prepareLayout {
 
    
//    //set back button color
//    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor,nil] forState:UIControlStateNormal];
//    //set back button arrow color
//    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    btnSliderLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnSliderLeft setFrame:CGRectMake(0, 5, 28, 28)];
    [btnSliderLeft setImage:[UIImage imageNamed:@"icon-list-hover.png"] forState:UIControlStateHighlighted];
    [btnSliderLeft setImage:[UIImage imageNamed:@"icon-list-normal.png"] forState:UIControlStateNormal];
    [btnSliderLeft addTarget:self action:@selector(leftDrawerButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [btnSliderLeft setSelected:NO];
    [btnSliderLeft setBackgroundColor:[UIColor clearColor]];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [btnSliderLeft setHidden:NO];
    }else
    {
        [btnSliderLeft setHidden:YES];
    }
    
    UIBarButtonItem *leftBarButton=[[UIBarButtonItem alloc]initWithCustomView:btnSliderLeft];
    [self.navigationItem setLeftBarButtonItem:leftBarButton];
        if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPhone) {
            [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:NO completion:nil];
            [self performSelector:@selector(nowHide) withObject:Nil afterDelay:0.1f];
        }
    
    // Add custom label to show title on navigation bar
    UIImageView *titleLogo=[[UIImageView alloc]init];
    [titleLogo setFrame:CGRectMake(0, 10, 58, 24)];
    [titleLogo setBackgroundColor:[UIColor clearColor]];
    titleLogo.contentMode = UIViewContentModeScaleAspectFit;
    [titleLogo setImage:[UIImage imageNamed:@"top_logo.png"]];
    [self.navigationItem setTitleView:titleLogo];
    
    NSMutableDictionary *dicUserInfo = [objSharedData getUserInfo];
    
    //Sign Up Field
    NSAttributedString *strFName = [[NSAttributedString alloc] initWithString:@"First Name" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:ProximaNovaRegular size:16.0f] }];
    [_txtFName setAttributedPlaceholder:strFName];
    [_txtFName setText:[dicUserInfo objectForKey:@"Firstname"]];
    [_txtFName setFont:[UIFont fontWithName:ProximaNovaRegular size:16.0f]];
    [_txtFName setTextColor:[UIColor whiteColor]];
    
    NSAttributedString *strLName = [[NSAttributedString alloc] initWithString:@"Last Name" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:ProximaNovaRegular size:16.0f] }];
    [_txtLName setAttributedPlaceholder:strLName];
    [_txtLName setText:[dicUserInfo objectForKey:@"Lastname"]];
    [_txtLName setFont:[UIFont fontWithName:ProximaNovaRegular size:16.0f]];
    [_txtLName setTextColor:[UIColor whiteColor]];
    
    NSAttributedString *strEmail = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:ProximaNovaRegular size:16.0f] }];
    [_txtEmail setAttributedPlaceholder:strEmail];
    [_txtEmail setText:[dicUserInfo objectForKey:@"Email"]];
    [_txtEmail setFont:[UIFont fontWithName:ProximaNovaRegular size:16.0f]];
    [_txtEmail setTextColor:[UIColor whiteColor]];
    
    NSAttributedString *strPassword = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:ProximaNovaRegular size:16.0f] }];
    [_txtPassword setAttributedPlaceholder:strPassword];
    [_txtPassword setText:[dicUserInfo objectForKey:@"Password"]];
    [_txtPassword setFont:[UIFont fontWithName:ProximaNovaRegular size:16.0f]];
    [_txtPassword setTextColor:[UIColor whiteColor]];
    
    if ([dicUserInfo objectForKey:@"year_of_birth"] ) {
        [_btnYearOfBirth setTitleEdgeInsets:UIEdgeInsetsMake(0, -450, 0, 0)];
        [_btnYearOfBirth setTitle:[dicUserInfo objectForKey:@"year_of_birth"] forState:UIControlStateNormal];
    }
    
    
    _requestOnWeb = [[WebserviceHandler alloc] init];
    _requestOnWeb.delegate = self;
     appLoader = [AppLoader initLoaderView];
    alertView = [CustomAlertView initAlertView];
    
    //DOBPicker View
    [_DOBYearPicker setBackgroundColor:[UIColor whiteColor]];
    _arrSourceDOBPicker = [[NSMutableArray alloc] init];
    
    //get Current Year
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSString *yearString = [formatter stringFromDate:[NSDate date]];
    
    for (int i=1914; i<=[yearString integerValue]; i++) {
        [_arrSourceDOBPicker addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    [_DOBYearPicker selectRow:80 inComponent:0 animated:YES];
    
    //Terms and Condition
    _lblTermsCondition.numberOfLines = 0;
    [_lblTermsCondition setFont:[UIFont fontWithName:ProximaNovaRegular size:14]];
    NSString *text = @"I agree to SALT's Terms of Use and Privacy Policy.";
    
    [_lblTermsCondition setText:text afterInheritingLabelAttributesAndConfiguringWithBlock:^(NSMutableAttributedString *mutableAttributedString) {
        NSRange whiteRange = [text rangeOfString:@"Terms of Use"];
        if (whiteRange.location != NSNotFound) {
            // Core Text APIs use C functions without a direct bridge to UIFont. See Apple's "Core Text Programming Guide" to learn how to configure string attributes.
            [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColor colorWithRed:0/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor range:whiteRange];
        }
        
        
        
        NSRange blueRange = [text rangeOfString:@"Privacy Policy"];
        if (blueRange.location != NSNotFound) {
            // Core Text APIs use C functions without a direct bridge to UIFont. See Apple's "Core Text Programming Guide" to learn how to configure string attributes.
            [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColor colorWithRed:0/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor range:blueRange];
        }
        
        
        return mutableAttributedString;
    }];
    NSRange whiteRangeLink = [text rangeOfString:@"Terms of Use"];
    [_lblTermsCondition addLinkToURL:[NSURL fileURLWithPath:@"https://www.saltmoney.org/Home/terms.html"] withRange:whiteRangeLink];
    
     NSRange blueRangeLink = [text rangeOfString:@"Privacy Policy"];
    [_lblTermsCondition addLinkToURL:[NSURL fileURLWithPath:@"https://www.saltmoney.org/Home/privacy.html"] withRange:blueRangeLink];
    
    [_lblTermsCondition sizeToFit];
    
}

#pragma TTTAttributes Delegate
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    
    if (![[UIApplication sharedApplication] openURL:url]) {
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
    }
}


-(void)leftDrawerButtonPress:(id)sender{
    if(btnSliderLeft.selected)
    {
        [btnSliderLeft setSelected:NO];
        [btnSliderLeft setImage:[UIImage imageNamed:@"icon-list-hover.png"] forState:UIControlStateHighlighted];
        [btnSliderLeft setImage:[UIImage imageNamed:@"icon-list-normal.png"] forState:UIControlStateNormal];
    }else
    {
        [btnSliderLeft setSelected:YES];
        [btnSliderLeft setImage:[UIImage imageNamed:@"icon-list-hover.png"] forState:UIControlStateHighlighted];
        [btnSliderLeft setImage:[UIImage imageNamed:@"icon-list-normal.png"] forState:UIControlStateNormal];
    }
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void)nowHide
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:NO completion:nil];
    
}

-(void)isPickerHidden:(BOOL)show
{
    [self.view bringSubviewToFront:_DOBYearPicker];
    [UIView beginAnimations:NULL context:nil];
    [UIView setAnimationDuration:0.50];
    CGRect frame=_DOBYearPicker.frame;
    CGRect framePlaceHolder=_DOBYearToolBar.frame;
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568)
    {
        // code for 4-inch screen
        if(show)
        {
            frame.origin.y=640;
            _DOBYearPicker.frame=frame;
            
            framePlaceHolder.origin.y = 568;
            _DOBYearToolBar.frame = framePlaceHolder;
            [self.view bringSubviewToFront:_DOBYearToolBar];
        }
        else
        {
            frame.origin.y=340;
            _DOBYearPicker.frame=frame;
            
            framePlaceHolder.origin.y = 326;
            _DOBYearToolBar.frame = framePlaceHolder;
            [self.view bringSubviewToFront:_DOBYearToolBar];
        }
    }
    else
    {
        // code for 3.5-inch screen
        if(show)
        {
            frame.origin.y=640;
            _DOBYearPicker.frame=frame;
            
            framePlaceHolder.origin.y =480;
            _DOBYearToolBar.frame = framePlaceHolder;
            [self.view bringSubviewToFront:_DOBYearToolBar];
        }
        else
        {
            frame.origin.y=265;
            _DOBYearPicker.frame=frame;
            
            framePlaceHolder.origin.y = 221;
            _DOBYearToolBar.frame = framePlaceHolder;
            [self.view bringSubviewToFront:_DOBYearToolBar];
        }
    }
    [_DOBYearToolBar setHidden:NO];
    [UIView commitAnimations];
    
}

#pragma mark - Web Service Calling
- (void) callWebService_CreateSaltSession {
    [appLoader startActivityLoader:self.view:Progressing];
    NSMutableDictionary *dicUserInfo = [objSharedData getUserInfo];
    
    NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
   
    NSMutableDictionary *tmpDic = [[NSMutableDictionary alloc] init];
    [tmpDic setValue:_txtEmail.text forKey:@"UserName"];
    [tmpDic setValue:[dicUserInfo objectForKey:@"Password"] forKey:@"Password"];
    [tmpDic setValue:@"" forKey:@"returnUrl"];
    [tmpArray addObject:tmpDic];
    
    NSError *writeError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:tmpDic options:NSJSONWritingPrettyPrinted error:&writeError];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    [_requestOnWeb callThePassedURLASynchronouslyWithRequestWithPostMethod:@"https://www.saltmoney.org/Account/LogOn" RequestString:jsonString];
}

- (void) callWebService_UpdateProfileValue {
    [self trackEvent:[WTEvent eventForScreenView:@"Update Profile" eventDescr:@"Edit existing profile." eventType:@"" contentGroup:@""]];
    NSMutableDictionary *dicUserInfo = [objSharedData getUserInfo];
    
    
    //[appLoader startActivityLoader:self.view:Progressing];
    NSMutableDictionary *tmpEmailDic = [[NSMutableDictionary alloc] init];
    [tmpEmailDic setValue:[[[dicMyProfile objectForKey:@"Emails"] objectAtIndex:0] objectForKey:@"EmailAddress"] forKey:@"EmailAddress"];
    [tmpEmailDic setValue:[NSNull null] forKey:@"Type"];
    [tmpEmailDic setValue:[NSNull null] forKey:@"TypeID"];
    [tmpEmailDic setValue:[NSNumber numberWithBool:false] forKey:@"NewRecord"];
    [tmpEmailDic setValue:[NSNumber numberWithBool:true] forKey:@"IsPrimary"];
    
    NSMutableArray *arrEmail = [[NSMutableArray alloc] init];
    [arrEmail addObject:tmpEmailDic];
    
    
    
    NSString *strFName = [dicMyProfile objectForKey:@"FirstName"];
    strFName = [strFName stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    
    //strFName = [strFName stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [strFName length])];
    
    NSString *strLName = [dicMyProfile objectForKey:@"LastName"];
    strLName = [strLName stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    //strLName = [strLName stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [strLName length])];
    
    NSMutableDictionary *tmpDic = [[NSMutableDictionary alloc] init];
    [tmpDic setValue:[dicMyProfile objectForKey:@"IndividualId"] forKey:@"IndividualId"];
    [tmpDic setValue:[dicMyProfile objectForKey:@"MembershipId"] forKey:@"MembershipId"];
    [tmpDic setValue:[dicMyProfile objectForKey:@"ActiveDirectoryKey"] forKey:@"ActiveDirectoryKey"];
    [tmpDic setValue:strFName forKey:@"FirstName"];
    [tmpDic setValue:strLName forKey:@"LastName"];
    [tmpDic setValue:[dicMyProfile objectForKey:@"DisplayName"] forKey:@"DisplayName"];
    [tmpDic setValue:[dicMyProfile objectForKey:@"PrimaryEmailKey"] forKey:@"PrimaryEmailKey"];
    [tmpDic setValue:[dicUserInfo objectForKey:@"Password"] forKey:@"Password"];
    if ([[dicUserInfo objectForKey:@"Password"] isEqualToString:_txtPassword.text]) {
          [tmpDic setValue:[NSNull null] forKey:@"NewPassword"];
    } else
          [tmpDic setValue:_txtPassword.text forKey:@"NewPassword"];
  
    [tmpDic setValue:arrEmail forKey:@"Emails"];
    [tmpDic setValue:@"" forKey:@"InvitationToken"];
    [tmpDic setValue:@"" forKey:@"ContactFrequency"];
    [tmpDic setValue:_btnYearOfBirth.titleLabel.text forKey:@"YearOfBirth"];
    [tmpDic setValue:@"6" forKey:@"Source"];
    [tmpDic setValue:[NSNumber numberWithBool:false] forKey:@"NewRecord"];
    
    
    NSError *writeError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:tmpDic options:NSJSONWritingPrettyPrinted error:&writeError];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [_requestOnWeb callThePassedURLASynchronouslyWithRequestWithPostMethod:@"https://www.saltmoney.org/Account/ManageAccount" RequestString:jsonString];
    
    
    /*NSString *strURL = [HOST_URL stringByAppendingString:[NSString stringWithFormat:UpdateProfile,API_KEY, objSharedData.str_AccessToken,_txtEmail.text,_txtPassword.text,_txtFName.text,_txtLName.text,_btnYearOfBirth.titleLabel.text]];
    NSLog(@"Request URL %@",strURL);
    [_requestOnWeb callThePassedURLASynchronouslyWithRequest:strURL RequestString:nil];*/
}

#pragma mark - WebService Delegate
- (void)webServiceHandler:(WebserviceHandler *)webHandler recievedResponse:(NSDictionary *)dicResponse
{
    
    NSLog(@"login reponse %@",dicResponse);
   
    
    if ([dicResponse objectForKey:@"Error"]) {
         [appLoader stopActivityLoader];
        [alertView displayAlertViewWithView:self.view withTitle:@"Failed!" withMessage:[ [dicResponse objectForKey:@"Error" ] objectForKey:@"message"]withButtonTitle:@"OK" withOtherButtonTitle:Nil];
    } else if ([[dicResponse objectForKey:@"Success"] integerValue] == 1) {
        dicMyProfile = [[NSMutableDictionary alloc] init];
        dicMyProfile = [dicResponse objectForKey:@"Member"];
        /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"In Session" message:[NSString stringWithFormat:@"%@",dicResponse] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        */
        [self callWebService_UpdateProfileValue];
        
    } else {
       /* UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"In Update" message:[NSString stringWithFormat:@"%@",dicResponse] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        */
         [appLoader stopActivityLoader];
        if ([[dicResponse objectForKey:@"ErrorList"] count] == 0) {
            @try {
                NSMutableDictionary *dicUserInfo = [objSharedData getUserInfo];
                
                [dicUserInfo setValue:_txtEmail.text forKey:@"Email"];
                [dicUserInfo setValue:_txtPassword.text forKey:@"Password"];
                [dicUserInfo setValue:_btnYearOfBirth.titleLabel.text forKey:@"year_of_birth"];
                [objSharedData saveUserInfo:dicUserInfo];
            }
            @catch (NSException *exception) {
                
            }
            

            [alertView displayAlertViewWithView:self.view withTitle:@"Success" withMessage:@"You have successfully updated profile." withButtonTitle:@"OK" withOtherButtonTitle:Nil];
        } else {
            @try {
                [alertView displayAlertViewWithView:self.view withTitle:@"Failed" withMessage:[[[dicResponse objectForKey:@"ErrorList"] objectAtIndex:0] objectForKey:@"DetailMessage"] withButtonTitle:@"OK" withOtherButtonTitle:Nil];
            }
            @catch (NSException *exception) {
                
            }
        }
    }
}


- (void)webServiceHandler:(WebserviceHandler *)webHandler requestFailedWithError:(NSError *)error
{
    [appLoader stopActivityLoader];
    if (!networkStatus) {
        ShowAlert(NetworkReachabilityTitle, NetworkReachabilityAlert)
    }
    // remove it after WS call
}

#pragma mark - Picker View

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    //One column
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //set number of rows
    return [_arrSourceDOBPicker count];
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_arrSourceDOBPicker objectAtIndex:row];
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"Selected Row %ld", (long)row);
    [_btnYearOfBirth setTitleEdgeInsets:UIEdgeInsetsMake(0, -450, 0, 0)];
    [_btnYearOfBirth setTitle:[_arrSourceDOBPicker objectAtIndex:row] forState:UIControlStateNormal];
}

#pragma mark - IBAction Button
- (IBAction) btnSave_ButtonPress: (id)sender {
    NSString *getEmail = [_txtEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *getPassword = [_txtPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString *getFName = [_txtFName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *getLName = [_txtFName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    BOOL isError = NO;
    
    if ([getEmail length] == 0) {
        isError = YES;
        CABasicAnimation *animationONLoginEmail = [CABasicAnimation animationWithKeyPath:@"position"];
        [animationONLoginEmail setDuration:0.15];
        [animationONLoginEmail setRepeatCount:3];
        [animationONLoginEmail setAutoreverses:YES];
        [animationONLoginEmail setFromValue:[NSValue valueWithCGPoint:
                                             CGPointMake([_txtEmail center].x - 7.0f, [_txtEmail center].y)]];
        [animationONLoginEmail setToValue:[NSValue valueWithCGPoint:
                                           CGPointMake([_txtEmail center].x + 7.0f, [_txtEmail center].y)]];
        [[_txtEmail layer] addAnimation:animationONLoginEmail forKey:@"position"];
    }
    
    if ([getPassword length] == 0 || [getPassword length] < 8) {
        isError = YES;
        CABasicAnimation *animationONLoginPassword = [CABasicAnimation animationWithKeyPath:@"position"];
        [animationONLoginPassword setDuration:0.15];
        [animationONLoginPassword setRepeatCount:3];
        [animationONLoginPassword setAutoreverses:YES];
        [animationONLoginPassword setFromValue:[NSValue valueWithCGPoint:
                                                CGPointMake([_txtPassword center].x - 7.0f, [_txtPassword center].y)]];
        [animationONLoginPassword setToValue:[NSValue valueWithCGPoint:
                                              CGPointMake([_txtPassword center].x + 7.0f, [_txtPassword center].y)]];
        [[_txtPassword layer] addAnimation:animationONLoginPassword forKey:@"position"];
    }
    
    if ([getFName length] == 0) {
        isError = YES;
        CABasicAnimation *animationONLoginEmail = [CABasicAnimation animationWithKeyPath:@"position"];
        [animationONLoginEmail setDuration:0.15];
        [animationONLoginEmail setRepeatCount:3];
        [animationONLoginEmail setAutoreverses:YES];
        [animationONLoginEmail setFromValue:[NSValue valueWithCGPoint:
                                             CGPointMake([_txtFName center].x - 7.0f, [_txtFName center].y)]];
        [animationONLoginEmail setToValue:[NSValue valueWithCGPoint:
                                           CGPointMake([_txtFName center].x + 7.0f, [_txtFName center].y)]];
        [[_txtFName layer] addAnimation:animationONLoginEmail forKey:@"position"];
    }
    
    if ([getLName length] == 0) {
        isError = YES;
        CABasicAnimation *animationONLoginPassword = [CABasicAnimation animationWithKeyPath:@"position"];
        [animationONLoginPassword setDuration:0.15];
        [animationONLoginPassword setRepeatCount:3];
        [animationONLoginPassword setAutoreverses:YES];
        [animationONLoginPassword setFromValue:[NSValue valueWithCGPoint:
                                                CGPointMake([_txtLName center].x - 7.0f, [_txtLName center].y)]];
        [animationONLoginPassword setToValue:[NSValue valueWithCGPoint:
                                              CGPointMake([_txtLName center].x + 7.0f, [_txtLName center].y)]];
        [[_txtLName layer] addAnimation:animationONLoginPassword forKey:@"position"];
    }
    
    
    if(![ValidationManager validateEmailID:_txtEmail.text]) {
        isError = YES;
        CABasicAnimation *animationONLoginEmail = [CABasicAnimation animationWithKeyPath:@"position"];
        [animationONLoginEmail setDuration:0.15];
        [animationONLoginEmail setRepeatCount:3];
        [animationONLoginEmail setAutoreverses:YES];
        [animationONLoginEmail setFromValue:[NSValue valueWithCGPoint:
                                             CGPointMake([_txtEmail center].x - 7.0f, [_txtEmail center].y)]];
        [animationONLoginEmail setToValue:[NSValue valueWithCGPoint:
                                           CGPointMake([_txtEmail center].x + 7.0f, [_txtEmail center].y)]];
        [[_txtEmail layer] addAnimation:animationONLoginEmail forKey:@"position"];
    }
    
    if(![ValidationManager validatePassword:_txtPassword.text]) {
        isError = YES;
        CABasicAnimation *animationONLoginPassword = [CABasicAnimation animationWithKeyPath:@"position"];
        [animationONLoginPassword setDuration:0.15];
        [animationONLoginPassword setRepeatCount:3];
        [animationONLoginPassword setAutoreverses:YES];
        [animationONLoginPassword setFromValue:[NSValue valueWithCGPoint:CGPointMake([_txtPassword center].x - 7.0f, [_txtPassword center].y)]];
        [animationONLoginPassword setToValue:[NSValue valueWithCGPoint:CGPointMake([_txtPassword center].x + 7.0f, [_txtPassword center].y)]];
        [[_txtPassword layer] addAnimation:animationONLoginPassword forKey:@"position"];
    }
   
    if (isError) {
        
    } else {
        [self.view endEditing:YES];
        [_objScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        [self callWebService_CreateSaltSession];
        //[self callWebService_UpdateProfileValue];
    }
}

- (IBAction)btnCloseSettings_ButtonPressed:(id)sender {
    [self.view endEditing:YES];
    [_objScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
   // [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)btnDOBYear_ButtonPressed:(id)sender {
    [self isPickerHidden:NO];
}

- (IBAction)btnDatePickerDone_ButtonPressed:(id) sender {
    
    [self isPickerHidden:YES];
}

#pragma mark UITextFeild delegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
//    if (textField == _txtPassword) {
//        [_txtFName setPlaceholder:@""];
//    }
//    if (textField == _txtSignUpPassword) {
//        [_txtSignUpPassword setPlaceholder:@""];
//    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSInteger nextTextTag = textField.tag + 1;
    
    UIResponder *nextResponder = [[[textField.superview superview] superview] viewWithTag:nextTextTag];
    
    if(nextTextTag == 5) {
        [textField endEditing:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
        
        [_objScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    } else {
        if (nextResponder) {
            [nextResponder becomeFirstResponder];
        } else {
            [textField resignFirstResponder];
        }
    }
    
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
