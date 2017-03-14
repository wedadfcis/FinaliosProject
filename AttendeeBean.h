//
//  AttendeeBean.h
//  ProjectDatabase
//
//  Created by JETS on 2/28/17.
//  Copyright (c) 2017 JETS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AttendeeBean : NSObject<NSCoding>


@property int idd;
@property NSString *code;
@property NSString *email;
@property NSString *firstName;
@property NSString *lastName;
@property NSString *countryName;
@property NSString *city;
@property NSString *companyName;
@property NSString *title;
@property NSString *phone;
@property NSString *mobile;
@property NSString *middleName;
@property NSString *gender;
@property NSData *img;


@end
