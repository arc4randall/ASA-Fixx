//
//  LoginViewController.m
//  Trankeytest
//
//  Created by Jaydev on 06/05/14.
//  Copyright (c) 2014 Jaydev. All rights reserved.
//

#import "LoginViewController.h"
#import "ValidationManager.h"
#import "ForgotPasswordViewController.h"
#import "MMDrawerController.h"
#import "LeftTabController.h"
#import "MMExampleDrawerVisualStateManager.h"
#import "HomeDashboardViewController.h"
#import "AppLoader.h"
#import "CustomAlertView.h"

@interface LoginViewController () <UIGestureRecognizerDelegate>
{
    int countofPasswordString;
    int isEmailValid;
    int isPasswordVaild;
    ForgotPasswordViewController *objForgotPasswordViewController;
    HomeDashboardViewController *objHomeDashboardViewController;
    AppLoader *appLoader;
    CustomAlertView *customAlert;
}

@property (nonatomic,retain)  LeftTabController *objLeftTabController;
@property (strong, nonatomic) MMDrawerController * drawerController;


@end

@implementation LoginViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    // Do any additional setup after loading the view from its nib.
     [self prepareLayout];
}

- (void) viewDidAppear:(BOOL)animated {
    if (isLoginClick) {
        isLoginClick = NO;
        [self performSelector:@selector(btnFreeSaltAccount_ButtonClick:) withObject:nil afterDelay:0.8];
    }
}
- (void)viewDidUnload {
    [self setTxtEmailId:nil];
    [self setTxtPassword:nil];
    [self setObjScrollView:nil];
    [self setBtnForgotPassword:nil];
    [self setBtnLogin:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark custom methods

-(void)prepareLayout
{
    [appDelegate.tabNavController setNavigationBarHidden:YES animated:YES];
    [self.navigationItem setHidesBackButton:YES];
    
    //Sign IN Fields
    NSAttributedString *strEmail = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:ProximaNovaRegular size:16.0f] }];
    [_txtEmailId setAttributedPlaceholder:strEmail];
    
    [_txtEmailId setFont:[UIFont fontWithName:ProximaNovaRegular size:16.0f]];
    [_txtEmailId setTextColor:[UIColor whiteColor]];

    NSAttributedString *strPassword = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:ProximaNovaRegular size:16.0f] }];
    
    [_txtPassword setAttributedPlaceholder:strPassword];
    [_txtPassword setFont:[UIFont fontWithName:ProximaNovaRegular size:16.0f]];
    [_txtPassword setTextColor:[UIColor whiteColor]];
    
   
    //Sign Up Field
    NSAttributedString *strSignUpEmail = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:ProximaNovaRegular size:16.0f] }];
    [_txtSignUpEmailId setAttributedPlaceholder:strSignUpEmail];
    
    [_txtSignUpEmailId setFont:[UIFont fontWithName:ProximaNovaRegular size:16.0f]];
    [_txtSignUpEmailId setTextColor:[UIColor whiteColor]];
    
    NSAttributedString *strSignUpPassword = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:ProximaNovaRegular size:16.0f] }];
    
    [_txtSignUpPassword setAttributedPlaceholder:strSignUpPassword];
    [_txtSignUpPassword setFont:[UIFont fontWithName:ProximaNovaRegular size:16.0f]];
    [_txtSignUpPassword setTextColor:[UIColor whiteColor]];
    
    
    
    [_lblFreeAccount setFont:[UIFont fontWithName:ProximaNovaRegular size:26.0]];
    [_lblSignInAs setFont:[UIFont fontWithName:ProximaNovaRegular size:18.0]];
    
    _requestOnWeb = [[WebserviceHandler alloc] init];
    _requestOnWeb.delegate=self;
    
    appLoader = [AppLoader initLoaderView];
    customAlert = [CustomAlertView initAlertView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endViewEditing)];
    tapGesture.numberOfTapsRequired=1;
    tapGesture.numberOfTouchesRequired=1;
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
}

