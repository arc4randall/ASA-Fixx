//
//  UpdateProfileViewController.h
//  Fixx2.0
//
//  Created by vivek soni on 12/07/14.
//  Copyright (c) 2014 Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebserviceHandler.h"
#import "TTTAttributedLabel.h"

@interface UpdateProfileViewController : UIViewController <WebServiceHandlerDelegate>


@property (nonatomic,retain) IBOutlet UITextField *txtFName;
@property (nonatomic,retain) IBOutlet UITextField *txtLName;
@property (nonatomic,retain) IBOutlet UITextField *txtEmail;
@property (nonatomic,retain) IBOutlet UITextField *txtPassword;
@property (nonatomic,retain) IBOutlet UIScrollView *objScrollView;

@property (nonatomic,retain) IBOutlet UIButton *btnYearOfBirth;

@property (nonatomic,retain) WebserviceHandler *requestOnWeb;

@property (nonatomic,retain) IBOutlet UIPickerView *DOBYearPicker;
@property (nonatomic,retain) NSMutableArray *arrSourceDOBPicker;
@property (nonatomic,retain) IBOutlet UIToolbar *DOBYearToolBar;

@property (nonatomic,retain) IBOutlet TTTAttributedLabel *lblTermsCondition;
@end
