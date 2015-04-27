//
//  GreetingViewController.m
//  Fixx2.0
//
//  Created by Randall Spence on 3/3/15.
//  Copyright (c) 2015 Tech. All rights reserved.
//

#import "GreetingViewController.h"
#import "MMDrawerController.h"
#import "CustomAlertView.h"
#import "MMExampleDrawerVisualStateManager.h"
#import "LeftTabController.h"
#import "AppLoader.h"
#import "ValidationManager.h"
#import "HomeDashboardViewController.h"
#import "NavigationController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface GreetingViewController () <UIGestureRecognizerDelegate, FBSDKLoginButtonDelegate> {
    HomeDashboardViewController* objHomeDashboardViewController;
    CustomAlertView* alertView;
    LeftTabController* objLeftTabController;
    AppLoader* appLoader;
}

@property (strong,nonatomic) MMDrawerController* drawerController;
@end

@implementation GreetingViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //Custom Initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    //Prepare Layout
    self.button = [[FBSDKLoginButton alloc] init];
    _button.center = self.view.center;
    _button.delegate = self;
    [self.view addSubview:_button];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    UIImage* logo = [[UIImage alloc] init];
    logo = [UIImage imageNamed:@"Signin_Logo"];
    self.logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth * 0.25, screenHeight / 8, screenWidth / 2, screenHeight * 0.25)];
    self.logoImageView.image = logo;
    
    [self.logoImageView setImage:[UIImage imageNamed:@"Fixx5"]];
    self.logoImageView.opaque = NO;
    self.logoImageView.userInteractionEnabled = YES;
    [self.view addSubview:self.logoImageView];
    
    self.txtEmailID.frame = CGRectMake(screenWidth * 0.25, ((screenHeight / 16) * 7), screenWidth / 2, screenHeight / 16);
    self.txtPassword.frame= CGRectMake(screenWidth * 0.25, ((screenHeight / 16) * 8), screenWidth / 2, screenHeight / 16);
    
    NSLog(@"IMAGE: %@",self.logoImageView);
    alertView = [CustomAlertView initAlertView];
    self.navigationController.navigationBar.hidden = YES;
    
    appLoader = [AppLoader initLoaderView];
    
    self.requestOnWeb = [[WebserviceHandler alloc] init];
    self.requestOnWeb.delegate = self;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [appDelegate.tabNavController setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)callTheSignInWebService
{
    NSString* strDeviceToken = @"";
    if ([objSharedData.str_DeviceToken length] == 0 || objSharedData.str_DeviceToken == nil) {
        UIDevice* device = [UIDevice currentDevice];
        strDeviceToken = [[device identifierForVendor]UUIDString];
        strDeviceToken = [strDeviceToken stringByReplacingOccurrencesOfString:@"-" withString:@""];
        strDeviceToken = [strDeviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    } else {
        strDeviceToken = objSharedData.str_DeviceToken;
    }
    [self trackEvent:[WTEvent eventForScreenView:@"Sign In" eventDescr:@"Existing User Sign in." eventType:@"" contentGroup:@""]];
    
    [appLoader startActivityLoader:self.view:Progressing];
    
    NSString* strURL = [HOST_URL stringByAppendingString:[NSString stringWithFormat:SignIn_User,API_KEY, self.txtEmailID.text, self.txtPassword.text,strDeviceToken,@"I"]];
    NSLog(@"USERNAME: %@ PASSWORD: %@",self.txtEmailID.text,self.txtPassword.text);
    [self.requestOnWeb callThePassedURLASynchronouslyWithRequest:strURL RequestString:nil];
    
}

-(void)signInToHomeSuccessfully
{
    objSharedData.isLoggedin = TRUE;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"YES" forKey:@"LoginStatus"];
    
    objHomeDashboardViewController = [[HomeDashboardViewController alloc] initWithNibName:@"HomeDashboardViewController" bundle:nil];
    
    objLeftTabController = [[LeftTabController alloc] initWithNibName:@"LeftTabController" bundle:nil];
    
    appDelegate.sectionSelect = 1;
    
    appDelegate.tabNavController = [[NavigationController alloc] initWithRootViewController:objHomeDashboardViewController];
    
    self.drawerController = [[MMDrawerController alloc] initWithCenterViewController:appDelegate.tabNavController leftDrawerViewController:objLeftTabController rightDrawerViewController:nil];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    [self.drawerController setMaximumLeftDrawerWidth:(screenWidth * 0.75)];
    
    [[MMExampleDrawerVisualStateManager sharedManager] setLeftDrawerAnimationType:MMDrawerAnimationTypeSlide];
    
    [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    [self.drawerController setDrawerVisualStateBlock:^(MMDrawerController* drawerController1, MMDrawerSide drawerSide, CGFloat percentVisible) {
        MMDrawerControllerDrawerVisualStateBlock block;
        block = [[MMExampleDrawerVisualStateManager sharedManager] drawerVisualStateBlockForDrawerSide:drawerSide];
        if (block) {
            block(drawerController1, drawerSide, percentVisible);
        }
    }];
    
    [self.navigationController presentViewController:self.drawerController animated:YES completion:nil];
    NSLog(@"Start Sign In Process...");
}

-(IBAction)btn_LoginClick:(id)sender
{
    NSString* getEmail = [self.txtEmailID.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString* getPassword = [self.txtPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    //[self loginButton:self->loginButton didCompleteWithResult:result error:error];
    
    
    BOOL isError = NO;
    
    if ([getEmail length] == 0 || ![ValidationManager validateEmailID:getEmail]) {
        isError = YES;
        CABasicAnimation *animationOnLoginEmail = [CABasicAnimation animationWithKeyPath:@"position"];
        [animationOnLoginEmail setDuration:0.15];
        [animationOnLoginEmail setRepeatCount:3];
        [animationOnLoginEmail setAutoreverses:YES];
        [animationOnLoginEmail setFromValue:[NSValue valueWithCGPoint: CGPointMake([self.txtEmailID center].x - 7.0f, [self.txtEmailID center].y)]];
        [[self.txtEmailID layer] addAnimation:animationOnLoginEmail forKey:@"position"];
    }
    if ([getPassword length] < 6 || ![ValidationManager validatePassword:getPassword]) {
        isError = YES;
        CABasicAnimation *animationOnLoginPassword = [CABasicAnimation animationWithKeyPath:@"position"];
        [animationOnLoginPassword setDuration:0.15];
        [animationOnLoginPassword setRepeatCount:3];
        [animationOnLoginPassword setAutoreverses:YES];
        [animationOnLoginPassword setFromValue:[NSValue valueWithCGPoint: CGPointMake([self.txtPassword center].x - 7.0f, [self.txtPassword center].y)]];
        [[self.txtPassword layer] addAnimation:animationOnLoginPassword forKey:@"position"];
    }
    if (isError) {
        //Throw Alert?
    } else {
        [self.view endEditing:YES];
        [self callTheSignInWebService];
    }
}

#pragma mark - Webservice
-(void)webServiceHandler:(WebserviceHandler *)webHandler recievedResponse:(NSDictionary *)dicResponse
{
    NSLog(@"Login Response: %@",dicResponse);
    [appLoader stopActivityLoader];
    if ([dicResponse[@"status"] integerValue] == 200) {
        if (dicResponse[@"token"] == [NSNull null]) {
            [alertView displayAlertViewWithView:self.view withTitle:@"Failed!" withMessage:@"Unable to authenticate token for your session." withButtonTitle:@"OK" withOtherButtonTitle:Nil];
        } else {
        objSharedData.str_AccessToken = dicResponse[@"token"];
            objSharedData.isLoggedin = TRUE;
            isUserSignUp = NO;
            objSharedData.str_AccessToken = dicResponse[@"token"];
            objSharedData.str_LoggedInUserEmail = dicResponse[@"user"][@"Email"];
            objSharedData.str_LoggedInUserPass = dicResponse[@"user"][@"Password"];
            [objSharedData storeToUserdefaults];
        
        [objSharedData saveUserInfo:dicResponse[@"user"]];
        [self signInToHomeSuccessfully];
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.txtEmailID resignFirstResponder];
    [self.txtPassword resignFirstResponder];
}

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error
{
    NSLog(@"Result: %@",result);
    if (!error){
        NSLog(@"FB LOGIN COMPLETED");
        [self signInToHomeSuccessfully];
    }
}

- (void) loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{
    NSLog(@"YOU ARE OUT");
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
