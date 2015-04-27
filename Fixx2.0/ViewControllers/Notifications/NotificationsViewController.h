//
//  NotificationsViewController.h
//  Fixx2.0
//
//  Created by vivek soni on 12/07/14.
//  Copyright (c) 2014 Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebserviceHandler.h"



@interface NotificationsViewController : UIViewController <WebServiceHandlerDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,retain) WebserviceHandler *requestOnWeb;
@property (nonatomic,retain) IBOutlet UITableView *tblNotificatios;
@property (nonatomic,retain) IBOutlet UIView *viewNotifications;

@property (nonatomic,retain) IBOutlet UILabel *lblNoData;

@property (nonatomic,retain) IBOutlet UISwitch *switchOne;
@property (nonatomic,retain) IBOutlet UISwitch *switchTwo;
@property (nonatomic,retain) IBOutlet UISwitch *switchThree;
@property (nonatomic,retain) IBOutlet UISwitch *switchFour;

@property (nonatomic,retain) IBOutlet UIButton *settings;

@end
