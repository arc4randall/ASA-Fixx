//
//  NotificationsViewController.m
//  Fixx2.0
//
//  Created by vivek soni on 12/07/14.
//  Copyright (c) 2014 Tech. All rights reserved.
//

#import "NotificationsViewController.h"
#import "CustomAlertView.h"
#import "AppLoader.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"


@interface NotificationsViewController () {
    UIButton *btnRightOptions;
    CustomAlertView *alertView;
    AppLoader *appLoader;
    NSMutableArray *arrAllNotifications;
    NSMutableDictionary *dicNotificationsValues;
    UIButton *btnSliderLeft;
}

@end

@implementation NotificationsViewController

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
    [self prepareLayout];
    // Do any additional setup after loading the view from its nib.
}

- (void) prepareLayout {
    //set back button color
    
    [self.navigationItem setHidesBackButton:YES animated:YES];
    
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
    
    [_tblNotificatios setContentInset:UIEdgeInsetsMake(15, 0, 0, 0)];
    
    arrAllNotifications = [[NSMutableArray alloc] init];
    _requestOnWeb = [[WebserviceHandler alloc] init];
    _requestOnWeb.delegate = self;
    appLoader = [AppLoader initLoaderView];
    
    [self callWebService_GetNotifications];
    [self callWebService_GetNotificationsValues];
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


-(void)isNotificationsSettingsHidden:(BOOL)show
{
    
    [self.view bringSubviewToFront:_viewNotifications];
    [UIView beginAnimations:NULL context:nil];
    [UIView setAnimationDuration:0.50];
    CGRect frame=_viewNotifications.frame;
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568)
    {
        // code for 4-inch screen
        if(show) {
            frame.origin.y=640;
            _viewNotifications.frame=frame;
        } else {
            frame.origin.y=40;
            _viewNotifications.frame=frame;
        }
    } else {
        // code for 3.5-inch screen
        if(show) {
            frame.origin.y=640;
            _viewNotifications.frame=frame;
        } else {
            frame.origin.y=265;
            _viewNotifications.frame=frame;
        }
    }
    [UIView commitAnimations];
}


#pragma mark - IBAction Button
- (IBAction) rightDrawerButtonPress: (id)sender {
    [_settings setHidden:YES];
    [self isNotificationsSettingsHidden:NO];
}

- (IBAction) btnCloseSettings_ButtonPressed:(id)sender {
    [_settings setHidden:NO];
    [self isNotificationsSettingsHidden:YES];
}

- (IBAction)btnSaveSettings_ButtonPressed:(id)sender {
    [self callWebService_SetNotificationValue];
}
- (IBAction) btnBackButton_ButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - WebService Methods
- (void) callWebService_GetNotifications {
   [self trackEvent:[WTEvent eventForScreenView:@"Notifications" eventDescr:@"Get Notification List." eventType:@"" contentGroup:@""]];
    
    [appLoader startActivityLoader:self.view:Progressing];
    NSString *strURL = [HOST_URL stringByAppendingString:[NSString stringWithFormat:getNotificationList,API_KEY, objSharedData.str_AccessToken]];
    NSLog(@"Request URL %@",strURL);
    [_requestOnWeb callThePassedURLASynchronouslyWithRequest:strURL RequestString:nil];
}

- (void) callWebService_GetNotificationsValues {
      [self trackEvent:[WTEvent eventForScreenView:@"Notifications" eventDescr:@"Get Notification Settings." eventType:@"" contentGroup:@""]];
    
   // [appLoader startActivityLoader:self.view:Progressing];
    NSString *strURL = [HOST_URL stringByAppendingString:[NSString stringWithFormat:getNotificationSetting,API_KEY, objSharedData.str_AccessToken]];
    NSLog(@"Request URL %@",strURL);
    [_requestOnWeb callThePassedURLASynchronouslyWithRequest:strURL RequestString:nil];
}

