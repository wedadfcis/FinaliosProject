//
//  Session.h
//  MDWProject
//
//  Created by JETS on 2/25/17.
//  Copyright (c) 2017 JETS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SessionBean : NSObject

@property int idd;
@property NSString *name;
@property NSString *session_location;
@property NSString* descript;
@property NSString *speakers;
@property int status;
@property NSString *startDate;
@property NSString *endDate;
@property NSString *sessionType;
@property NSString *linked;
@property NSString *sessionTags;
@property int liked;
@property int day;


@end
