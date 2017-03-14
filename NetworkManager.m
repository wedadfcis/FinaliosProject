//
//  NetworkManager.m
//  MDWProject
//
//  Created by JETS on 2/25/17.
//  Copyright (c) 2017 JETS. All rights reserved.
//

#import "NetworkManager.h"

static NSString* myServiceName;

@implementation NetworkManager


+(void)connect:(NSURL *)url :(NSString *)serviceName :(NetworkManager *)networkManager{
    myServiceName =serviceName;
    NSURLRequest *myRequest = [NSURLRequest requestWithURL:url];
    NSURLConnection *myConnection =[[NSURLConnection alloc] initWithRequest:myRequest delegate:networkManager];
    [myConnection start];
}


-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    _myData =[NSMutableData new];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [_myData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [_networkDelegate handle:_myData :myServiceName];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    printf("Error");
}



@end
