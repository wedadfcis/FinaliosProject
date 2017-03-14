//
//  MyNetworkDelegate.h
//  MDWProject
//
//  Created by JETS on 2/25/17.
//  Copyright (c) 2017 JETS. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MyNetworkDelegate <NSObject>

-(void) handle:(NSData*) dataRetreived :(NSString*) serviceName;

@end
