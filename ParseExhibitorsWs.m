//
//  ParseExhibitorsWs.m
//  iOSProject
//
//  Created by JETS on 3/8/17.
//  Copyright © 2017 Appcoda. All rights reserved.
//

#import "ParseExhibitorsWs.h"
#import "ExhibitorsBean.h"

@implementation ParseExhibitorsWs






-(NSMutableArray*)getIdArr :(NSMutableArray*)source{
    NSMutableArray* returnResult=[NSMutableArray new];
    for(int i=0;i<[source count];i++){
        [returnResult addObject:[[source objectAtIndex:i] objectForKey:@"id"]];
    }
    return returnResult;
}


-(NSMutableArray*)getExhibitorsObject :(NSMutableArray*)source{
    NSMutableArray *result=[NSMutableArray new];

    for(int i=0;i<[source count];i++){
        ExhibitorsBean *exObj=[ExhibitorsBean new];
        exObj.cityName=[[source objectAtIndex:i] objectForKey:@"cityName"];
        exObj.idd=[[[source objectAtIndex:i] objectForKey:@"id"] intValue];
        exObj.email=[[source objectAtIndex:i] objectForKey:@"email"];
        exObj.companyAddress=[[source objectAtIndex:i] objectForKey:@"companyAddress"];
        exObj.countryName=[[source objectAtIndex:i] objectForKey:@"countryName"];
        exObj.companyName=[[source objectAtIndex:i] objectForKey:@"companyName"];
        exObj.companyAbout=[[source objectAtIndex:i] objectForKey:@"companyAbout"];
        exObj.fax=[[source objectAtIndex:i] objectForKey:@"fax"];
        exObj.contactName=[[source objectAtIndex:i] objectForKey:@"contactName"];
        exObj.contactTitle=[[source objectAtIndex:i] objectForKey:@"contactTitle"];
        exObj.companyUrl=[[source objectAtIndex:i] objectForKey:@"companyUrl"];
//        exObj.img=[[source objectAtIndex:i] objectForKey:@"imgURL"];
        [result addObject:exObj];
    }
    return result;
}


@end
