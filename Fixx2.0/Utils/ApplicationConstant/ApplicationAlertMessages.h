//
//  ApplicationAlertMessages.h
//  MedlinxPatient
//
//  Created by Vandana Singh on 08/5/14.
//  Copyright (c) 2013 Vandana Singh. All rights reserved.
//

#pragma mark - All Alerts..

#define ShowAlert(title, msg) {[appDelegate displayAlertView:title withErrorMsg:msg];}

#define ShowAlertWithTarAndSel(title, msg, tar, sel) {[appDelegate displayAlertView:title withErrorMsg:msg target:tar selector:sel];}

#define ShowConfirmationAlert(title, msg, tar, btnTitle1, btnTitle2) {[appDelegate displayAlertView:title withErrorMsg:msg target:tar title1:btnTitle1 title2:btnTitle2];}

#define ShowAlertNative(title, msg)  {UIAlertView *alert=[[UIAlertView alloc]initWithTitle:title message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK",nil];[alert show];}
#define ShowAlertNativeWithTar(title, msg, tar, tag)  {UIAlertView *alert=[[UIAlertView alloc]initWithTitle:title message:msg delegate:tar cancelButtonTitle:nil otherButtonTitles:@"OK",nil];[alert setTag:tag];[alert show];}

#define BlueColor [UIColor clearColor]
#define BlueColor_Light [UIColor clearColor]

#pragma mark - Network Validation
#define Progressing @"Processing Please Wait.."
#define RequestFailed @"There is an error in network connection.\n Please try after some time."
#define NetworkReachabilityTitle @"No network connection"
#define NetworkReachabilityAlert @"Sorry, we can't currently refresh the app. Please check your internet connection."
#define TitleMessage @"Fixx!"

#define ProximaNovaSemibold   @"ProximaNova-Semibold"
#define ProximaNovaBlack @"ProximaNova-Black"
#define ProximaNovaRegular @"ProximaNova-Regular"
#define  ProximaNovaLightIt @"ProximaNova-LightIt"
#define ProximaNovaSemiboldIt @"ProximaNova-SemiboldIt"
#define ProximaNovaExtrabld @"ProximaNova-Extrabld"
#define ProximaNovaRegularIt @"ProximaNova-RegularIt"
#define ProximaNovaLight @"ProximaNova-Light"
#define ProximaNovaBold @"ProximaNova-Bold"
#define ProximaNovaBoldIt @"ProximaNova-BoldIt"
#define TRADEGOTHICLT @"Trade Gothic LT Bold Oblique"


#pragma mark - Field validation
#define BlankUsername   @"Please enter Username."
#define InvalidUsername @"Please enter valid Username."
#define BlankPassword   @"Please enter your Password."
#define LengthPassword  @"Password should have at least minimum 6 characters."
#define InvalidPassword @"Please enter valid password."
#define ConfirmPassword @"Password mismatch."
#define BlankFirstname  @"Please enter Firstname."
#define BlankLastname   @"Please enter Lastname."

#pragma mark - Alert Messages

#define LOADING                         @"Loading..."
#define PLEASE_WAIT                     @"Please Wait..."
#define UPLOADING_PIC                   @"Uploading Picture..."
#define FETCHING                        @"Fetching..."
#define AUTHENTICATING                  @"Authenticating Account..."
#define RESETTING_PASSWORD              @"Password Resetting..."
#define AUTHORIZATION                   @"Authorization..."
#define SIGNING_UP                      @"Signing Up..."
#define LOGGING_OUT                     @"Logging Out..."
#define EDITING_PROFILE                 @"Editing Profile..."
#define FETCHING_NOTIFICATIONS          @"Fetching Notifications..."
#define POSTING_CLASSIFIED              @"Posting Classified..."
#define ADDING_REVIEW                   @"Posting Review..."
#define FETCHING_MESSAGES               @"Fetching Messages..."
#define CREATING_FIXX                   @"Creating Fixx..."
#define UPDATING_FIXX                   @"Updating Fixx..."
