//
//  ViewController.m
//  SidebarDemo
//
//  Created by Simon on 28/6/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "MainViewController.h"
#import "SWRevealViewController.h"
#import "SessionDetailed.h"
#import "NetworkManager.h"
#import "ParseAgendaWS.h"
#import "SessionBean.h"
#import "ParseLoginWs.h"
#import "ParseSpeakerWS.h"
#import "UserBean.h"
#import "DBManager.h"
#import "UIImageView+AFNetworking.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"

@interface MainViewController ()

@end

@implementation MainViewController{
    
    
    NSString *firstdayDate,*seconddayDate,*thirddayDate;
    
    int flag;
    //    *****************************
    ParseAgendaWS *myobjParser;
    ParseLoginWs *loginParseObj;
    ParseSpeakerWS *speakerParseObj;
    NSString *service_Name;
    NSString *url;
    //    *****************************
    
    
    
    NSMutableArray *allDaysSessions;
    
    NSMutableArray* firstDaySession;
    NSMutableArray* secondDaySession;
    NSMutableArray* thirdDaySession;
    
    NSMutableArray *sess_status;
    NSMutableArray *sess_status1;
    NSMutableArray *sess_status2;
    
    NSMutableArray *arr;
    
    
    
    NSMutableArray *stat_to_view;
    NSMutableArray *name_to_view;
    NSMutableArray *location_to_view;
    NSMutableArray *startDate_to_view;
    NSMutableArray *endDate_to_view;
    
    //    *****************************
    NSMutableArray *startTimeArray;
    NSMutableArray *startTimeArray1;
    NSMutableArray *startTimeArray2;
    //    *****************************
    NSMutableArray *endTimeArray;
    NSMutableArray *endTimeArray1;
    NSMutableArray *endTimeArray2;
    //    *****************************
    NSMutableArray *namesArray;
    NSMutableArray *namesArray1;
    NSMutableArray *namesArray2;
    //    *****************************
    NSMutableArray *locationsArray;
    NSMutableArray *locationsArray1;
    NSMutableArray *locationsArray2;
    
    DBManager *dbObj;
    SessionBean *sessionObj;
    //    *****************************
    NSDictionary *agenda1;
    NSDictionary *agenda2 ;
    NSDictionary *agenda3;
    //    *****************************
    NSMutableArray *sessionArray1;
    NSMutableArray *sessionArray2;
    NSMutableArray *sessionArray3;
    
    NSMutableArray *date_to_show;
    
    NSString *html;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor purpleColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(getLatestLoans)
                  forControlEvents:UIControlEventValueChanged];
    
    
    [self.mytableView addSubview:_refreshControl];
    
    [self.view addSubview:HUD];
    [HUD showAnimated:YES];
    flag=0;
    arr=[NSMutableArray new];
    html=[NSString new];
    namesArray =[NSMutableArray new];
    namesArray1 =[NSMutableArray new];
    namesArray2 =[NSMutableArray new];
    
    name_to_view=[NSMutableArray new];
    stat_to_view=[NSMutableArray new];
    location_to_view=[NSMutableArray new];
    startDate_to_view=[NSMutableArray new];
    endDate_to_view=[NSMutableArray new];
    date_to_show=[NSMutableArray new];
    
    sess_status =[NSMutableArray new];
    sess_status1=[NSMutableArray new];
    sess_status2=[NSMutableArray new];
    
    firstDaySession =[NSMutableArray new];
    secondDaySession=[NSMutableArray new];
    thirdDaySession=[NSMutableArray new];
    
    locationsArray =[NSMutableArray new];
    locationsArray1 =[NSMutableArray new];
    locationsArray2 =[NSMutableArray new];
    
    startTimeArray=[NSMutableArray new];
    startTimeArray1=[NSMutableArray new];
    startTimeArray2=[NSMutableArray new];
    
    endTimeArray=[NSMutableArray new];
    endTimeArray1=[NSMutableArray new];
    endTimeArray2=[NSMutableArray new];
    
    agenda1=[NSDictionary new];
    agenda2=[NSDictionary new];
    agenda3=[NSDictionary new];
    sessionArray1=[NSMutableArray new];
    sessionArray2=[NSMutableArray new];
    sessionArray3=[NSMutableArray new];
    
    myobjParser=[ParseAgendaWS new];
    loginParseObj=[ParseLoginWs new];
    speakerParseObj =[ParseSpeakerWS new];
    
    allDaysSessions=[NSMutableArray new];
    
    dbObj = [DBManager sharedInstance];
    sessionObj =[SessionBean new];
    
    service_Name =@"getAgenda";
    url =@"http://www.mobiledeveloperweekend.net/service/getSessions?userName=eng.medhat.cs.h@gmail.com";
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"\n***********************Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        if ([[AFNetworkReachabilityManager sharedManager] isReachable]) {
            NSLog(@"***********Online***********");
            [self myConnectMethod:service_Name andUrl:url];
        }else{
            [date_to_show removeAllObjects];
            allDaysSessions=[dbObj selectFromSessions];
            for(int i=0;i<[allDaysSessions count];i++){
                
                SessionBean *s_obj =[SessionBean new];
                s_obj=[allDaysSessions objectAtIndex:i];
                [name_to_view addObject:s_obj.name];
                [location_to_view addObject:s_obj.session_location];
                [startDate_to_view addObject:s_obj.startDate];
                [endDate_to_view addObject:s_obj.endDate];
                [stat_to_view addObject:s_obj.sessionType];
                
                if(s_obj.day==13){
                    [firstDaySession addObject:s_obj];
                    [date_to_show addObject:[NSString stringWithFormat:@"%d",s_obj.day]];
                }else if(s_obj.day==14){
                    [secondDaySession addObject:s_obj];
                    [date_to_show addObject:[NSString stringWithFormat:@"%d",s_obj.day]];
                }else if(s_obj.day==15){
                    [thirdDaySession addObject:s_obj];
                    [date_to_show addObject:[NSString stringWithFormat:@"%d",s_obj.day]];
                }
            }
            [self.mytableView reloadData];
            [HUD hideAnimated:YES];
        }
        
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    
    _sidebarButton.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [name_to_view count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a"];
    NSString* date =[startDate_to_view objectAtIndex:indexPath.row];
    NSString* enddate =[endDate_to_view objectAtIndex:indexPath.row];
    NSDate *s_date = [NSDate dateWithTimeIntervalSince1970:[date longLongValue]/1000];
    NSDate *e_date = [NSDate dateWithTimeIntervalSince1970:[enddate longLongValue]/1000];
    NSString *s_date_Str=   [formatter stringFromDate: s_date];
    NSString *space =@" - ";
    NSString *e_date_Str=   [formatter stringFromDate: e_date];
    NSString *alltime= [[s_date_Str stringByAppendingString:space] stringByAppendingString:e_date_Str ];
    //    NSLog(@"My Date is :%@",alltime);
    
    
    // UILabel *
    UILabel *firstname =(UILabel*)[cell viewWithTag:1];
    UILabel *secondJob =[cell viewWithTag:2];
    UIImageView *myimage =[cell viewWithTag:3];
    UILabel* timeLabel=[cell viewWithTag:4];
    UILabel* daylbl =[cell viewWithTag:8];
    
    [daylbl setText:[date_to_show objectAtIndex:indexPath.row]];
    
    if([[stat_to_view objectAtIndex:indexPath.row] isEqualToString:@"Session"]){
        [myimage setImage:[UIImage imageNamed:@"session.png"]];
    }else if([[stat_to_view objectAtIndex:indexPath.row] isEqualToString:@"Workshop"]){
        [myimage setImage:[UIImage imageNamed:@"workshop.png"]];
    }else if([[stat_to_view objectAtIndex:indexPath.row] isEqualToString:@"Break"]){
        [myimage setImage:[UIImage imageNamed:@"breakicon.png"]];
    }else if([[stat_to_view objectAtIndex:indexPath.row] isEqualToString:@"Hackathon"]){
        [myimage setImage:[UIImage imageNamed:@"hacathon.png"]];
    }
    
    
    html=[name_to_view objectAtIndex:indexPath.row];
    
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[html dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    firstname.attributedText=attrStr;
    [secondJob setText:[location_to_view objectAtIndex:indexPath.row]];
    [timeLabel setText:alltime];
    cell.backgroundColor = [UIColor clearColor];
    UIView *backView = [[UIView alloc]initWithFrame:CGRectZero];
    backView.backgroundColor = [UIColor clearColor];
    cell.backgroundView = backView;
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIStoryboard *storyboard = self.storyboard;
    SessionDetailed *vc = [storyboard instantiateViewControllerWithIdentifier:@"SessionDetailed"];
    
    if(flag==0){
        vc.sessionToSHow=[allDaysSessions objectAtIndex:indexPath.row];
    }else if(flag==1){
        vc.sessionToSHow=[firstDaySession objectAtIndex:indexPath.row];
    }else if(flag==2){
        vc.sessionToSHow=[secondDaySession objectAtIndex:indexPath.row];
    }else if(flag==3){
        vc.sessionToSHow=[thirdDaySession objectAtIndex:indexPath.row];
    }
    
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nc animated:YES completion:nil];
    
}


