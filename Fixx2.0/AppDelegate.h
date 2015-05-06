//
//  AppDelegate.h
//  Fixx2.0
//
//  Created by vivek soni on 5/16/14.
//  Copyright (c) 2014 Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationController.h"
#import "MMDrawerController.h"
#import "MMExampleDrawerVisualStateManager.h"
#import "HomeDashboardViewController.h"
#import "LeftTabController.h"
#import "EventManager.h"

@class RVLaunchViewController;
@class AppDelegate;
@class SharedData;
@class Reachability;
extern AppDelegate *appDelegate;
extern SharedData *objSharedData;
extern BOOL networkStatus, isIOS7;
extern BOOL isUserSignUp,isLoginClick;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    //use for all type of Reachability
    Reachability* hostReach;
    Reachability* internetReach;
    Reachability* wifiReach;
    //use for all type of Reachability
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) EventManager *eventManager;
@property (strong, nonatomic) NavigationController * tabNavController;
@property (assign, nonatomic) int sectionSelect;
@property (strong, nonatomic) MMDrawerController * drawerController;
@property (strong, nonatomic) LeftTabController *objLeftTabController;
@property (strong, nonatomic) HomeDashboardViewController * objHomeDashboardViewController;
@property (strong, nonatomic) NSString *strDeviceToken;
@property (strong, nonatomic) IBOutlet NavigationController* objNavController;

- (void) updateInterfaceWithReachability: (Reachability*) curReach;
-(void)callNetwork;

#pragma mark - ActivityIndicator Methods
-(void)startActivityIndicator:(UIView *)view withText:(NSString *)text;
-(void)stopActivityIndicator;

#pragma mark - Custom Alert Methods
-(void) displayAlertView:(NSString *) errorTitle withErrorMsg:(NSString *) errorMsg;
-(void) displayAlertView:(NSString *) errorTitle withErrorMsg:(NSString *) errorMsg target:(id) tar selector:(SEL)sel;
-(void) displayAlertView:(NSString *) errorTitle withErrorMsg:(NSString *) errorMsg target:(id)tar title1:(NSString *)ttl1 title2:(NSString *)titl2;
-(IBAction)alertOkBtnPressed:(id)sender;
-(void)alertCancelBtnPressed:(id)sender;
- (void) SignUpLoginScreen;
@end
