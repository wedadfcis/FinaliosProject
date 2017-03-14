//
//  ParseAgendaWS.h
//  TestNetwork
//
//  Created by JETS on 2/28/17.
//  Copyright © 2017 JETS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SessionBean.h"

@interface ParseAgendaWS : NSObject



-(NSMutableArray*)getAgendaArrayOfDate:(NSMutableArray*) sourceDictionary;
-(NSMutableArray*)getArrayOfAgendas:(NSDictionary*) sourceDictionary;
-(NSMutableArray*)getArrayOfSessionsFromAgnedasobject :(NSDictionary*)source ;
-(SessionBean*)getSessionObjectFromSessionArrayAtIndex:(int)index :(NSMutableArray*)source;
-(NSString*)getAgendaDate :(NSMutableArray*)source :(int)index;
-(NSDictionary*)getAgendaDictionaryFromArrayOfAgenda :(NSMutableArray*)source :(int)index;
-(NSMutableArray*) getArrayOfSessionObject :(NSMutableArray*)sessionArray;
@end
