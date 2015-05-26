//
//  LeftTabController.m
//  MedlinxPatient
//
//  Created by Vandana Singh on 08/5/14.
//  Copyright (c) 2013 Vandana Singh. All rights reserved.
//

#import "LeftTabController.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import <QuartzCore/QuartzCore.h>
#import "OnboardIncomeViewController.h"
#import "HomeDashboardViewController.h"
#import "GreetingViewController.h"
#import "SettingsViewController.h"
#import "AppLoader.h"
#import "WebserviceHandler.h"
#import "DBManager.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface LeftTabController () <WebServiceHandlerDelegate>
{
    OnboardIncomeViewController *objIncomeViewController;
    HomeDashboardViewController *objHomeDashboardViewController;
    GreetingViewController *objGreetingViewController;
    SettingsViewController *objSettingsViewController;
    AppLoader *appLoader;
    WebserviceHandler *requestOnWeb;
    
    
    NSIndexPath *lastIndexPath;
    NSIndexPath *hoverIndexPath;
    UIImageView*imageView;
    BOOL isOpenCompleted;
    id tempSender;

}
@property (nonatomic,retain) NSArray *arrMenuLogoImgName, *arrSelectedImgName, *arrName;
@end

@implementation LeftTabController

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
    [_tblMainMenuOption setSeparatorInset:UIEdgeInsetsZero];
    
    // Do any additional setup after loading the view from its nib.
    isOpenCompleted = YES;
    
    //remove after demo
    self.arrSelectedImgName = [[NSArray alloc] init];
    
    NSString *strSelectedImgName = @"rooms-hover.png,idea-book-hover.png,settings-hover.png";
    self.arrSelectedImgName = [strSelectedImgName componentsSeparatedByString:@","];
    
    self.arrName = [[NSArray alloc] init];
    NSString *strName = @" Home, Income, Expense, Settings, Logout";
    
    self.arrName = [strName componentsSeparatedByString:@","];
    
    [self.tblMainMenuOption setSeparatorColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"separator.jpg"]]];
    
    objSharedData = [SharedData instance];
    appLoader = [AppLoader initLoaderView];
    requestOnWeb = [[WebserviceHandler alloc] init];
    requestOnWeb.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}
#pragma mark - UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrName count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kSourceCell_ID = @"SourceCell_ID";
    UITableViewCell *cell;
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSourceCell_ID] ;
         cell.backgroundColor = [UIColor clearColor];
        
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *titileview=[[UILabel alloc]init];
        [titileview setFrame:CGRectMake(50, 7, 150, 35)];
        [titileview setTextColor:[UIColor whiteColor]];
        [titileview setFont:[UIFont fontWithName:ProximaNovaRegular size:17.0f]];
        [titileview setTextAlignment:NSTextAlignmentRight];
        [titileview setTag:2];
        [titileview setBackgroundColor:[UIColor clearColor]];
        [titileview setTextColor:[UIColor whiteColor]];
        [cell.contentView addSubview:titileview];
        titileview = nil;
        
        if (indexPath.row == 6) {
            UILabel *lblLine = [[UILabel alloc] initWithFrame:CGRectMake(50, 52, 150, 1)];
            [lblLine setBackgroundColor:[UIColor whiteColor]];
            [cell.contentView addSubview:lblLine];
        }
    }
    
   // UIImageView *imageViewIconCopy = (UIImageView *)[cell.contentView viewWithTag:1];
    UILabel *titileviewCopy = (UILabel *)[cell.contentView viewWithTag:2];
    if(indexPath.row == 0)
        [titileviewCopy setTextColor:[UIColor whiteColor]];
    else
        [titileviewCopy setTextColor:[UIColor whiteColor]];

    [titileviewCopy setText:(self.arrName)[indexPath.row]];
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 6) {
        return 60;
    }else
    return 48;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    lastIndexPath = indexPath;
    NSArray *arrCells = [tableView visibleCells];
    int i = 0;
    for(UITableViewCell *cel in arrCells)
    {
        [cel setBackgroundColor:[UIColor clearColor]];
        
        if(i == 0)
        {
            UIView *temp =(UIView *)[ cel viewWithTag:10002];
            
            [temp removeFromSuperview];
        }
        i++;
    }
    UITableViewCell *myTemp = [tableView cellForRowAtIndexPath:indexPath];
    myTemp.backgroundColor = [UIColor colorWithRed:(0.0f/255.0f) green:(0.0f/255.0f) blue:(0.0f/255.0f) alpha:1.0f];
 
    if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPhone) {
        [UIView transitionWithView:_tblMainMenuOption
                          duration:0.80
                           options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionAllowAnimatedContent
                        animations:^{
                            
                            for (UITableViewCell *cell in _tblMainMenuOption.visibleCells)
                            {
                                UILabel *lbl = (UILabel *)[cell viewWithTag:2];
                                lbl.textColor=[UIColor clearColor];
                            }
                        }
                        completion:nil];
        [self performSelector:@selector(nowPushToController:) withObject:indexPath afterDelay:0.18];
    }else
    {
        [self nowPushToController:indexPath];
    }
}