- (void) endViewEditing {
    [self.view endEditing:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    [_objScrollView setContentOffset:CGPointMake(0,0) animated:YES];
}

#pragma mark IBACTION Button
- (IBAction)btnFreeSaltAccount_ButtonClick:(id)sender {
    if ([_btnFreeAccount isSelected]) {
        [UIView beginAnimations:@"fadeInBgView" context:NULL];
        [UIView setAnimationDuration:.3];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(changeTextNow)];
        _lblFreeAccount.alpha = 0.0f;
        [UIView commitAnimations];
        
        
        [_btnFreeAccount setSelected:NO];
        [UIView animateWithDuration:0.5 animations:^{
            _viewSignInContainer.frame = CGRectMake(320, 274, 320, _viewSignInContainer.frame.size.height);
            _viewSignUpContainer.frame = CGRectMake(0, 274, 320, _viewSignUpContainer.frame.size.height);
        }];
    } else {
        [UIView beginAnimations:@"fadeInBgView" context:NULL];
        [UIView setAnimationDuration:.3];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(changeTextNow)];
        _lblFreeAccount.alpha = 0.0f;
        [UIView commitAnimations];
        
       
         [_btnFreeAccount setSelected:YES];
        [UIView animateWithDuration:0.5 animations:^{
            _viewSignUpContainer.frame = CGRectMake(-320, 274, 320, _viewSignUpContainer.frame.size.height);
            _viewSignInContainer.frame = CGRectMake(0, 274, 320, _viewSignInContainer.frame.size.height);
            
        }];
    }
   
}

- (void) changeTextNow {
    [UIView beginAnimations:@"fadeInBgView" context:NULL];
    [UIView setAnimationDuration:.3];
    _lblFreeAccount.alpha = 1.0f;
    if (![_btnFreeAccount isSelected]) {
        [_lblFreeAccount setText:@"Sign in as a SALT member"];
    } else
        [_lblFreeAccount setText:@"Claim your Free SALT account"];
    
    [UIView commitAnimations];
}

