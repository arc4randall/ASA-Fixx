//
//  WebserviceHandler.m
//  MedlinxPatient
//
//  Created by Vandana Singh on 08/5/14.
//  Copyright (c) 2013 Vandana Singh. All rights reserved.
//

#import "WebserviceHandler.h"
#import "JSON.h"
#import "AFJSONRequestOperation.h"
#import "ApplicationAlertMessages.h"

@implementation WebserviceHandler

@synthesize request;
@synthesize responseData;
@synthesize delegate,str;

-(instancetype)init {
    if ( self = [super init] ) {
    }
    return self;
}

#pragma mark - NSURLConnectionDelegate methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    if(responseData==nil)
    {
        responseData=[[NSMutableData alloc]init];
    }
    [responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [appDelegate stopActivityIndicator];
    if([delegate respondsToSelector:@selector(webServiceHandler:requestFailedWithError:)])
        [delegate performSelector:@selector(webServiceHandler:requestFailedWithError:) withObject:self withObject:error];
    
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
    NSString *responseString=[[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
    NSMutableDictionary *dicResponse = [[NSMutableDictionary alloc] init];
    //NSLog(@"Response:%@",responseString);
    dicResponse=[responseString JSONValue];
    if ([dicResponse count]!=0) {
        if([delegate respondsToSelector:@selector(webServiceHandler:recievedResponse:)])
            [delegate performSelector:@selector(webServiceHandler:recievedResponse:) withObject:self withObject:dicResponse];
    } else {
      ShowAlert(@"Fixx", @"Response null, Please try again")
    }
}


#pragma mark - AFNtworking
// Create request ASynchrinously
// You will pass Method name, Method url name, and tag dictionary in below function
-(void) AFNcallThePassedURLASynchronouslyWithRequest:(NSDictionary*)valueDic withMethod:(NSString *)methodName withUrl:(NSString *)urlStr
{
    if(networkStatus)
    {
        //Use below code if you want pass argumants like HTTP function
        //for append tag
        NSMutableString *requestStr = [[NSMutableString alloc] init];
        [requestStr appendString:@"{"];
        //[requestStr appendString:[NSString stringWithFormat:@"\"%@\":{",methodName]];
        NSArray *keyArr = [valueDic allKeys];
        for (int i=0; i<[keyArr count]; i++) {
            if(i==[keyArr count]-1)
            {
                if([methodName length]>1 && [keyArr[i] isEqualToString:methodName])
                {
                    [requestStr appendString:[NSString stringWithFormat:@"\"%@\":%@",keyArr[i],valueDic[keyArr[i]]]];
                }else
                {
                    [requestStr appendString:[NSString stringWithFormat:@"\"%@\":\"%@\"",keyArr[i],valueDic[keyArr[i]]]];
                }
            }else
                if([methodName length]>1 && [keyArr[i] isEqualToString:methodName])
                {
                    [requestStr appendString:[NSString stringWithFormat:@"\"%@\":%@,",keyArr[i],valueDic[keyArr[i]]]];
                }else
                    
                {
                    [requestStr appendString:[NSString stringWithFormat:@"\"%@\":\"%@\",",keyArr[i],valueDic[keyArr[i]]]];
                }
        }
        [requestStr appendString:@"}"];
        //[requestStr appendString:@"}"];
        //for append tag
        
        NSString *UrlString;
        UrlString = [NSString stringWithFormat:@"%@%@",HOST_URL,urlStr];
        NSString *postString = [requestStr mutableCopy];
        URL_Log(UrlString, postString)
        
        str = postString;
        NSString *msgLength =[NSString stringWithFormat:@"%lu",(unsigned long)[postString length]];
        
        request=[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:UrlString] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:RequestTimeOutInterval];
        [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
        [request addValue:msgLength forHTTPHeaderField:@"Content-Length"];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody: [postString dataUsingEncoding:NSUTF8StringEncoding]];
        // NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
        //[connection start];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            if([delegate respondsToSelector:@selector(webServiceHandler:recievedResponse:)])
                [delegate performSelector:@selector(webServiceHandler:recievedResponse:) withObject:self withObject:JSON];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            NSLog(@"error: %@", [error description]);
            ShowAlert(@"Fixx", RequestFailed)
            if([delegate respondsToSelector:@selector(webServiceHandler:requestFailedWithError:)])
                [delegate performSelector:@selector(webServiceHandler:requestFailedWithError:) withObject:self withObject:error];
        }];
        [operation start];
    } else {
        [appDelegate stopActivityIndicator];
        ShowAlert(NetworkReachabilityTitle, NetworkReachabilityAlert)
    }
}