#pragma mark - other methods
-(void)nowPushToController:(NSIndexPath*)index
{
    //For Remove navigation subview
    for(UIView* view in appDelegate.tabNavController.navigationBar.subviews)
    {
        if ([view isKindOfClass:[UIButton class]])
        {
            [view removeFromSuperview];
        }
        
    }
    [UIView transitionWithView:_tblMainMenuOption
                      duration:0.80
                       options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionAllowAnimatedContent
                    animations:^{
                        
                        for (UITableViewCell *cell in _tblMainMenuOption.visibleCells)
                        {
                            UILabel *lbl = (UILabel *)[cell viewWithTag:2];
                            lbl.textColor=[UIColor grayColor];
                        }
                        UITableViewCell *celltemp = [_tblMainMenuOption cellForRowAtIndexPath:index];
                        UILabel *lbl = (UILabel *)[celltemp viewWithTag:2];
                        lbl.textColor=[UIColor whiteColor];

                    }
                    completion:nil];
    
     [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    
    if(index.row == 0 && appDelegate.sectionSelect != 0) {
        NSLog(@"Home Button Pressed");
        [self BtnHome_ButtonAction:nil];
    } else if (index.row == 1 && appDelegate.sectionSelect != 1) {
        NSLog(@"Income Button Pressed");
       [self BtnIncome_ButtonAction:nil];
    } else if(index.row == 2 && appDelegate.sectionSelect != 2) {
        NSLog(@"Expense Button Pressed");
        [self BtnExpense_ButtonAction:nil];
    } else if (index.row == 3 && appDelegate.sectionSelect != 3) {
        NSLog(@"Settings Button Pressed");
        [self btnSettings_ButtonAction:nil];
    }  else if(index.row == 4 && appDelegate.sectionSelect != 4) {
        NSLog(@"Logout Button Pressed");
        [self BtnLogout_ButtonAction:nil];
    }
}

-(void)hideNow
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    [UIView transitionWithView:_tblMainMenuOption
                      duration:0.80
                       options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionAllowAnimatedContent
                    animations:^{
                        for (UITableViewCell *cell in _tblMainMenuOption.visibleCells)
                        {
                            UILabel *lbl = (UILabel *)[cell viewWithTag:2];
                            lbl.textColor=[UIColor clearColor];
                        }
                    }
                    completion:nil];
    isOpenCompleted = YES;
}
- (void)BtnHome_ButtonAction:(id)sender
{
    //For Home tab navigation
    appDelegate.sectionSelect = 0;
    
    objHomeDashboardViewController = [[ HomeDashboardViewController alloc] initWithNibName:@"HomeDashboardViewController" bundle:nil];
    
    [appDelegate.tabNavController popToRootViewControllerAnimated:NO];
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[appDelegate.tabNavController viewControllers]];
    viewControllers[0] = objHomeDashboardViewController;
    [appDelegate.tabNavController setViewControllers:viewControllers];
    objHomeDashboardViewController.incomeDictionary = [[DBManager getSharedInstance]returnAllByType:@"income"];
    objHomeDashboardViewController.expenseDictionary = [[DBManager getSharedInstance]returnAllByType:@"expense"];
}

