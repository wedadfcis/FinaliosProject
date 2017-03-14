//
//  ParseLoginWs.h
//  TestNetwork
//
//  Created by JETS on 3/1/17.
//  Copyright © 2017 JETS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AttendeeBean.h"
@interface ParseLoginWs : NSObject

-(AttendeeBean*)getUserObject :(NSDictionary*)source;

@end