-(IBAction)btn_LoginClick:(id)sender {
    
    UIButton *btnClick = (UIButton *) sender;
    
    switch (btnClick.tag) {
        case 1: { //Sign In Process
            NSString *getEmail = [_txtEmailId.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSString *getPassword = [_txtPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            BOOL isError = NO;
            
            if ([getEmail length] == 0) {
                isError = YES;
                CABasicAnimation *animationONLoginEmail = [CABasicAnimation animationWithKeyPath:@"position"];
                [animationONLoginEmail setDuration:0.15];
                [animationONLoginEmail setRepeatCount:3];
                [animationONLoginEmail setAutoreverses:YES];
                [animationONLoginEmail setFromValue:[NSValue valueWithCGPoint:
                                                     CGPointMake([_txtEmailId center].x - 7.0f, [_txtEmailId center].y)]];
                [animationONLoginEmail setToValue:[NSValue valueWithCGPoint:
                                                   CGPointMake([_txtEmailId center].x + 7.0f, [_txtEmailId center].y)]];
                [[_txtEmailId layer] addAnimation:animationONLoginEmail forKey:@"position"];
            }
            
            if ([getPassword length] == 0 || [getPassword length] < 6) {
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
            
            if(![ValidationManager validateEmailID:_txtEmailId.text]) {
                isError = YES;
                CABasicAnimation *animationONLoginEmail = [CABasicAnimation animationWithKeyPath:@"position"];
                [animationONLoginEmail setDuration:0.15];
                [animationONLoginEmail setRepeatCount:3];
                [animationONLoginEmail setAutoreverses:YES];
                [animationONLoginEmail setFromValue:[NSValue valueWithCGPoint:
                                                     CGPointMake([_txtEmailId center].x - 7.0f, [_txtEmailId center].y)]];
                [animationONLoginEmail setToValue:[NSValue valueWithCGPoint:
                                                   CGPointMake([_txtEmailId center].x + 7.0f, [_txtEmailId center].y)]];
                [[_txtEmailId layer] addAnimation:animationONLoginEmail forKey:@"position"];
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
                [self callTheSignInWebService];
            }
        }
            
            break;
        case 2: { //Sign Up Process
            NSString *getEmail = [_txtSignUpEmailId.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSString *getPassword = [_txtSignUpPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            BOOL isError = NO;
            
            if ([getEmail length] == 0) {
                isError = YES;
                CABasicAnimation *animationONLoginEmail = [CABasicAnimation animationWithKeyPath:@"position"];
                [animationONLoginEmail setDuration:0.15];
                [animationONLoginEmail setRepeatCount:3];
                [animationONLoginEmail setAutoreverses:YES];
                [animationONLoginEmail setFromValue:[NSValue valueWithCGPoint:
                                                     CGPointMake([_txtSignUpEmailId center].x - 7.0f, [_txtSignUpEmailId center].y)]];
                [animationONLoginEmail setToValue:[NSValue valueWithCGPoint:
                                                   CGPointMake([_txtSignUpEmailId center].x + 7.0f, [_txtSignUpEmailId center].y)]];
                [[_txtSignUpEmailId layer] addAnimation:animationONLoginEmail forKey:@"position"];
            }
            
            if ([getPassword length] == 0 || [getPassword length] < 6) {
                isError = YES;
                CABasicAnimation *animationONLoginPassword = [CABasicAnimation animationWithKeyPath:@"position"];
                [animationONLoginPassword setDuration:0.15];
                [animationONLoginPassword setRepeatCount:3];
                [animationONLoginPassword setAutoreverses:YES];
                [animationONLoginPassword setFromValue:[NSValue valueWithCGPoint:
                                                        CGPointMake([_txtSignUpPassword center].x - 7.0f, [_txtSignUpPassword center].y)]];
                [animationONLoginPassword setToValue:[NSValue valueWithCGPoint:
                                                      CGPointMake([_txtSignUpPassword center].x + 7.0f, [_txtSignUpPassword center].y)]];
                [[_txtSignUpPassword layer] addAnimation:animationONLoginPassword forKey:@"position"];
            }
            
            if(![ValidationManager validateEmailID:_txtSignUpEmailId.text]) {
                isError = YES;
                CABasicAnimation *animationONLoginEmail = [CABasicAnimation animationWithKeyPath:@"position"];
                [animationONLoginEmail setDuration:0.15];
                [animationONLoginEmail setRepeatCount:3];
                [animationONLoginEmail setAutoreverses:YES];
                [animationONLoginEmail setFromValue:[NSValue valueWithCGPoint:
                                                     CGPointMake([_txtSignUpEmailId center].x - 7.0f, [_txtSignUpEmailId center].y)]];
                [animationONLoginEmail setToValue:[NSValue valueWithCGPoint:
                                                   CGPointMake([_txtSignUpEmailId center].x + 7.0f, [_txtSignUpEmailId center].y)]];
                [[_txtSignUpEmailId layer] addAnimation:animationONLoginEmail forKey:@"position"];
            }
            
            if(![ValidationManager validatePassword:_txtSignUpPassword.text]) {
                isError = YES;
                CABasicAnimation *animationONLoginPassword = [CABasicAnimation animationWithKeyPath:@"position"];
                [animationONLoginPassword setDuration:0.15];
                [animationONLoginPassword setRepeatCount:3];
                [animationONLoginPassword setAutoreverses:YES];
                [animationONLoginPassword setFromValue:[NSValue valueWithCGPoint:CGPointMake([_txtSignUpPassword center].x - 7.0f, [_txtSignUpPassword center].y)]];
                [animationONLoginPassword setToValue:[NSValue valueWithCGPoint:CGPointMake([_txtSignUpPassword center].x + 7.0f, [_txtSignUpPassword center].y)]];
                [[_txtSignUpPassword layer] addAnimation:animationONLoginPassword forKey:@"position"];
            }
            
            if (isError) {
                
            } else {
                [self.view endEditing:YES];
                [_objScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
                [self callTheSignUpWebService];
            }
        }
        default:
            break;
    }
}


-(IBAction)btnForgotPassword:(id)sender
{
    objForgotPasswordViewController=[[ForgotPasswordViewController alloc] init];
    [self.navigationController pushViewController:objForgotPasswordViewController animated:YES];
    objForgotPasswordViewController=nil;
}

-(void)btnBackClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Other Web Service Method
- (void) callTheSignInWebService {
        NSString *strDeviceToken = @"";
    #if TARGET_IPHONE_SIMULATOR
        if ([objSharedData.str_DeviceToken length]==0) {
            //objSharedData.str_DeviceToken = @"7d642adfa023ba8f9b98d08ae29eabf34a84c19a52a693bc5195a4c12e796637";
            strDeviceToken = @"7d642adfa023ba8f9b98d08ae29eabf34a84c19a52a693bc5195a4c12e796637";
        }
    #else
        // Device
        if ([objSharedData.str_DeviceToken length]==0) {
            strDeviceToken = @"";
        } else {
            strDeviceToken = objSharedData.str_DeviceToken;
        }
        
    #endif
    
    
    [appLoader startActivityLoader:self.view:Progressing];
    
    NSString *strURL = [HOST_URL stringByAppendingString:[NSString stringWithFormat:SignIn_User,API_KEY, _txtEmailId.text, _txtPassword.text,strDeviceToken,@"I"]];
    NSLog(@"Request URL %@",strURL);
    [_requestOnWeb callThePassedURLASynchronouslyWithRequest:strURL RequestString:nil];
    
}

- (void) callTheSignUpWebService {
    
        NSString *strDeviceToken = @"";
    #if TARGET_IPHONE_SIMULATOR
        if ([objSharedData.str_DeviceToken length]==0) {
           // objSharedData.str_DeviceToken = @"7d642adfa023ba8f9b98d08ae29eabf34a84c19a52a693bc5195a4c12e796637";
            strDeviceToken = @"7d642adfa023ba8f9b98d08ae29eabf34a84c19a52a693bc5195a4c12e796637";
        }
    #else
        // Device
        if ([objSharedData.str_DeviceToken length]==0) {
            strDeviceToken = @"";
        } else {
            strDeviceToken = objSharedData.str_DeviceToken;
        }
        
    #endif
    
    [appLoader startActivityLoader:self.view:Progressing];
    
    NSString *strURL = [HOST_URL stringByAppendingString:[NSString stringWithFormat:SignUp_User,API_KEY, _txtSignUpEmailId.text, _txtSignUpPassword.text,strDeviceToken,@"I",@"",@""]];
    NSLog(@"Request URL %@",strURL);
    [_requestOnWeb callThePassedURLASynchronouslyWithRequest:strURL RequestString:nil];
    
}

-(void)signInSuccessfully {
    objSharedData.isLoggedin = TRUE;
    
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    [userdefaults setObject:@"YES" forKey:@"LoginStatus"];
    
   
    
   //objHomeDashboardViewController = [[HomeDashboardViewController alloc] initWithNibName:@"HomeDashboardViewController" bundle:nil];
    
   // objOnboardExpense = [[OnboardExpenseViewController alloc] initWithNibName:@"OnboardExpenseViewController" bundle:nil];
  
    self.objLeftTabController = [[LeftTabController alloc] initWithNibName:@"LeftTabController" bundle:nil];
    
    appDelegate.sectionSelect = 1;
    //appDelegate.tabNavController = [[NavigationController alloc] initWithRootViewController:objOnboardExpense];
    
    self.drawerController = [[MMDrawerController alloc]
                             initWithCenterViewController:appDelegate.tabNavController
                             leftDrawerViewController:self.objLeftTabController
                             rightDrawerViewController:nil];
    
    //change value of right side view appearence
    [self.drawerController setMaximumLeftDrawerWidth:240.0];
    
    
    //change value of animation type
    [[MMExampleDrawerVisualStateManager sharedManager] setLeftDrawerAnimationType:MMDrawerAnimationTypeSlide];
    
    //For find touch gesture
    //[self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    [self.drawerController
     setDrawerVisualStateBlock:^(MMDrawerController *drawerController1, MMDrawerSide drawerSide, CGFloat percentVisible) {
         MMDrawerControllerDrawerVisualStateBlock block;
         block = [[MMExampleDrawerVisualStateManager sharedManager]
                  drawerVisualStateBlockForDrawerSide:drawerSide];
         if(block){
             block(drawerController1, drawerSide, percentVisible);
         }
     }];
    
    [self.navigationController presentViewController:self.drawerController animated:YES completion:nil];
    
}

-(void)signInToHomeSuccessfully {
    objSharedData.isLoggedin = TRUE;
    
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    [userdefaults setObject:@"YES" forKey:@"LoginStatus"];
    
    objHomeDashboardViewController = [[HomeDashboardViewController alloc] initWithNibName:@"HomeDashboardViewController" bundle:nil];

    
    self.objLeftTabController = [[LeftTabController alloc] initWithNibName:@"LeftTabController" bundle:nil];
    
    appDelegate.sectionSelect = 1;
    appDelegate.tabNavController = [[NavigationController alloc] initWithRootViewController:objHomeDashboardViewController];
    
    self.drawerController = [[MMDrawerController alloc]
                             initWithCenterViewController:appDelegate.tabNavController
                             leftDrawerViewController:self.objLeftTabController
                             rightDrawerViewController:nil];
    
    //change value of right side view appearence
    [self.drawerController setMaximumLeftDrawerWidth:240.0];
    
    
    //change value of animation type
    [[MMExampleDrawerVisualStateManager sharedManager] setLeftDrawerAnimationType:MMDrawerAnimationTypeSlide];
    
    //For find touch gesture
    //[self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    [self.drawerController
     setDrawerVisualStateBlock:^(MMDrawerController *drawerController1, MMDrawerSide drawerSide, CGFloat percentVisible) {
         MMDrawerControllerDrawerVisualStateBlock block;
         block = [[MMExampleDrawerVisualStateManager sharedManager]
                  drawerVisualStateBlockForDrawerSide:drawerSide];
         if(block){
             block(drawerController1, drawerSide, percentVisible);
         }
     }];
    
    [self.navigationController presentViewController:self.drawerController animated:YES completion:nil];
    NSLog(@"Start Login process");
}

#pragma mark - Webservice
- (void)webServiceHandler:(WebserviceHandler *)webHandler recievedResponse:(NSDictionary *)dicResponse
{
    
    NSLog(@"login reponse %@",dicResponse);
    [appLoader stopActivityLoader];
    if ([_btnFreeAccount isSelected]) { //SignIn
        if (dicResponse[@"Error"]) {
             [customAlert displayAlertViewWithView:self.view withTitle:@"Sign-In!" withMessage:dicResponse[@"Error"][@"message"] withButtonTitle:@"OK" withOtherButtonTitle:Nil];
        } else if ([dicResponse[@"status"] integerValue] == 200) {
            if (dicResponse[@"token"] == [NSNull null]) {
                [customAlert displayAlertViewWithView:self.view withTitle:@"Failed!" withMessage:@"Unable to authenticate token for your session." withButtonTitle:@"OK" withOtherButtonTitle:Nil];
            } else {
                objSharedData.isLoggedin = TRUE;
                isUserSignUp = NO;
                objSharedData.str_AccessToken = dicResponse[@"token"];
                objSharedData.str_LoggedInUserEmail = dicResponse[@"user"][@"Email"];
                objSharedData.str_LoggedInUserPass =
                dicResponse[@"user"][@"Password"];
                [objSharedData storeToUserdefaults];
                [self signInToHomeSuccessfully];
            }
        }
    } else { //SignUp
        if (dicResponse[@"Error"]) {
            [customAlert displayAlertViewWithView:self.view withTitle:@"Sign-Up" withMessage:dicResponse[@"Error"][@"message"] withButtonTitle:@"OK" withOtherButtonTitle:Nil];
        } else if ([dicResponse[@"status"] integerValue] == 200) {
            if (dicResponse[@"token"] == [NSNull null]) {
                [customAlert displayAlertViewWithView:self.view withTitle:@"Failed!" withMessage:@"Unable to authenticate token for your session." withButtonTitle:@"OK" withOtherButtonTitle:Nil];
            } else {
                objSharedData.isLoggedin = TRUE;
                isUserSignUp = YES;
                objSharedData.str_AccessToken = dicResponse[@"token"];
                objSharedData.str_LoggedInUserEmail = dicResponse[@"user"][@"Email"];
                objSharedData.str_LoggedInUserPass = dicResponse[@"user"][@"Password"];
                [objSharedData storeToUserdefaults];
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                if ([[userDefault objectForKey:@"isExpenseCreated"] isEqualToString:@"Yes"]) {
                     [self signInToHomeSuccessfully];
                } else
                    [self signInSuccessfully];
                
            }
        }
    }
   
}


- (void)webServiceHandler:(WebserviceHandler *)webHandler requestFailedWithError:(NSError *)error
{
    [appLoader stopActivityLoader];
    if (!networkStatus) {
        ShowAlert(NetworkReachabilityTitle, NetworkReachabilityAlert)
    }    // remove it after WS call
}


#pragma mark UITextFeild delegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == _txtPassword) {
        [_txtPassword setPlaceholder:@""];
    }
    if (textField == _txtSignUpPassword) {
         [_txtSignUpPassword setPlaceholder:@""];
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    int nextTextTag = textField.tag + 1;
    
    UIResponder *nextResponder = [textField.superview viewWithTag:nextTextTag];
    
    if(nextTextTag == 2) {
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

@end
