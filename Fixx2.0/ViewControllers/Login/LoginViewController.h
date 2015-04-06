//
//  LoginViewController.h
//  Trankeytest
//
//  Created by Jaydev on 06/05/14.
//  Copyright (c) 2014 Jaydev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebserviceHandler.h"

@interface LoginViewController : UIViewController<UITextFieldDelegate,WebServiceHandlerDelegate>


@property(nonatomic,retain) IBOutlet UIScrollView *objScrollView;


@property(nonatomic,retain) IBOutlet UIButton *btnLogin;
@property(nonatomic,retain) IBOutlet UIButton *btnForgotPassword;
@property(nonatomic,retain) IBOutlet UIButton *btnFreeAccount;

@property(nonatomic,retain) IBOutlet UILabel *lblFreeAccount;
@property(nonatomic,retain) IBOutlet UILabel *lblSignInAs;

@property(nonatomic,retain) IBOutlet UITextField *txtEmailId;
@property(nonatomic,retain) IBOutlet UITextField *txtPassword;

@property(nonatomic,retain) IBOutlet UITextField *txtSignUpEmailId;
@property(nonatomic,retain) IBOutlet UITextField *txtSignUpPassword;

@property (nonatomic,retain) NSString *strCommingFrom;
@property (nonatomic,retain) WebserviceHandler *requestOnWeb;

@property (nonatomic,retain) IBOutlet UIView *viewSignInContainer;
@property (nonatomic,retain) IBOutlet UIView *viewSignUpContainer;

@end