- (void) callWebService_SetNotificationValue {
      [self trackEvent:[WTEvent eventForScreenView:@"Notifications" eventDescr:@"Set Notification Settings." eventType:@"" contentGroup:@""]];
    
    NSString *strSwitchOne =@"";
    if (_switchOne.isOn) {
        strSwitchOne = @"true";
        [dicNotificationsValues setValue:@"1" forKey:@"notification1"];
    } else {
        strSwitchOne = @"false";
        [dicNotificationsValues setValue:@"0" forKey:@"notification1"];
    }
    
    NSString *strSwitchTwo =@"";
    if (_switchTwo.isOn) {
        strSwitchTwo = @"true";
        [dicNotificationsValues setValue:@"1" forKey:@"notification2"];
    } else {
        strSwitchTwo = @"false";
        [dicNotificationsValues setValue:@"0" forKey:@"notification2"];
    }
    
    NSString *strSwitchThree =@"";
    if (_switchThree.isOn) {
        strSwitchThree = @"true";
        [dicNotificationsValues setValue:@"1" forKey:@"notification3"];
    } else {
        strSwitchThree = @"false";
        [dicNotificationsValues setValue:@"0" forKey:@"notification3"];
    }
    
    NSString *strSwitchFour =@"";
    if (_switchFour.isOn) {
        strSwitchFour = @"true";
        [dicNotificationsValues setValue:@"1" forKey:@"notification4"];
    } else {
        strSwitchFour = @"false";
        [dicNotificationsValues setValue:@"0" forKey:@"notification4"];
    }
    
    [appLoader startActivityLoader:self.view:Progressing];
    NSString *strURL = [HOST_URL stringByAppendingString:[NSString stringWithFormat:setNotification,API_KEY, objSharedData.str_AccessToken,strSwitchOne,strSwitchTwo,strSwitchThree,strSwitchFour]];
    NSLog(@"Request URL %@",strURL);
    [_requestOnWeb callThePassedURLASynchronouslyWithRequest:strURL RequestString:nil];
}

#pragma mark - WebService Delegate
- (void)webServiceHandler:(WebserviceHandler *)webHandler recievedResponse:(NSDictionary *)dicResponse
{
    
    NSLog(@"login reponse %@",dicResponse);
    [appLoader stopActivityLoader];
    
    if (dicResponse[@"Error"]) {
        [alertView displayAlertViewWithView:self.view withTitle:@"Failed!" withMessage:dicResponse[@"Error"][@"message"]withButtonTitle:@"OK" withOtherButtonTitle:Nil];
    } else if ([dicResponse[@"status"] integerValue] == 200 && dicResponse[@"UserMessage"]) {
        arrAllNotifications = dicResponse[@"UserMessage"];
        
        if ([arrAllNotifications count]==0) {
            [_lblNoData setHidden:NO];
        } else {
            [_lblNoData setHidden:YES];
        }
        
        [_tblNotificatios reloadData];
    } else if ([dicResponse[@"status"] integerValue] == 200 && dicResponse[@"UserNotification"])  {
        dicNotificationsValues = dicResponse[@"UserNotification"];
        
        if ([dicNotificationsValues[@"notification1"] integerValue] == 1) {
            [_switchOne setOn:YES];
        } else
            [_switchOne setOn:NO];
        
        if ([dicNotificationsValues[@"notification2"] integerValue] == 1) {
            [_switchTwo setOn:YES];
        } else
            [_switchTwo setOn:NO];
        
        if ([dicNotificationsValues[@"notification3"] integerValue] == 1) {
            [_switchThree setOn:YES];
        } else
            [_switchThree setOn:NO];
        
        if ([dicNotificationsValues[@"notification4"] integerValue] == 1) {
            [_switchFour setOn:YES];
        } else
            [_switchFour setOn:NO];
    } else {
        [self btnCloseSettings_ButtonPressed:Nil];
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

#pragma mark-<UITableView Methods>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [arrAllNotifications count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = nil;
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setBackgroundColor:[UIColor clearColor]];
    
    
    UILabel *lblTitle = [[UILabel alloc] init];
    [lblTitle setBackgroundColor:[UIColor clearColor]];
    [lblTitle setFont:[UIFont fontWithName:ProximaNovaBold size:16]];
    [lblTitle setTextColor:[UIColor whiteColor]];
    [lblTitle setFrame:CGRectMake(25, 10, 250, 25)];
    [lblTitle setTextAlignment:NSTextAlignmentLeft];
    [lblTitle setText:arrAllNotifications[indexPath.row][@"title"]];
    [cell addSubview:lblTitle];
    
    UILabel *lblSummary = [[UILabel alloc] init];
    [lblSummary setBackgroundColor:[UIColor clearColor]];
    [lblSummary setFont:[UIFont fontWithName:ProximaNovaRegular size:14]];
    [lblSummary setTextColor:[UIColor whiteColor]];
    [lblSummary setFrame:CGRectMake(25, 30, 270, 40)];
    [lblSummary setTextAlignment:NSTextAlignmentLeft];
    [lblSummary setTag:indexPath.row];
    [lblSummary setNumberOfLines:0];
    [lblSummary setText:arrAllNotifications[indexPath.row][@"message"]];
    [cell addSubview:lblSummary];
    
    
    UILabel *lblUnderLine = [[UILabel alloc] init];
    [lblUnderLine setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.60]];
    [lblUnderLine setFrame:CGRectMake(25, 70, 265, 1)];
    [cell addSubview:lblUnderLine];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    //[self upKeyboard:YES];
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