-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    
    if(item.tag==0)
    {
        flag=0;
        for(int i=0;i<[allDaysSessions count];i++){
            [name_to_view addObject:[[allDaysSessions objectAtIndex:i] name]];
            [location_to_view addObject:[[allDaysSessions objectAtIndex:i] session_location]];
            [startDate_to_view addObject:[[allDaysSessions objectAtIndex:i] startDate]];
            [endDate_to_view addObject:[[allDaysSessions objectAtIndex:i] endDate]];
            [endDate_to_view addObject:[[allDaysSessions objectAtIndex:i] sessionType]];
        }
        [self.mytableView reloadData];
    }
    else if(item.tag==1){
        flag=1;
        [name_to_view removeAllObjects];
        [location_to_view removeAllObjects];
        [startDate_to_view removeAllObjects];
        [endDate_to_view removeAllObjects];
        [stat_to_view removeAllObjects];
        //        for(int i=0;i<[sessionArray1 count];i++){
        ////            printf("\n*****%s",[[[firstDaySession objectAtIndex:i] name] UTF8String]);
        //            [name_to_view addObject:[[sessionArray1 objectAtIndex:i] objectForKey:@"name"]];
        //            [location_to_view addObject:[[sessionArray1 objectAtIndex:i] objectForKey:@"location"]];
        //            [startDate_to_view addObject:[[sessionArray1 objectAtIndex:i] objectForKey:@"startDate"]];
        //            [endDate_to_view addObject:[[sessionArray1 objectAtIndex:i] objectForKey:@"endDate"]];
        //            [stat_to_view addObject:[[sessionArray1 objectAtIndex:i] objectForKey:@"sessionType"]];
        //
        //        }
        
        for(int i=0;i<[firstDaySession count];i++){
            [name_to_view addObject:[[firstDaySession objectAtIndex:i] name]];
            [location_to_view addObject:[[firstDaySession objectAtIndex:i] session_location]];
            [startDate_to_view addObject:[[firstDaySession objectAtIndex:i] startDate]];
            [endDate_to_view addObject:[[firstDaySession objectAtIndex:i] endDate]];
            [stat_to_view addObject:[[firstDaySession objectAtIndex:i] sessionType]];
            
        }
        [self.mytableView reloadData];
    }
    
    else if(item.tag==2){
        flag=2;
        [name_to_view removeAllObjects];
        [location_to_view removeAllObjects];
        [startDate_to_view removeAllObjects];
        [endDate_to_view removeAllObjects];
        [stat_to_view removeAllObjects];
        //        for(int i=0;i<[sessionArray2 count];i++){
        //            [name_to_view addObject:[[sessionArray2 objectAtIndex:i] objectForKey:@"name"]];
        //            [location_to_view addObject:[[sessionArray2 objectAtIndex:i] objectForKey:@"location"]];
        //            [startDate_to_view addObject:[[sessionArray2 objectAtIndex:i] objectForKey:@"startDate"]];
        //            [endDate_to_view addObject:[[sessionArray2 objectAtIndex:i] objectForKey:@"endDate"]];
        //            [stat_to_view addObject:[[sessionArray2 objectAtIndex:i] objectForKey:@"sessionType"]];
        //        }
        
        
        for(int i=0;i<[secondDaySession count];i++){
            [name_to_view addObject:[[secondDaySession objectAtIndex:i] name]];
            [location_to_view addObject:[[secondDaySession objectAtIndex:i] session_location]];
            [startDate_to_view addObject:[[secondDaySession objectAtIndex:i] startDate]];
            [endDate_to_view addObject:[[secondDaySession objectAtIndex:i] endDate]];
            [stat_to_view addObject:[[secondDaySession objectAtIndex:i] sessionType]];
            
        }
        
        
        [self.mytableView reloadData];
    }else if(item.tag==3){
        flag=3;
        [name_to_view removeAllObjects];
        [location_to_view removeAllObjects];
        [startDate_to_view removeAllObjects];
        [endDate_to_view removeAllObjects];
        [stat_to_view removeAllObjects];
        
        for(int i=0;i<[thirdDaySession count];i++){
            [name_to_view addObject:[[thirdDaySession objectAtIndex:i] name]];
            [location_to_view addObject:[[thirdDaySession objectAtIndex:i] session_location]];
            [startDate_to_view addObject:[[thirdDaySession objectAtIndex:i] startDate]];
            [endDate_to_view addObject:[[thirdDaySession objectAtIndex:i] endDate]];
            [stat_to_view addObject:[[thirdDaySession objectAtIndex:i] sessionType]];
            
        }
        [self.mytableView reloadData];
    }
}
- (void)refreshdata
{
    if (self.refreshControl) {
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            NSLog(@"\n***********************Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
            if ([[AFNetworkReachabilityManager sharedManager] isReachable]) {
                NSLog(@"***********Online***********");
                [self myConnectMethod:service_Name andUrl:url];
            }else{
                allDaysSessions=[dbObj selectFromSessions];
                for(int i=0;i<[allDaysSessions count];i++){
                    
                    SessionBean *s_obj =[SessionBean new];
                    s_obj=[allDaysSessions objectAtIndex:i];
                    [name_to_view addObject:s_obj.name];
                    [location_to_view addObject:s_obj.session_location];
                    [startDate_to_view addObject:s_obj.startDate];
                    [endDate_to_view addObject:s_obj.endDate];
                    [stat_to_view addObject:s_obj.sessionType];
                    
                    if(s_obj.day==13){
                        [firstDaySession addObject:s_obj];
                    }else if(s_obj.day==14){
                        [secondDaySession addObject:s_obj];
                    }else if(s_obj.day==15){
                        [thirdDaySession addObject:s_obj];
                    }
                }
                [self.mytableView reloadData];
                [HUD hideAnimated:YES];
            }
            
        }];
        
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        
        
        [self.refreshControl endRefreshing];
    }
}

