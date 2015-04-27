//
//  User.h
//  Zaptaview
//
//  Created by Shelesh Rawat on 14/02/13.
//  Copyright (c) 2013 Shelesh Rawat. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UserAccessTokenKey @"UserAccessTokenKey"
#define UserEmailKey @"UserEmailKey"
#define UserFBKey @"UserFaceBook"
#define UserGPlusKey @"Usergplus"
#define UserIdKey @"UserId"
#define UserFaceBookIDKey @"UserFaceBookID"
#define UserPasswordKey @"UserPassword"  //Only contains 'True/False' value. It belongs to property named isPassword.
#define UserIsPasswordExistKey @"IsPasswordExist"

@interface User : NSObject<NSCoding>

@property (nonatomic,strong) NSString * accessToken;
@property (nonatomic,strong) NSString * faceBookUser;
@property (nonatomic,strong) NSString * gplusUser;
@property (nonatomic,strong) NSString * userId;
@property (nonatomic,strong) NSString * userFaceBookID;
@property (nonatomic,strong) NSString * IsPasswordExist;

@end
