//
//  User.m
//  Zaptaview
//
//  Created by Shelesh Rawat on 14/02/13.
//  Copyright (c) 2013 Shelesh Rawat. All rights reserved.
//

#import "User.h"

@implementation User
-(id)init
{
    self=[super init];
    if(self)
    {
        self.accessToken=@"";
        self.faceBookUser=@"";
        self.UserId = @"";
        self.userFaceBookID=@"";
        self.gplusUser = @"";
        self.IsPasswordExist =@"";
    }
    return self;
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.accessToken forKey:UserAccessTokenKey];
    [encoder encodeObject:self.faceBookUser forKey:UserFBKey];
    [encoder encodeObject:self.userId forKey:UserIdKey];
    [encoder encodeObject:self.userFaceBookID forKey:UserFaceBookIDKey];
    [encoder encodeObject:self.gplusUser forKey:UserGPlusKey];
    [encoder encodeObject:self.IsPasswordExist forKey:UserIsPasswordExistKey];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        
        self.accessToken=[decoder decodeObjectForKey:UserAccessTokenKey];
        self.faceBookUser=[decoder decodeObjectForKey:UserFBKey];
        self.userId=[decoder decodeObjectForKey:UserIdKey];
        self.userFaceBookID=[decoder decodeObjectForKey:UserFaceBookIDKey];
        self.gplusUser=[decoder decodeObjectForKey:UserGPlusKey];
        self.IsPasswordExist=[decoder decodeObjectForKey:UserIsPasswordExistKey];
    }
    return self;
}
-(void)setValuesForKeysWithDictionary:(NSDictionary *)keyedValues
{
    self.accessToken=[keyedValues valueForKey:UserAccessTokenKey];
    self.faceBookUser=[keyedValues valueForKey:UserFBKey];
    self.userId=[keyedValues valueForKey:UserIdKey];
    self.userFaceBookID=[keyedValues valueForKey:UserFaceBookIDKey];
    self.gplusUser=[keyedValues valueForKey:UserGPlusKey];
    self.IsPasswordExist=[keyedValues valueForKey:UserIsPasswordExistKey];
}
#pragma mark - For SBJSON
-(id)proxyForJson
{
    NSDictionary *d=nil;
    d=[NSDictionary dictionaryWithObjectsAndKeys:
       ((self.accessToken)?self.accessToken:@""),UserAccessTokenKey,
       ((self.faceBookUser)?self.faceBookUser:@""),UserFBKey,
       ((self.userId)?self.userId:@""),UserIdKey,
       ((self.userFaceBookID)?self.userFaceBookID:@""),UserFaceBookIDKey,
       ((self.gplusUser)?self.gplusUser:@""),UserGPlusKey,
        ((self.IsPasswordExist)?self.gplusUser:@""),UserIsPasswordExistKey,
      nil];
    return d;
}
@end
