//
//  ForGotPasswordViewController.h
//  Trankeytest
//
//  Created by Jaydev on 08/05/14.
//  Copyright (c) 2014 Jaydev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotPasswordViewController : UIViewController<UITextFieldDelegate>
@property(nonatomic,retain) IBOutlet UITextField *txtMobileNumber;
@property(nonatomic,retain) IBOutlet UIButton *btnMobileNumberIcon;
@property(nonatomic,retain) IBOutlet UIButton *btnCountryCode;
@property(nonatomic,retain) IBOutlet UILabel *lblMobileMessage;
@property(nonatomic,retain) IBOutlet UIScrollView *scrContainer;

- (IBAction)btnCountryCode:(id)sender;
@end
