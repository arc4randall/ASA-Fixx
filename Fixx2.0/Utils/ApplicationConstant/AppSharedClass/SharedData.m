//
//  RVSharedData.m
//  Renovate
//
//  Created by Vandana Singh on 9/12/13.
//  Copyright (c) 2013 Vandana Singh. All rights reserved.
//

#import "SharedData.h"
//#import "AlertDialogView.h"
#import "ApplicationAlertMessages.h"
#import "SBJsonWriter.h"
#import "UIImage+scale_resize.h"
#import <CommonCrypto/CommonDigest.h>
#include <ifaddrs.h>
#include <arpa/inet.h>

static SharedData * objAppSharedData;

@implementation SharedData
@synthesize GPlusAuth;
@synthesize dict_FbUserDetails;
@synthesize str_commingFrom;
@synthesize bool_sliderOpen;
@synthesize str_ideabookFilter;
@synthesize str_AccessToken;
@synthesize str_CurrentUserId;
@synthesize isLoggedin=_isLoggedin;
@synthesize currentLocation=_currentLocation;
@synthesize btn_sender = _btn_sender;
@synthesize str_DeviceToken = _str_DeviceToken;
@synthesize str_IsGPlusTrue = _str_IsGPlusTrue;
@synthesize str_IsRoomImgUploadingTrue = _str_IsRoomImgUploadingTrue;
@synthesize str_categoryId = _str_categoryId;
@synthesize str_IsComingFrmAttachGPlusTrue = _str_ISComingFrmAttachGPlusTrue;
@synthesize strTakeTheTourOn = _strTakeTheTourOn;
@synthesize str_DeviceId = _str_DeviceId;
-(id)init
{
    if (objAppSharedData) {
        return objAppSharedData;
    }
    else
    {
        self=[super init];
        objAppSharedData=self;
        self.objCurrentUser=[[User alloc]init];
        self.dict_FbUserDetails = [[NSMutableDictionary alloc] init];
        self.dict_GPlusUserDetails = [[NSMutableDictionary alloc] init];
        
        return self;
    }
}
+(SharedData *)instance
{
    if(objAppSharedData)
    {
        return objAppSharedData;
    }else
    {
        objAppSharedData=[[SharedData alloc]init];
        return objAppSharedData;
    }
}
#pragma mark - Save/Restore methods
-(void)storeToUserdefaults
{
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    
    if(self.isLoggedin)
    {
       
        NSDictionary *dic=[self.objCurrentUser performSelector:@selector(proxyForJson)];
        [userdefaults setObject:dic forKey:@"LoggedinUser"];
        [userdefaults setObject:((self.isLoggedin)?@"YES":@"NO") forKey:@"LoginStatus"];
        [userdefaults setObject:self.str_AccessToken forKey:@"accessToken"];
        [userdefaults setObject:@"1" forKey:@"SAVED_STATE"];
        [userdefaults setObject:self.str_CurrentUserId forKey:@"userId"];
        
        if([userdefaults synchronize])
        {}
        else
        {}
    }
    else
    {
        [userdefaults setObject:@"0" forKey:@"SAVED_STATE"];
        [userdefaults setObject:((self.isLoggedin)?@"YES":@"NO") forKey:@"LoginStatus"];
    }
}
-(void)restoreFromUserdefaults
{
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    
    if([[userdefaults objectForKey:@"SAVED_STATE"] isEqualToString:@"1"])
    {
        NSDictionary *dicUser=[NSDictionary dictionaryWithDictionary:(NSDictionary *)[userdefaults valueForKey:@"LoggedinUser"]];
        [self.objCurrentUser setValuesForKeysWithDictionary:dicUser];
        self.isLoggedin=[(NSString *)[userdefaults objectForKey:@"LoginStatus"] boolValue];
        self.str_AccessToken = [userdefaults objectForKey:@"accessToken"];
        self.str_CurrentUserId = [userdefaults objectForKey:@"userId"];
    }
}
-(void)updateUserProfileImage:(NSString *)strUrl
{
    if(strUrl==nil)return;
    
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dic=nil;
    id obj=[userdefaults objectForKey:@"USER_DATA"];
    if(obj)
        dic=[NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)[userdefaults objectForKey:@"USER_DATA"]];
    if(dic)
    {
        NSString *profileImage=[dic objectForKey:@"PROFILE_IMAGE"];
        if ([strUrl isEqualToString:profileImage]) {
        }
        else
        {
            //update url and save image into directory.
            [dic setObject:strUrl forKey:@"PROFILE_IMAGE"];
            [self saveFileWithUrl:strUrl];
        }
    }
    else
    {
        dic=[[NSMutableDictionary alloc]init];
        [dic setObject:strUrl forKey:@"PROFILE_IMAGE"];
        [self saveFileWithUrl:strUrl];
        
    }
    [userdefaults setObject:dic forKey:@"USER_DATA"];
    [userdefaults synchronize];
}
-(void)saveFileWithUrl:(NSString *)strUrl
{
    NSArray* path = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString* docPath = [path objectAtIndex:0];
    docPath = [docPath stringByAppendingPathComponent:@"ProfileImage.png"];
    UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:strUrl]]];
    NSData* imgData = UIImagePNGRepresentation(image);
    [imgData writeToFile:docPath atomically:YES];
}

