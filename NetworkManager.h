//
//  NetworkManager.h
//  MDWProject
//
//  Created by JETS on 2/25/17.
//  Copyright (c) 2017 JETS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyNetworkDelegate.h"

@interface NetworkManager : NSObject <NSURLConnectionDataDelegate,NSURLConnectionDelegate>



//mutable data to retreive json object in it
@property NSMutableData *myData;
@property id<MyNetworkDelegate> networkDelegate;



//static method to make connection and its parameters are (url,service name,object from networkmanager )
+(void)connect:(NSURL*)url :(NSString*)serviceName :(NetworkManager*) networkManager;



@end
