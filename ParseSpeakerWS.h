//
//  ParseSpeakerWS.h
//  TestNetwork
//
//  Created by JETS on 3/1/17.
//  Copyright © 2017 JETS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParseSpeakerWS : NSObject

-(NSMutableArray*)getArrayOfSpeakersFirstName :(NSMutableArray*)source;
-(NSMutableArray*)getArrayOfSpeakersLastName :(NSMutableArray*)source;
-(NSMutableArray*)getAllSpeakers :(NSDictionary*)source;
-(NSMutableArray*)getTitleArrayForSpeakers :(NSMutableArray*)source;
-(NSMutableArray*)getImageArrayForSpeakers :(NSMutableArray*)source;


@end
