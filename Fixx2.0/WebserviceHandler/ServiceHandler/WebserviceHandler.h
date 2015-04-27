//
//  WebserviceHandler.h
//  MedlinxPatient
//
//  Created by Vandana Singh on 08/5/14.
//  Copyright (c) 2013 Vandana Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WebserviceHandler;

//Methods for handle webservice Response
@protocol WebServiceHandlerDelegate <NSObject>
@optional
-(void) webServiceHandler:(WebserviceHandler *)webHandler recievedResponse:(NSDictionary *)dicResponse;
-(void) webServiceHandler:(WebserviceHandler *)webHandler requestFailedWithError:(NSError *)error;
@end

@interface WebserviceHandler : NSObject
@property (nonatomic,strong) NSMutableURLRequest *request;
@property (nonatomic,strong) NSMutableData *responseData;
@property (nonatomic,strong) id <WebServiceHandlerDelegate> delegate;
@property (nonatomic,strong) NSString *str;

#pragma mark -call url
//Methods for handle webservice Request
//+(NSString *) callThePassedURLSynchronously:(NSString *)UrlString;
//+(NSString *) callThePassedURLSynchronouslyWithRequest:(NSDictionary*)valueDic withMethod:(NSString *)methodName withUrl:(NSString *)urlStr;
//-(void) callThePassedURLASynchronouslyWithRequest:(NSDictionary*)valueDic withMethod:(NSString *)methodName withUrl:(NSString *)urlStr;
//-(void)callASynchronouslyURL:(NSString *)UrlString forUploadImage:(UIImage *)originalImage withInfo:(NSDictionary *)dicInfo;
//-(void)cancelRequest;

-(void) AFNcallThePassedURLASynchronouslyWithRequest:(NSDictionary*)valueDic withMethod:(NSString *)methodName withUrl:(NSString *)urlStr;
-(void)callASynchronouslyURL:(NSString *)UrlString forUploadImage:(UIImage *)originalImage withInfo:(NSDictionary *)dicInfo;
-(void) callThePassedURLASynchronouslyWithRequest:(NSString *)UrlString RequestString:(NSString *)postString;

-(void) callThePassedURLASynchronouslyWithRequestWithPostMethod:(NSString *)UrlString RequestString:(NSString *)postString;

@end