#pragma mark - Google placeAPI
-(void) callThePassedURLASynchronouslyWithRequest:(NSString *)UrlString RequestString:(NSString *)postString
{
    if(networkStatus)
    {
        str = postString;
         UrlString = [UrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        request=[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:UrlString] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:RequestTimeOutInterval];
        NSString *msgLength =[NSString stringWithFormat:@"%lu",(unsigned long)[postString length]];
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request addValue:msgLength forHTTPHeaderField:@"Content-Length"];
        [request setHTTPMethod:@"GET"];
        [request setHTTPBody: [postString dataUsingEncoding:NSUTF8StringEncoding]];
        NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
        [connection start];
    } else {
        [appDelegate stopActivityIndicator];
        ShowAlert(NetworkReachabilityTitle, NetworkReachabilityAlert)
    }
}


-(void) callThePassedURLASynchronouslyWithRequestWithPostMethod:(NSString *)UrlString RequestString:(NSString *)postString {
    str = postString;
    request=[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:UrlString] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:RequestTimeOutInterval];
    NSString *msgLength =[NSString stringWithFormat:@"%lu",(unsigned long)[postString length]];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [request addValue:@"*/*" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody: [postString dataUsingEncoding:NSUTF8StringEncoding]];
    
     NSLog(@"request string--->%@-%@", UrlString,postString);
    NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}
#pragma mark - Image Uploading
-(void)callASynchronouslyURL:(NSString *)UrlString forUploadImage:(UIImage *)originalImage withInfo:(NSDictionary *)dicInfo
{
    
    if(networkStatus)
    {
        NSData *imageNSData = UIImageJPEGRepresentation(originalImage,1.0);
        request=[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:UrlString] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:RequestTimeOutInterval];
        NSMutableString *string = [[NSMutableString alloc] init];
        [request setHTTPMethod:@"POST"];
        [request addValue:@"image/jpeg;" forHTTPHeaderField:@"Content-Type"];
        for (NSString *key in [dicInfo allKeys]) {
            [request addValue:[dicInfo valueForKey:key] forHTTPHeaderField:key];
            //[string appendFormat:[NSString stringWithFormat:@"%@ %@",[dicInfo valueForKey:key],key]];
            [string appendString:[NSString stringWithFormat:@"%@ %@",[dicInfo valueForKey:key],key]];
            
        }
        NSMutableData *body = [NSMutableData data];
        [body appendData:[NSData dataWithData: imageNSData]];
        [request setHTTPBody:body];
        
        NSString *requestPath = [[request URL] absoluteString];
        NSLog(@"request string--->%@-%@", requestPath,string);
        
        
        NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
        [connection start];
    }else
    {
        [appDelegate stopActivityIndicator];
        ShowAlert(NetworkReachabilityTitle, NetworkReachabilityAlert)
    }
}