- (void)BtnIncome_ButtonAction:(id)sender
{
    //For Ideabook tab navigation
    appDelegate.sectionSelect= 1;
    
    objIncomeViewController = [[OnboardIncomeViewController alloc] initAsExpenseController:NO];
   
    [appDelegate.tabNavController popToRootViewControllerAnimated:NO];
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[appDelegate.tabNavController viewControllers]];
    viewControllers[0] = objIncomeViewController;
    [appDelegate.tabNavController setViewControllers:viewControllers];
    objIncomeViewController.incomeExpenseDictionary = [[DBManager getSharedInstance]returnAllByType:@"income"];
}

- (void)BtnExpense_ButtonAction:(id)sender
{
    //For Rooms tab navigation
    appDelegate.sectionSelect= 2;
    
    objIncomeViewController = [[OnboardIncomeViewController alloc] initAsExpenseController:YES];
    
    [appDelegate.tabNavController popToRootViewControllerAnimated:NO];
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[appDelegate.tabNavController viewControllers]];
    viewControllers[0] = objIncomeViewController;
    [appDelegate.tabNavController setViewControllers:viewControllers];
    objIncomeViewController.incomeExpenseDictionary = [[DBManager getSharedInstance]returnAllByType:@"expense"];
}

- (void) btnSettings_ButtonAction:(id)sender {
    
    appDelegate.sectionSelect= 3;
    
    objSettingsViewController = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    
    [appDelegate.tabNavController popToRootViewControllerAnimated:NO];
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[appDelegate.tabNavController viewControllers]];
    viewControllers[0] = objSettingsViewController;
    [appDelegate.tabNavController setViewControllers:viewControllers];
}

- (void) BtnLogout_ButtonAction:(id)sender {
    [self trackEvent:[WTEvent eventForScreenView:@"Logout" eventDescr:@"Logout From Application" eventType:@"" contentGroup:@""]];
    
    [appLoader startActivityLoader:self.view:LOGGING_OUT];
    
    NSString *strURL = [HOST_URL stringByAppendingString:[NSString stringWithFormat:Logout_User,API_KEY, objSharedData.str_AccessToken]];
    [requestOnWeb callThePassedURLASynchronouslyWithRequest:strURL RequestString:nil];
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"NO" forKey:@"LoginStatus"];
    [FBSDKAccessToken setCurrentAccessToken:nil];
    
}

