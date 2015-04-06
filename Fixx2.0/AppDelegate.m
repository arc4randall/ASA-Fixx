//
//  AppDelegate.m
//  Fixx2.0
//
//  Created by vivek soni on 5/16/14.
//  Copyright (c) 2014 Tech. All rights reserved.
//

#import "AppDelegate.h"
#import "Reachability.h"
#import "AlertDialogProgressView.h"
#import "GreetingViewController.h"
#import "AlertDialogView.h"
#import "LoginViewController.h"
#import "DBManager.h"
AppDelegate *appDelegate;
SharedData *objSharedData;

@interface AppDelegate()<CLLocationManagerDelegate>
{
    AlertDialogProgressView *objalertDialogProgressView;
    GreetingViewController *objGreetingViewController;
    LoginViewController *objLoginViewController;
}

@property(nonatomic,retain) AlertDialogView *alertDialogView;
@end

@implementation AppDelegate
@synthesize strDeviceToken;
BOOL networkStatus, isIOS7, isUserSignUp=NO,isLoginClick=NO;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self trackEvent:[WTEvent eventForAppLaunch:WTLaunchStyleFromHomeScreen applicationName:@"Fixx2"]];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self appSetup];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    objSharedData = [SharedData instance];
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    if([[userdefaults objectForKey:@"LoginStatus"] isEqualToString:@"YES"])
    {
        objSharedData.str_AccessToken = [userdefaults objectForKey:@"accessToken"];
        
        [self signInToHomeSuccessfully];
        
        [self.window setRootViewController:_drawerController];
    }
    else {
        objGreetingViewController = [[GreetingViewController alloc] initWithNibName:@"GreetingViewController" bundle:nil];
        self.objNavController = [[NavigationController alloc]initWithRootViewController:objGreetingViewController];
                
        [self.window setRootViewController:self.objNavController];
    }
    
    [self.window makeKeyAndVisible];
    [DBManager getSharedInstance];
    return YES;
}

-(void)nowShow
{
    //[_objNavController presentModalViewController:_drawerController animated:YES];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    application.applicationIconBadgeNumber = 0;
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self trackEvent:[WTEvent eventForAppBackground]];
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [self trackEvent:[WTEvent eventForAppForeground]];
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self trackEvent:[WTEvent eventForAppExit]];
    
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Remote Notification Delegate methods..
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateInactive) {
        //[self showUploadZaps];
    }
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString *strToken;
	strToken=[NSString stringWithFormat:@"%@",deviceToken];
    strToken=[strToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<"]];
    strToken=[strToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@">"]];
    objSharedData.str_DeviceToken=[strToken stringByReplacingOccurrencesOfString:@" " withString:@""];

}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [self trackEvent:[WTEvent eventForNotification]];
    
    NSString *alertMsg;
    NSString *badge;
    NSString *sound;
	
    if( [[userInfo objectForKey:@"aps"] objectForKey:@"alert"] != NULL) {
        alertMsg = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    } else {
		alertMsg = @"{no alert message in dictionary}";
    }
	
    if( [[userInfo objectForKey:@"aps"] objectForKey:@"badge"] != NULL) {
        badge = [[userInfo objectForKey:@"aps"] objectForKey:@"badge"];
    } else {
		badge = @"{no badge number in dictionary}";
    }
	
    if( [[userInfo objectForKey:@"aps"] objectForKey:@"sound"] != NULL)
    {
        sound = [[userInfo objectForKey:@"aps"] objectForKey:@"sound"];
    }
    else
    {    sound = @"{no sound in dictionary}";
    }
	
    // AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
	
    NSString* alert_msg = [NSString stringWithFormat:@"%@", alertMsg];
	
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fixx"
                                                    message:alert_msg
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark - Logged In Successfully
-(void)signInToHomeSuccessfully {
    objSharedData.isLoggedin = TRUE;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"YES" forKey:@"LoginStatus"];
    
    _objHomeDashboardViewController = [[HomeDashboardViewController alloc] initWithNibName:@"HomeDashboardViewController" bundle:nil];
    
    _objLeftTabController = [[LeftTabController alloc] initWithNibName:@"LeftTabController" bundle:nil];
    
    appDelegate.sectionSelect = 1;
    
    appDelegate.tabNavController = [[NavigationController alloc] initWithRootViewController:_objHomeDashboardViewController];
    
    self.drawerController = [[MMDrawerController alloc] initWithCenterViewController:appDelegate.tabNavController leftDrawerViewController:_objLeftTabController rightDrawerViewController:nil];
    
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
    
   
    NSLog(@"Start Sign In Process...");

    
    
    
    //old code start