#pragma mark -call url
//This method is used by check version api call. [Dont change it.]
/*+(NSString *) callThePassedURLSynchronously:(NSString *)UrlString
 {
 NSURL *url = [NSURL fileURLWithPath:UrlString];
 NSMutableURLRequest *req =[NSMutableURLRequest requestWithURL:url];
 [req addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
 [req setHTTPMethod:@"GET"];
 NSData *d= [NSURLConnection sendSynchronousRequest:req returningResponse:nil error:nil];
 NSString *jsonString=[[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
 return jsonString;
 }
 
 // Create request Synchronous
 // You will pass Method name, Method url name, and tag dictionary in below function
 +(NSString *) callThePassedURLSynchronouslyWithRequest:(NSDictionary*)valueDic withMethod:(NSString *)methodName withUrl:(NSString *)urlStr
 {
 //for append tag
 NSMutableString *requestStr = [[NSMutableString alloc] init];
 [requestStr appendString:@"{"];
 [requestStr appendString:[NSString stringWithFormat:@"\"%@\":{",methodName]];
 NSArray *keyArr = [valueDic allKeys];
 for (int i=0; i<[keyArr count]; i++) {
 
 [requestStr appendString:[NSString stringWithFormat:@"\"%@\":\"%@\",",[keyArr objectAtIndex:i],[valueDic objectForKey:[keyArr objectAtIndex:i]]]];
 }
 
 [requestStr appendString:@"}"];
 [requestStr appendString:@"}"];
 //for append tag
 
 NSString *UrlString =[NSString stringWithFormat:@"%@%@",URL_DOMAIN,urlStr];
 NSString *postString = [requestStr mutableCopy];
 NSURL *url = [NSURL fileURLWithPath:UrlString];
 NSMutableURLRequest *req =[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:RequestTimeOutInterval];
 NSString *msgLength =[NSString stringWithFormat:@"%d",[postString length]];
 [req addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
 [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
 [req setHTTPMethod:@"POST"];
 [req setHTTPBody: [postString dataUsingEncoding:NSUTF8StringEncoding]];
 NSData *d= [NSURLConnection sendSynchronousRequest:req returningResponse:nil error:nil];
 NSString *jsonString=[[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
 return jsonString;
 
 }
 // Create request ASynchrinously
 // You will pass Method name, Method url name, and tag dictionary in below function
 -(void) callThePassedURLASynchronouslyWithRequest:(NSDictionary*)valueDic withMethod:(NSString *)methodName withUrl:(NSString *)urlStr
 {
 if(appDelegate.networkStatus)
 {
 //for append tag
 NSMutableString *requestStr = [[NSMutableString alloc] init];
 [requestStr appendString:@"{"];
 [requestStr appendString:[NSString stringWithFormat:@"\"%@\":{",methodName]];
 NSArray *keyArr = [valueDic allKeys];
 for (int i=0; i<[keyArr count]; i++) {
 
 [requestStr appendString:[NSString stringWithFormat:@"\"%@\":\"%@\",",[keyArr objectAtIndex:i],[valueDic objectForKey:[keyArr objectAtIndex:i]]]];
 }
 
 [requestStr appendString:@"}"];
 [requestStr appendString:@"}"];
 //for append tag
 
 NSString *UrlString =[NSString stringWithFormat:@"%@%@",URL_DOMAIN,urlStr];
 NSString *postString = [requestStr mutableCopy];
 URL_Log(UrlString, postString)
 
 str = postString;
 request=[[NSMutableURLRequest alloc]initWithURL:[NSURL fileURLWithPath:UrlString] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:RequestTimeOutInterval];
 NSString *msgLength =[NSString stringWithFormat:@"%d",[postString length]];
 [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
 [request addValue:msgLength forHTTPHeaderField:@"Content-Length"];
 [request setHTTPMethod:@"POST"];
 [request setHTTPBody: [postString dataUsingEncoding:NSUTF8StringEncoding]];
 NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
 [connection start];
 }else
 {
 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Network connection error, please try later" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
 [alert show];
 }
 }
 
 
 -(void)callASynchronouslyURL:(NSString *)UrlString forUploadImage:(UIImage *)originalImage withInfo:(NSDictionary *)dicInfo
 {
 NSData *imageNSData = UIImageJPEGRepresentation(originalImage,1.0);
 
 request=[[NSMutableURLRequest alloc]initWithURL:[NSURL fileURLWithPath:UrlString] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:RequestTimeOutInterval];
 
 [request setHTTPMethod:@"POST"];
 [request addValue:@"image/jpeg;" forHTTPHeaderField:@"Content-Type"];
 
 for (NSString *key in [dicInfo allKeys]) {
 [request addValue:[dicInfo valueForKey:key] forHTTPHeaderField:key];
 }
 NSMutableData *body = [NSMutableData data];
 
 [body appendData:[NSData dataWithData: imageNSData]];
 [request setHTTPBody:body];
 
 NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
 [connection start];
 }
 -(void)cancelRequest
 {
 [appDelegate stopActivityIndicator];
 NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
 [connection cancel];
 }*/
@end