#pragma mark - Webservice
- (void)webServiceHandler:(WebserviceHandler *)webHandler recievedResponse:(NSDictionary *)dicResponse
{
    
    NSLog(@"logout reponse %@",dicResponse);
    [appLoader stopActivityLoader];
    if ([dicResponse[@"status"] integerValue] == 200) {
        appDelegate.sectionSelect= 10;
        
        objSharedData.isLoggedin = NO;
        NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
        [userdefaults setObject:@"0" forKey:@"SAVED_STATE"];
        [userdefaults setObject:@"NO" forKey:@"LoginStatus"];
        [userdefaults setObject:@"" forKey:@"accessToken"];
        [userdefaults setObject:@"" forKey:@"userId"];
    
        objSharedData.str_LoggedInUserPass = @"";
        objSharedData.str_LoggedInUserEmail = @"";
        
        objSharedData.str_AccessToken = @"";
        objSharedData.dict_FbUserDetails = [[NSMutableDictionary alloc] init];
        objSharedData.dict_GPlusUserDetails = [[NSMutableDictionary alloc] init];
        objSharedData.objCurrentUser.accessToken = @"";
        objSharedData.str_CurrentUserId = @"";
        objSharedData.str_categoryId = @"";
        
        
        objGreetingViewController = [[GreetingViewController alloc] initWithNibName:@"GreetingViewController" bundle:nil];
        
        CATransition *transition = [CATransition animation];
        transition.duration = 0.9;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = @"cube";
        transition.subtype = kCATransitionFromLeft;
        transition.delegate = self;
        
        appDelegate.tabNavController = [[NavigationController alloc] initWithRootViewController:objGreetingViewController];
        [appDelegate.window.layer addAnimation:transition forKey:nil];
        [appDelegate.window setRootViewController:appDelegate.tabNavController];
        [appDelegate.window makeKeyAndVisible];
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

#pragma mark - slider button and animation
-(IBAction)btn_sliderClickedAction:(id)sender
{
    [self animateTheSwipeButton:sender];
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
-(void)animateTheSwipeButton:(id)sender
{
    objSharedData.btn_sender = sender;
    UIButton *btn=(UIButton *)sender;
    tempSender=sender;
    CABasicAnimation *animation=[CABasicAnimation animation];
    animation.keyPath=@"transform";
    animation.fromValue=[NSValue valueWithCATransform3D:CATransform3DIdentity];
    CATransform3D transform;
    if(!objSharedData.bool_sliderOpen)
        transform=CATransform3DRotate(CATransform3DIdentity,M_PI_2, 0, 0, 1);
    else
        transform=CATransform3DRotate(CATransform3DIdentity,-M_PI_2, 0, 0, 1);
    
    animation.toValue=[NSValue valueWithCATransform3D:transform];
    animation.duration=1;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeBoth;
    animation.repeatCount=0;
    animation.duration=0.30f;
    animation.autoreverses=NO;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.delegate=self;
    [btn.layer addAnimation:animation forKey:@"animateLayer"];
    
    [UIView transitionWithView:_tblMainMenuOption
                      duration:0.25
                       options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionAllowAnimatedContent
                    animations:^{
                        
                        for (UITableViewCell *cell in _tblMainMenuOption.visibleCells)
                        {
                            UILabel *lbl = (UILabel *)[cell viewWithTag:2];
                            lbl.textColor=[UIColor grayColor];
                        }
                    }
                    completion:nil];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSIndexPath* rowToReload;// = [NSIndexPath indexPathForRow:6 inSection:0];
    NSMutableArray *arrIndexPaths=[[NSMutableArray alloc]init];
    for(int i=0;i<[_arrMenuLogoImgName count];i++)
    {
        rowToReload= [NSIndexPath indexPathForRow:i inSection:0];
        [arrIndexPaths addObject:rowToReload];
    }
	
    UIButton *btn=(UIButton *)tempSender;
    [btn.layer removeAnimationForKey:@"animateLayer"];
	
    if(!objSharedData.bool_sliderOpen)
    {
        [btn setImage:[UIImage imageNamed:@"icon-list-normal.png"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"icon-list-normal.png"] forState:UIControlStateHighlighted];
        [btn setImage:[UIImage imageNamed:@"icon-list-normal.png"] forState:UIControlStateSelected];
        
        [UIView transitionWithView:_tblMainMenuOption
                          duration:0.25
                           options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionAllowAnimatedContent
                        animations:^{
                            
                            for (UITableViewCell *cell in _tblMainMenuOption.visibleCells)
                            {
                                UILabel *lbl = (UILabel *)[cell viewWithTag:2];
                                lbl.textColor=[UIColor clearColor];
                            }
                        }
                        completion:nil];
    }
    else if(objSharedData.bool_sliderOpen)
    {
        [btn setImage:[UIImage imageNamed:@"icon-three-line.png"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"icon-three-line.png"] forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:@"icon-three-line.png"] forState:UIControlStateHighlighted];
		
        [UIView transitionWithView:_tblMainMenuOption
                          duration:0.25
                           options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionAllowAnimatedContent
                        animations:^{
                            
                            for (UITableViewCell *cell in _tblMainMenuOption.visibleCells)
                            {
                                UILabel *lbl = (UILabel *)[cell viewWithTag:2];
                                lbl.textColor=[UIColor grayColor];
                                NSIndexPath *indexPath = [_tblMainMenuOption indexPathForCell:cell];
                                if(appDelegate.sectionSelect-1 == indexPath.row)
                                        lbl.textColor=[UIColor whiteColor];
                            }
                        }
                        completion:nil];
    }
    tempSender=nil;
    
}
@end