//    objSharedData.isLoggedin = TRUE;
//    
//    _objHomeDashboardViewController = [[HomeDashboardViewController alloc] initWithNibName:@"HomeDashboardViewController" bundle:nil];
//    
//    
//    
//    _objLeftTabController = [[LeftTabController alloc] initWithNibName:@"LeftTabController" bundle:nil];
//    
//    
//    appDelegate.sectionSelect = 1;
//    appDelegate.tabNavController = [[NavigationController alloc] initWithRootViewController:_objHomeDashboardViewController];
//    
//    
//    _drawerController = [[MMDrawerController alloc]
//                             initWithCenterViewController:self.tabNavController
//                             leftDrawerViewController:_objLeftTabController
//                             rightDrawerViewController:nil];
//
//    
//    //change value of right side view appearence
//    [_drawerController setMaximumLeftDrawerWidth:240.0];
//    
//    //change value of animation type
//    [[MMExampleDrawerVisualStateManager sharedManager] setLeftDrawerAnimationType:MMDrawerAnimationTypeSlide];
//    
//  //For find touch gesture
//    [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
//    
//    [_drawerController
//     setDrawerVisualStateBlock:^(MMDrawerController *drawerController1, MMDrawerSide drawerSide, CGFloat percentVisible) {
//         MMDrawerControllerDrawerVisualStateBlock block;
//         block = [[MMExampleDrawerVisualStateManager sharedManager]
//                  drawerVisualStateBlockForDrawerSide:drawerSide];
//         if(block){
//             block(drawerController1, drawerSide, percentVisible);
//         }
//     }];
//    
//    
//    [self.objNavController presentViewController:_drawerController animated:YES completion:nil];
//    NSLog(@"Start Login process");
}

- (void) SignUpLoginScreen {
    [self.objNavController popToRootViewControllerAnimated:NO];
    [self.tabNavController popToRootViewControllerAnimated:NO];
    
    isLoginClick = YES;
    objGreetingViewController = [[GreetingViewController alloc] initWithNibName:@"GreetingViewController" bundle:nil];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 1;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = @"cube";
    transition.subtype = kCATransitionFromLeft;
    transition.delegate = self;
    
    appDelegate.objNavController = [[NavigationController alloc] initWithRootViewController:objGreetingViewController];
    [appDelegate.window.layer addAnimation:transition forKey:nil];
    [appDelegate.window setRootViewController:appDelegate.objNavController];
    [appDelegate.window makeKeyAndVisible];
    
}

#pragma mark - Custom Alert Methods
-(void) displayAlertView:(NSString *) errorTitle withErrorMsg:(NSString *) errorMsg
{
     self.alertDialogView = [AlertDialogView dialogWithView:self.window];
    [self.alertDialogView resetLayout];
    _alertDialogView.dialogStyle = UFDialogStyleDefault;
    _alertDialogView.title = errorTitle;
    _alertDialogView.str_comming = @"0";
    _alertDialogView.subtitle = errorMsg;
    [_alertDialogView showOrUpdateAnimated:YES autoHide:YES];
}
-(void) displayAlertView:(NSString *) errorTitle withErrorMsg:(NSString *) errorMsg target:(id) tar selector:(SEL)sel
{
    self.alertDialogView = [AlertDialogView dialogWithView:self.window];
    [_alertDialogView resetLayout];
    _alertDialogView.dialogStyle = UFDialogStyleDefault;
    _alertDialogView.title = errorTitle;
    _alertDialogView.str_comming = @"0";
    _alertDialogView.subtitle = errorMsg;
    [_alertDialogView addButtonWithTitle:@"Ok" target:tar selector:sel highlighted:NO buttonType:AlertDialogButtonStylePurple];
    [_alertDialogView showOrUpdateAnimated:YES];
	
}
-(void) displayAlertView:(NSString *) errorTitle withErrorMsg:(NSString *) errorMsg target:(id)tar title1:(NSString *)ttl1 title2:(NSString *)titl2
{
    self.alertDialogView = [AlertDialogView dialogWithView:self.window];
    [_alertDialogView resetLayout];
    _alertDialogView.dialogStyle = UFDialogStyleDefault;
    _alertDialogView.str_comming = @"1";
    _alertDialogView.title = errorTitle;//@"Title";
    _alertDialogView.subtitle =errorMsg;// @"Message title for alert";
    
    if(ttl1)
        [_alertDialogView addButtonWithTitle:ttl1 target:tar selector:@selector(alertOkBtnPressed:) highlighted:NO buttonType:AlertDialogButtonStyleWhite];
    if(titl2)
        [_alertDialogView addButtonWithTitle:titl2 target:tar selector:@selector(alertCancelBtnPressed:) highlighted:NO buttonType:AlertDialogButtonStyleWhite];
    
    [_alertDialogView showOrUpdateAnimated:YES];
}
-(void)alertOkBtnPressed:(id)sender{
    [_alertDialogView hideAnimated:YES];
}
-(void)alertCancelBtnPressed:(id)sender
{
    [_alertDialogView hideAnimated:YES];
}


