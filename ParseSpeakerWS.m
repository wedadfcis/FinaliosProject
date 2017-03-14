//
//  ParseSpeakerWS.m
//  TestNetwork
//
//  Created by JETS on 3/1/17.
//  Copyright © 2017 JETS. All rights reserved.
//

#import "ParseSpeakerWS.h"
#import "SpeakersBean.h"

@implementation ParseSpeakerWS


-(NSMutableArray*)getAllSpeakers :(NSDictionary*)source{
    
    NSMutableArray *result=[NSMutableArray new];
    
    
    NSMutableArray *speakersArray=[source objectForKey:@"result"];
    
    for(int i=0;i<[speakersArray count];i++){
        
        SpeakersBean *obj =[SpeakersBean new];
        obj.firstName=[[speakersArray objectAtIndex:i] objectForKey:@"firstName"];
        obj.lastName=[[speakersArray objectAtIndex:i] objectForKey:@"lastName"];
        obj.idd=[[[speakersArray objectAtIndex:i] objectForKey:@"id"] intValue];
        obj.companyName=[[speakersArray objectAtIndex:i] objectForKey:@"companyName"];
        obj.title=[[speakersArray objectAtIndex:i] objectForKey:@"title"];
        obj.phone=[[speakersArray objectAtIndex:i] objectForKey:@"phone"];
        obj.mobile=[[speakersArray objectAtIndex:i] objectForKey:@"mobile"];
        obj.middleName=[[speakersArray objectAtIndex:i] objectForKey:@"middleName"];
        obj.biography=[[speakersArray objectAtIndex:i] objectForKey:@"biography"];
        NSString *gend =[NSString stringWithFormat:@"%@",[[speakersArray objectAtIndex:i] objectForKey:@"gender"]];
        obj.gender=gend;
        [result addObject:obj];
  
    }

    return result;
    
}

-(NSMutableArray*)getArrayOfSpeakersFirstName :(NSMutableArray*) source{
    
    NSMutableArray *arrayNames=[NSMutableArray new];
    
  
    for (int i=0;i<[source count];i++) {
        
        [arrayNames addObject:[[source objectAtIndex:i] objectForKey:@"firstName"]];
        
    }
    return arrayNames;
}

-(NSMutableArray*)getTitleArrayForSpeakers :(NSMutableArray*)source{
    NSMutableArray *titlesArray=[NSMutableArray new];
    for (int i=0;i<[source count];i++) {
        [titlesArray addObject:[[source objectAtIndex:i] objectForKey:@"title"]];
    }
    return titlesArray;

}
-(NSMutableArray*)getArrayOfSpeakersLastName :(NSMutableArray*)source{
    NSMutableArray *arrayNames=[NSMutableArray new];
    for (int i=0;i<[source count];i++) {
        [arrayNames addObject:[[source objectAtIndex:i] objectForKey:@"lastName"]];
    }
    return arrayNames;
}
-(NSMutableArray*)getImageArrayForSpeakers :(NSMutableArray*)source{
    NSMutableArray *arrayNames=[NSMutableArray new];
    for (int i=0;i<[source count];i++) {
        [arrayNames addObject:[[source objectAtIndex:i] objectForKey:@"imageURL"]];
    }
    return arrayNames;
}

@end
