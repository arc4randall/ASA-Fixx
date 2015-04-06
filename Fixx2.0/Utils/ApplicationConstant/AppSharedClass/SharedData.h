//
//  RVSharedData.h
//  Renovate
//
//  Created by Vandana Singh on 9/12/13.
//  Copyright (c) 2013 Vandana Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "WebserviceHandler.h"

@interface SharedData : NSObject<WebServiceHandlerDelegate >
@property (nonatomic,strong) CLLocation *currentLocation;

@property (nonatomic,strong) id GPlusAuth;
@property (nonatomic,strong) NSMutableDictionary *dict_FbUserDetails;
@property (nonatomic,strong) NSMutableDictionary *dict_GPlusUserDetails;

@property (nonatomic,strong) NSString* str_commingFrom;
@property (nonatomic,strong) NSString* str_ideabookFilter,*strViewcm;
@property (nonatomic, assign) BOOL bool_sliderOpen;

@property (nonatomic, strong) NSString *str_AccessToken;
@property (nonatomic, strong) NSString *str_CurrentUserId;
@property (nonatomic,strong) NSString* str_DeviceToken;
@property (nonatomic,strong) NSString* str_DeviceId;
@property (nonatomic,strong) NSString* str_IsGPlusTrue;
@property (nonatomic,strong) NSString* str_IsRoomImgUploadingTrue;
@property (nonatomic, strong) NSString* str_categoryId;
@property (nonatomic, strong) NSString* str_IsComingFrmAttachGPlusTrue;
@property (nonatomic, strong) NSString* str_LoggedInUserEmail;
@property (nonatomic, strong) NSString* str_LoggedInUserPass;
@property (nonatomic, strong) NSString *strTakeTheTourOn;

@property (strong, nonatomic) User *objCurrentUser;
@property (nonatomic,assign) BOOL isLoggedin;

@property (nonatomic, strong) id btn_sender;



+(SharedData *)instance;
#pragma mark - Save/Restore methods
-(void)storeToUserdefaults;
-(void)restoreFromUserdefaults;
-(void)updateUserProfileImage:(NSString *)strUrl;
-(void)deleteUserInfo;
-(void)saveUserInfo : (NSMutableDictionary *) dicUserInfo;
-(NSMutableDictionary *)getUserInfo;
-(BOOL)uploadProfileImage :(NSMutableDictionary *)dict;
#pragma mark - Other Class methods
-(NSString *)sha1EncodedFromString:(NSString *)str;
- (NSString *) md5:(NSString *)str;
#pragma mark - convert base64encoded string
+ (NSString*)base64forData:(NSData*)theData;
@end