-(void)saveUserInfo : (NSMutableDictionary *) dicUserInfo
{
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    [userdefaults setObject:dicUserInfo forKey:@"USER_DATA"];
    [userdefaults synchronize];
}

-(NSMutableDictionary *)getUserInfo
{
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    NSMutableDictionary *userInfo = [userdefaults objectForKey:@"USER_DATA"];
   
    return userInfo;
}


-(void)deleteUserInfo
{
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    [userdefaults setObject:nil forKey:@"USER_DATA"];
    [userdefaults synchronize];
}
#pragma mark - Webservise Methods
//For upload image
-(BOOL)uploadProfileImage :(NSMutableDictionary *)dict
{
//    if([dict valueForKey:@"RoomId"] != 0)
//    {
//    _str_categoryId = [dict valueForKey:@"RoomId"];
//    }
//    NSDictionary *valueDic=nil;
//    valueDic=[NSDictionary dictionaryWithObjectsAndKeys:@"POST",@"Method",str_AccessToken,@"access_token",@"Image",@"FileName",[dict valueForKey:@"UploadedType"],@"UploadedType",[dict valueForKey:@"Title"],@"title",[dict valueForKey:@"Description"],@"Description",[dict valueForKey:@"RoomId"],@"RoomId",[dict valueForKey:@"IdeaBookId"],@"IdeaBookId",[dict valueForKey:@"ProjectId"],@"ProjectId",[dict valueForKey:@"EventTags"],@"EventTags",nil];
//    
//    //for ActivityIndicator start
//    //[appDelegate startActivityIndicator:self.view withText:Progressing];
//    WebserviceHandler *objWebServiceHandler=[[WebserviceHandler alloc]init];
//    objWebServiceHandler.delegate = self;
//    //for NSURLConnection request
//     UIImage *requiredImage=[[dict valueForKey:@"Image"] userProfileImageForSize:CGSizeMake(320, 600)];
//    [objWebServiceHandler callASynchronouslyURL:URL_DOMAIN_ImageUpload UploadImage_Url forUploadImage:requiredImage withInfo:valueDic];
    
    return TRUE;
}

-(void)webServiceHandler:(WebserviceHandler *)webHandler recievedResponse:(NSDictionary *)dicResponse
{
    NSLog(@"dicResponse:-%@",dicResponse );
    if([[[dicResponse allKeys] objectAtIndex:0] isEqualToString:@"UploadImage"])
    {
        if([[[dicResponse objectForKey:@"UploadImage"] objectForKey:@"Status"] integerValue] != 0)
        {
            NSLog(@"image:-%@",[[dicResponse objectForKey:@"UploadImage"] objectForKey:@"Data"]);
            [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"ImageUploadedSuccessfully" object:nil]];

        }
    }else
    {
         //ShowAlert(@"",@"")
    }
}
-(void) webServiceHandler:(WebserviceHandler *)webHandler requestFailedWithError:(NSError *)error
{
    //[app stopActivityLoader];
    if (!networkStatus) {
        ShowAlert(NetworkReachabilityTitle, NetworkReachabilityAlert)
    }
    //remove it after WS call
}
#pragma mark - Other Class methods
-(NSString *)sha1EncodedFromString:(NSString *)str
{
    const char *s = [str cStringUsingEncoding:NSASCIIStringEncoding];
    NSData *keyData = [NSData dataWithBytes:s length:strlen(s)];
    
    // This is the destination
    uint8_t digest[CC_SHA1_DIGEST_LENGTH] = {0};
    // This one function does an unkeyed SHA1 hash of your hash data
    CC_SHA1(keyData.bytes, keyData.length, digest);
    
    // Now convert to NSData structure to make it usable again
    NSData *out = [NSData dataWithBytes:digest length:19];
    // description converts to hex but puts <> around it and spaces every 4 bytes
    NSString *hash = [out description];
    hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];
    return hash;
}
- (NSString *) md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result ); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
#pragma mark - convert base64encoded string for images
+ (NSString*)base64forData:(NSData*)theData {
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

@end