- (void)getLatestLoans
{
    
    [self performSelectorOnMainThread:@selector(refreshdata) withObject:nil waitUntilDone:NO];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
-(void) handle:(NSData*) dataRetreived :(NSString*) serviceName{
    
    
    if([serviceName isEqualToString:@"getAgenda"]){
        
        NSDictionary *myresult = [NSJSONSerialization JSONObjectWithData:dataRetreived options:0 error:nil];
        NSDictionary *result =[myresult objectForKey:@"result"];
        NSMutableArray *agendaArray =[result objectForKey:@"agendas"];
        
        agenda1 =[myobjParser getAgendaDictionaryFromArrayOfAgenda:agendaArray :0];
        agenda2 =[myobjParser getAgendaDictionaryFromArrayOfAgenda:agendaArray :1];
        agenda3 =[myobjParser getAgendaDictionaryFromArrayOfAgenda:agendaArray :2];
        
        
        
        NSDateFormatter *formatter_handle = [[NSDateFormatter alloc] init];
        [formatter_handle setDateFormat:@"dd"];
        
        NSString* f_date =[agenda1 objectForKey:@"date"];
        NSDate *f_datee = [NSDate dateWithTimeIntervalSince1970:[f_date longLongValue]/1000];
        firstdayDate=[formatter_handle stringFromDate: f_datee];
        
        NSString* s_date =[agenda2 objectForKey:@"date"];
        NSDate *s_datee = [NSDate dateWithTimeIntervalSince1970:[s_date longLongValue]/1000];
        seconddayDate=[formatter_handle stringFromDate: s_datee];
        
        NSString* t_date =[agenda3 objectForKey:@"date"];
        NSDate *t_datee = [NSDate dateWithTimeIntervalSince1970:[t_date longLongValue]/1000];
        thirddayDate=[formatter_handle stringFromDate: t_datee];
        
        printf("%s    %s     %s",[firstdayDate UTF8String],[seconddayDate UTF8String],[thirddayDate UTF8String]);
        
        sessionArray1=[myobjParser getArrayOfSessionsFromAgnedasobject:agenda1];
        sessionArray2=[myobjParser getArrayOfSessionsFromAgnedasobject:agenda2];
        sessionArray3=[myobjParser getArrayOfSessionsFromAgnedasobject:agenda3];
        [dbObj clearTables:@"DELETE FROM SPEAKER_SESSION"];
        for(int i=0;i<[sessionArray1 count];i++){
            NSMutableArray *sp1=[NSMutableArray new];
            NSMutableArray *aaaa=[NSMutableArray new];
            aaaa=[[sessionArray1 objectAtIndex:i] objectForKey:@"speakers"];
            if([aaaa isEqual:[NSNull null]]){
            }else{
                int Id=[[[sessionArray1 objectAtIndex:i] objectForKey:@"id"] intValue];
                sp1=[[sessionArray1 objectAtIndex:i] objectForKey:@"speakers"];
                for(int j=0;j<[sp1 count];j++){
                    SpeakersBean *obj =[SpeakersBean new];
                    obj.firstName=[[sp1 objectAtIndex:j] objectForKey:@"firstName"];
                    obj.lastName=[[sp1 objectAtIndex:j] objectForKey:@"lastName"];
                    obj.idd=[[[sp1 objectAtIndex:j] objectForKey:@"id"] intValue];
                    obj.companyName=[[sp1 objectAtIndex:j] objectForKey:@"companyName"];
                    obj.title=[[sp1 objectAtIndex:j] objectForKey:@"title"];
                    obj.phone=[[sp1 objectAtIndex:j] objectForKey:@"phone"];
                    obj.mobile=[[sp1 objectAtIndex:j] objectForKey:@"mobile"];
                    obj.middleName=[[sp1 objectAtIndex:j] objectForKey:@"middleName"];
                    obj.biography=[[sp1 objectAtIndex:j] objectForKey:@"biography"];
                    NSString *gend =[NSString stringWithFormat:@"%@",[[sp1 objectAtIndex:j] objectForKey:@"gender"]];
                    obj.gender=gend;
                    
                    [dbObj insertInSpeakerSession:Id :obj];
                }
            }
            
            
        }
        
        
        for(int i=0;i<[sessionArray2 count];i++){
            NSMutableArray *sp1=[NSMutableArray new];
            NSMutableArray *aaaa=[NSMutableArray new];
            aaaa=[[sessionArray2 objectAtIndex:i] objectForKey:@"speakers"];
            if([aaaa isEqual:[NSNull null]]){
            }else{
                int Id=[[[sessionArray2 objectAtIndex:i] objectForKey:@"id"] intValue];
                sp1=[[sessionArray2 objectAtIndex:i] objectForKey:@"speakers"];
                for(int j=0;j<[sp1 count];j++){
                    SpeakersBean *obj =[SpeakersBean new];
                    obj.firstName=[[sp1 objectAtIndex:j] objectForKey:@"firstName"];
                    obj.lastName=[[sp1 objectAtIndex:j] objectForKey:@"lastName"];
                    obj.idd=[[[sp1 objectAtIndex:j] objectForKey:@"id"] intValue];
                    obj.companyName=[[sp1 objectAtIndex:j] objectForKey:@"companyName"];
                    obj.title=[[sp1 objectAtIndex:j] objectForKey:@"title"];
                    obj.phone=[[sp1 objectAtIndex:j] objectForKey:@"phone"];
                    obj.mobile=[[sp1 objectAtIndex:j] objectForKey:@"mobile"];
                    obj.middleName=[[sp1 objectAtIndex:j] objectForKey:@"middleName"];
                    obj.biography=[[sp1 objectAtIndex:j] objectForKey:@"biography"];
                    NSString *gend =[NSString stringWithFormat:@"%@",[[sp1 objectAtIndex:j] objectForKey:@"gender"]];
                    obj.gender=gend;
                    
                    [dbObj insertInSpeakerSession:Id :obj];
                }
            }
            
            
        }
        
        
        
        for(int i=0;i<[sessionArray3 count];i++){
            NSMutableArray *sp1=[NSMutableArray new];
            NSMutableArray *aaaa=[NSMutableArray new];
            aaaa=[[sessionArray3 objectAtIndex:i] objectForKey:@"speakers"];
            if([aaaa isEqual:[NSNull null]]){
            }else{
                int Id=[[[sessionArray3 objectAtIndex:i] objectForKey:@"id"] intValue];
                sp1=[[sessionArray3 objectAtIndex:i] objectForKey:@"speakers"];
                for(int j=0;j<[sp1 count];j++){
                    SpeakersBean *obj =[SpeakersBean new];
                    obj.firstName=[[sp1 objectAtIndex:j] objectForKey:@"firstName"];
                    obj.lastName=[[sp1 objectAtIndex:j] objectForKey:@"lastName"];
                    obj.idd=[[[sp1 objectAtIndex:j] objectForKey:@"id"] intValue];
                    obj.companyName=[[sp1 objectAtIndex:j] objectForKey:@"companyName"];
                    obj.title=[[sp1 objectAtIndex:j] objectForKey:@"title"];
                    obj.phone=[[sp1 objectAtIndex:j] objectForKey:@"phone"];
                    obj.mobile=[[sp1 objectAtIndex:j] objectForKey:@"mobile"];
                    obj.middleName=[[sp1 objectAtIndex:j] objectForKey:@"middleName"];
                    obj.biography=[[sp1 objectAtIndex:j] objectForKey:@"biography"];
                    NSString *gend =[NSString stringWithFormat:@"%@",[[sp1 objectAtIndex:j] objectForKey:@"gender"]];
                    obj.gender=gend;
                    
                    [dbObj insertInSpeakerSession:Id :obj];
                }
            }
            
            
        }
        
        
        
        
        
        [dbObj clearTables:@"DELETE FROM SESSIONS"];
        
        for(int i=0;i<[sessionArray1 count];i++){
            SessionBean *obj =[myobjParser getSessionObjectFromSessionArrayAtIndex:i :sessionArray1];
            obj.day=[firstdayDate intValue];
            [firstDaySession addObject:obj];
            [allDaysSessions addObject:obj];
            [dbObj insertInSessions:obj];
            [date_to_show addObject:firstdayDate];
        }
        for(int i=0;i<[sessionArray2 count];i++){
            SessionBean *obj =[SessionBean new];
            obj=[myobjParser getSessionObjectFromSessionArrayAtIndex:i :sessionArray2];
            obj.day=[seconddayDate intValue];
            [secondDaySession addObject:obj];
            [allDaysSessions addObject:obj];
            [dbObj insertInSessions:obj];
            [date_to_show addObject:seconddayDate];

        }
        
        for(int i=0;i<[sessionArray3 count];i++){
            SessionBean *obj =[SessionBean new];
            obj=[myobjParser getSessionObjectFromSessionArrayAtIndex:i :sessionArray3];
            obj.day=[thirddayDate intValue];
            [thirdDaySession addObject:obj];
            [allDaysSessions addObject:obj];
            [dbObj insertInSessions:obj];
            [date_to_show addObject:thirddayDate];

        }
        
        
        for(int i=0;i<[allDaysSessions count];i++){
            
            SessionBean *s_obj =[SessionBean new];
            s_obj=[allDaysSessions objectAtIndex:i];
            [name_to_view addObject:s_obj.name];
            [location_to_view addObject:s_obj.session_location];
            [startDate_to_view addObject:s_obj.startDate];
            [endDate_to_view addObject:s_obj.endDate];
            [stat_to_view addObject:s_obj.sessionType];
        }
        [self.mytableView reloadData];
        //     NSMutableArray *arrr=[dbObj selectFromSessions];
        //     for(int i=0;i<[arrr count];i++){
        //         NSLog(@"\n %@",[[arrr objectAtIndex:i] name]);
        //     }
        
        [HUD hideAnimated:YES];
        //     NSLog(@"%@",[arr objectAtIndex:1]);
    }
}


-(void)myConnectMethod:(NSString*)serviceName andUrl:(NSString*)serviceUrl{
    
    NSURL *myUrl =[NSURL URLWithString:serviceUrl];
    
    NetworkManager *netObj =[NetworkManager new];
    [netObj setNetworkDelegate:self];
    [NetworkManager connect:myUrl:serviceName:netObj];
}



@end
