//
//  AttendeeBean.m
//  ProjectDatabase
//
//  Created by JETS on 2/28/17.
//  Copyright (c) 2017 JETS. All rights reserved.
//

#import "AttendeeBean.h"

@implementation AttendeeBean

-(void)encodeWithCoder:(NSCoder *)aCoder{
    



    
    [aCoder encodeObject:_img forKey:@"Image"];
    [aCoder encodeObject:_city forKey:@"city"];
    [aCoder encodeObject:_code forKey:@"code"];
    [aCoder encodeObject:_email forKey:@"email"];
    [aCoder encodeObject:_phone forKey:@"phone"];
    [aCoder encodeObject:_title forKey:@"title"];
    [aCoder encodeObject:_gender forKey:@"gender"];
    [aCoder encodeObject:_mobile forKey:@"mobile"];
    
    [aCoder encodeInt:_idd forKey:@"id"];
    [aCoder encodeObject:_companyName forKey:@"companyName"];
    [aCoder encodeObject:_firstName forKey:@"firstName"];
    [aCoder encodeObject:_lastName forKey:@"lastName"];
    
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self.img=[aDecoder decodeObjectForKey:@"Image"];
    self.city=[aDecoder decodeObjectForKey:@"city"];
    self.code=[aDecoder decodeObjectForKey:@"code"];
    self.email=[aDecoder decodeObjectForKey:@"email"];
    self.phone=[aDecoder decodeObjectForKey:@"phone"];
    self.title=[aDecoder decodeObjectForKey:@"title"];
    self.gender=[aDecoder decodeObjectForKey:@"gender"];
    self.mobile=[aDecoder decodeObjectForKey:@"mobile"];
    
    self.idd=[aDecoder decodeIntForKey:@"id"];
    self.companyName=[aDecoder decodeObjectForKey:@"companyName"];
    self.firstName=[aDecoder decodeObjectForKey:@"firstName"];
    self.lastName=[aDecoder decodeObjectForKey:@"lastName"];
    

    return self;
}
@end