#pragma mark - AlertDialogProgressViewDelegate methods implementation

-(void)startActivityIndicator:(UIView *)view withText:(NSString *)text{
    
    // if(_alertDialogProgressView == nil){
    if(view)
        objalertDialogProgressView = [[AlertDialogProgressView alloc] initWithView:view];
    else
        objalertDialogProgressView = [[AlertDialogProgressView alloc] initWithView:appDelegate.window];
    //}
    if(view)
        [view addSubview:objalertDialogProgressView];
    else
        [appDelegate.window addSubview:objalertDialogProgressView];
	objalertDialogProgressView.delegate = nil;
	objalertDialogProgressView.detailsLabelText = text;
    objalertDialogProgressView.taskInProgress = YES;
    [objalertDialogProgressView show:YES];
}

-(void)stopActivityIndicator{
    if (objalertDialogProgressView.taskInProgress == YES) {
        [objalertDialogProgressView hide:YES];
    }
}

-(void)appSetup
{
    //Enable Application for generation device token
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    UIDevice *device = [UIDevice currentDevice];
    NSString  *currentDeviceId = [[device identifierForVendor]UUIDString];
    objSharedData.str_DeviceId = currentDeviceId;
    
    // Set Application Statusbar style.
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleLightContent];
    
    [self callNetwork];
}

#pragma mark - Reachability notification method

- (void) updateInterfaceWithReachability: (Reachability*) curReach
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    if(status == NotReachable)
    {
        networkStatus = FALSE;
        //No internet
    }
    else if (status == ReachableViaWiFi)
    { networkStatus = TRUE;
        //WiFi
    }
    else if (status == ReachableViaWWAN)
    {
        networkStatus = TRUE;
        //3G
    }
    
    [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"RenovateNetworkNotification" object:nil]];

}

//Called by Reachability whenever status changes.
- (void) reachabilityChanged: (NSNotification* )note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
	[self updateInterfaceWithReachability: curReach];
}
-(void)callNetwork
{
    //use for all type of Reachability
    // Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the
    // method "reachabilityChanged" will be called.
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
    
    //Change the host name here to change the server your monitoring
    hostReach = [Reachability reachabilityWithHostName: @"www.apple.com"];
	[hostReach startNotifier];
	[self updateInterfaceWithReachability: hostReach];
	
    internetReach = [Reachability reachabilityForInternetConnection];
	[internetReach startNotifier];
	[self updateInterfaceWithReachability: internetReach];
    
    wifiReach = [Reachability reachabilityForLocalWiFi];
	[wifiReach startNotifier];
	[self updateInterfaceWithReachability: wifiReach];
    //use for all type of Reachability
}
@end

//#pragma mark UITextField overwrite methods to move place holder and text position
////@implementation UITextField(UITextFieldCatagory)
////// placeholder position
////- (CGRect)textRectForBounds:(CGRect)bounds {
////    return CGRectInset( bounds , 15 , 10 );
////}
////
////// text position
////- (CGRect)editingRectForBounds:(CGRect)bounds {
////    return CGRectInset( bounds , 15 , 10 );
////}
//
//@end
