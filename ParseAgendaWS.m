//
//  ParseAgendaWS.m
//  TestNetwork
//
//  Created by JETS on 2/28/17.
//  Copyright © 2017 JETS. All rights reserved.
//

#import "ParseAgendaWS.h"
#import "SessionBean.h"

@implementation ParseAgendaWS


-(NSMutableArray*)getAgendaArrayOfDate:(NSMutableArray*) sourceDictionary{
    
    NSMutableArray *resultDate =[NSMutableArray new];
    for(int i=0;i<[sourceDictionary count];i++){
        [resultDate addObject:[[sourceDictionary objectAtIndex:i] objectForKey:@"date"]];
    }
    return resultDate;
    
}


-(NSMutableArray*)getArrayOfSessionsFromAgnedasobject:(NSDictionary*)source{
    
    NSMutableArray *result =[source objectForKey:@"sessions"];
    return result;
}

-(NSMutableArray*)getArrayOfAgendas:(NSDictionary*) sourceDictionary{
    NSMutableArray *agendas = [sourceDictionary objectForKey:@"agendas"];
    return agendas;
}

-(NSDictionary*)getAgendaDictionaryFromArrayOfAgenda:(NSMutableArray *)source :(int)index{
    NSDictionary* result =[source objectAtIndex:index];
    return result;
}
-(NSMutableArray*) getArrayOfSessionObject :(NSMutableArray*)sessionArray{
    NSMutableArray* result=[NSMutableArray new];
    SessionBean* sessionobj =[SessionBean new];
    
    
    for(int i=0;i<[sessionArray count];i++){
        
        int idd=[[[sessionArray objectAtIndex:i] objectForKey:@"id"] intValue];
        sessionobj.idd=idd;
        sessionobj.name=[[sessionArray objectAtIndex:i] objectForKey:@"name"];
        sessionobj.session_location=[[sessionArray objectAtIndex:i] objectForKey:@"location"];
        sessionobj.descript=[[sessionArray objectAtIndex:i] objectForKey:@"description"];
        sessionobj.speakers=[[sessionArray objectAtIndex:i] objectForKey:@"speakers"];
        sessionobj.status=[[[sessionArray objectAtIndex:i] objectForKey:@"status"] intValue];
        sessionobj.startDate=[[sessionArray objectAtIndex:i] objectForKey:@"startDate"];
        sessionobj.endDate=[[sessionArray objectAtIndex:i] objectForKey:@"endDate"];
        sessionobj.sessionType=[[sessionArray objectAtIndex:i] objectForKey:@"sessionType"];
        sessionobj.liked=[[[sessionArray objectAtIndex:i] objectForKey:@"liked"] intValue];
        sessionobj.sessionTags=[[sessionArray objectAtIndex:i] objectForKey:@"sessionTags"];
        sessionobj.linked=NULL;
        
        [result addObject:sessionobj];
    }
    return result;
}

-(SessionBean*)getSessionObjectFromSessionArrayAtIndex:(int)index  :(NSMutableArray*)source{
    SessionBean* sessionobj =[SessionBean new];
    
    int idd=[[[source objectAtIndex:index] objectForKey:@"id"] intValue];
    sessionobj.idd=idd;
    sessionobj.name=[[source objectAtIndex:index] objectForKey:@"name"];
    sessionobj.session_location=[[source objectAtIndex:index] objectForKey:@"location"];
    sessionobj.descript=[[source objectAtIndex:index] objectForKey:@"description"];
    sessionobj.speakers=[[source objectAtIndex:index] objectForKey:@"speakers"];
    sessionobj.status=[[[source objectAtIndex:index] objectForKey:@"status"] intValue];
    sessionobj.startDate=[[source objectAtIndex:index] objectForKey:@"startDate"];
    sessionobj.endDate=[[source objectAtIndex:index] objectForKey:@"endDate"];
    sessionobj.sessionType=[[source objectAtIndex:index] objectForKey:@"sessionType"];
    bool var=[[[source objectAtIndex:index] objectForKey:@"liked"] boolValue];
    if(var==true){
        sessionobj.liked=1;
    }else if(var==false){
        sessionobj.liked=0;
    }
//    sessionobj.liked=[[[source objectAtIndex:index] objectForKey:@"liked"] intValue];
    sessionobj.sessionTags=[[source objectAtIndex:index] objectForKey:@"sessionTags"];
    sessionobj.linked=@"null";
    

    return sessionobj;
}


-(NSString*)getAgendaDate :(NSMutableArray*)source :(int)index{
    NSString *date =[[source objectAtIndex:index] objectForKey:@"date"];
    return date;
}

@end
