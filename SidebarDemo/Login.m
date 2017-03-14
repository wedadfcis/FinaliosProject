//
//  Login.m
//  SidebarDemo
//
//  Created by JETS on 2/27/17.
//  Copyright © 2017 Appcoda. All rights reserved.
//

#import "Login.h"
#import "SWRevealViewController.h"
#import "NetworkManager.h"
#import "ParseSpeakerWS.h"
#import "ProfileUIViewController.h"
#import "DBManager.h"



//Database delete queries
NSString *deleteSpeakersTable = @"DELETE FROM SPEAKERS";
NSString *deleteAttendeesTable = @"DELETE FROM ATTENDEE";
NSString *deleteSessionsTable = @"DELETE FROM SESSIONS";
NSString *deleteExhibitorsTable = @"DELETE FROM EXHIBITORS";



@implementation Login{
    ParseSpeakerWS *speakerParseObj;
    ProfileUIViewController *profileObj;
    DBManager *dbObj;
    AttendeeBean *attend_obj;
    AttendeeBean *objAttende;
    NSUserDefaults *defaults;
}
static NSString *statusDict;

- (void)viewDidLoad
{
    [super viewDidLoad];
    defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"password"] !=nil &&[defaults objectForKey:@"username"] !=nil ){
        Login* myVC = [self.storyboard instantiateViewControllerWithIdentifier:@"sw"];
        [self presentViewController:myVC animated:YES completion:nil];
    }
    speakerParseObj=[ParseSpeakerWS new];
    profileObj=[ProfileUIViewController new];
    dbObj = [DBManager sharedInstance];
    attend_obj=[AttendeeBean new];
    objAttende =[AttendeeBean new];
}

- (IBAction)sucessLogin:(id)sender {
    
    NSString* userName =[_userNameText text];
    NSString* pass =[_passwordText text];
    
    NSString *serviceName =@"login";
    NSString* baseUrl =  [NSString stringWithFormat:@"http://www.mobiledeveloperweekend.net/service/login?userName=\%@&password=\%@",userName,pass];
    
    printf("%s",[baseUrl UTF8String]);
    [self myConnectMethod:serviceName andUrl:baseUrl];
    
}

- (IBAction)signUp:(id)sender {
    
    NSLog(@"selected");
    NSURL *url = [NSURL URLWithString:@"http://www.mobiledeveloperweekend.net/attendee/registration.htm;jsessionid=F37B47548F26EA85228965249F9F4372"];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
        
        NSLog(@"selected 555");
        
    }
    
}

-(void)myConnectMethod:(NSString*)serviceName andUrl:(NSString*)serviceUrl{
    
    NSURL *myUrl =[NSURL URLWithString:serviceUrl];
    NetworkManager *netObj =[NetworkManager new];
    [netObj setNetworkDelegate:self];
    [NetworkManager connect:myUrl:serviceName:netObj];
}

-(void) handle:(NSData*) dataRetreived :(NSString*) serviceName{
    
    if([serviceName isEqualToString:@"login"]){
        NSDictionary *myresult = [NSJSONSerialization JSONObjectWithData:dataRetreived options:0 error:nil];
        NSDictionary *resultDict =[myresult objectForKey:@"result"];
        statusDict=[myresult objectForKey:@"status"];
        NSLog(@"%@",resultDict);
        
        NSMutableArray *mobilearr=[NSMutableArray new];
        NSMutableArray *phonearr=[NSMutableArray new];
        
        mobilearr=[resultDict objectForKey:@"mobiles"];
        phonearr=[resultDict objectForKey:@"phones"];
        
        objAttende.firstName=[resultDict objectForKey:@"firstName"];
        objAttende.lastName=[resultDict objectForKey:@"lastName"];
        objAttende.code=[resultDict objectForKey:@"code"];
        objAttende.email=[resultDict objectForKey:@"email"];
        objAttende.countryName=[resultDict objectForKey:@"countryName"];
        objAttende.title=[resultDict objectForKey:@"title"];
        objAttende.companyName=[resultDict objectForKey:@"companyName"];
        objAttende.middleName=[resultDict objectForKey:@"middleName"];
        objAttende.gender=[resultDict objectForKey:@"gender"];
        objAttende.city=[resultDict objectForKey:@"city"];
        NSString *mobi=[NSString new];
        if([mobilearr count]==0){
            mobi=@"n";
            printf("mobile arr is null");
        }else{
            mobi=[mobilearr objectAtIndex:0];
        }
        NSString *phon=[NSString new];
        if([phonearr count]==0){
            phon=@"n";
        }else{
            phon=[phonearr objectAtIndex:0];
        }
        objAttende.phone=phon;
        objAttende.mobile=mobi;
        
        NSData *profileimg=[NSData dataWithContentsOfURL:[NSURL URLWithString:[resultDict objectForKey:@"imageURL"]]];
        objAttende.img=profileimg;
        
        [dbObj clearTables:@"DELETE FROM ATTENDEE"];
        [dbObj insertInAttendees:objAttende];
        if([statusDict isEqualToString:@"view.success"]){
            NSLog(@"******%s",[statusDict UTF8String]);
            Login* myVC = [self.storyboard instantiateViewControllerWithIdentifier:@"sw"];
            [defaults setObject:_userNameText.text  forKey:@"username"];
            [defaults setObject:_passwordText.text  forKey:@"password"];
            [defaults synchronize];
            [self presentViewController:myVC animated:YES completion:nil];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"error in connection"
                                                            message:@"You must be connected to the internet to use this app."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
        }
    }
}
@end
