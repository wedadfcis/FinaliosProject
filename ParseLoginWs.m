//
//  ParseLoginWs.m
//  TestNetwork
//
//  Created by JETS on 3/1/17.
//  Copyright © 2017 JETS. All rights reserved.
//

#import "ParseLoginWs.h"
#import "UserBean.h"
#import "AttendeeBean.h"
@implementation ParseLoginWs



-(AttendeeBean*)getUserObject :(NSDictionary*)source{
    AttendeeBean *userObject =[AttendeeBean new];
    
    [userObject setIdd :(int)[source objectForKey:@"id"] ];
//    [userObject setBirthDate :[source objectForKey:@"birthDate"] ];
    [userObject setCode :[source objectForKey:@"code"] ];
    
    [userObject setEmail :[source objectForKey:@"email"] ];
    [userObject setFirstName :[source objectForKey:@"firstName"] ];
    [userObject setLastName :[source objectForKey:@"lastName"] ];
    [userObject setCountryName :[source objectForKey:@"countryName"] ];
    [userObject setCompanyName :[source objectForKey:@"companyName"] ];
    [userObject setTitle :[source objectForKey:@"title"] ];
    [userObject setPhone :[source objectForKey:@"phones"] ];
    [userObject setMobile :[source objectForKey:@"mobiles"] ];
    [userObject setMiddleName :[source objectForKey:@"middleName"] ];
    [userObject setGender :[source objectForKey:@"gender"] ];
    [userObject setImg :[source objectForKey:@"imageURL"] ];
    
    
    return userObject;
}

@end
