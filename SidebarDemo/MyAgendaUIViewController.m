//
//  MyAgendaUIViewController.m
//  SidebarDemo
//
//  Created by JETS on 2/27/17.
//  Copyright © 2017 Appcoda. All rights reserved.
//

#import "MyAgendaUIViewController.h"
#import "SWRevealViewController.h"
#import "SessionDetailed.h"
#import "NetworkManager.h"
#import "ParseAgendaWS.h"
#import "SessionBean.h"
#import "ParseLoginWs.h"
#import "ParseSpeakerWS.h"
#import "UserBean.h"
#import "DBManager.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"

@implementation MyAgendaUIViewController{
    int flag;
    //    *****************************
    ParseAgendaWS *myobjParser;
    ParseLoginWs *loginParseObj;
    ParseSpeakerWS *speakerParseObj;
    NSString *service_Name;
    NSString *url;
    //    *****************************
    NSMutableArray *date_to_show;

    
    
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
    
    NSMutableArray *firstDayDate ,*SecondDayDate ,*thirdDayDate;
    NSString *html;
}



UILabel *firstname ;
UILabel *secondJob ;
UIImageView *myimage ;
NSString *names;


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor purpleColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(getLatestLoans)
                  forControlEvents:UIControlEventValueChanged];
    
    firstDayDate=[NSMutableArray new];
    SecondDayDate=[NSMutableArray new];
    thirdDayDate=[NSMutableArray new];
    
    [self.myTableView addSubview:_refreshControl];
    
    date_to_show=[NSMutableArray new];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
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
            NSMutableArray *arr1=[NSMutableArray new];
            arr1=[dbObj selectFromSessions];
            for(int i=0;i<[arr1 count];i++){
                SessionBean *s_obj =[SessionBean new];
                
                s_obj=[arr1 objectAtIndex:i];
                
                if(s_obj.status==1 || s_obj.status==2){
                    [name_to_view addObject:s_obj.name];
                    [location_to_view addObject:s_obj.session_location];
                    [startDate_to_view addObject:s_obj.startDate];
                    [endDate_to_view addObject:s_obj.endDate];
                    [stat_to_view addObject:s_obj.sessionType];
                    
                    if(s_obj.day==13){
                        [firstDaySession addObject:s_obj];
                        [allDaysSessions addObject:s_obj];
                        [date_to_show addObject:[NSString stringWithFormat:@"%d",s_obj.day]];
                    }else if(s_obj.day==14){
                        [secondDaySession addObject:s_obj];
                        [allDaysSessions addObject:s_obj];
                        [date_to_show addObject:[NSString stringWithFormat:@"%d",s_obj.day]];
                    }else if(s_obj.day==15){
                        [thirdDaySession addObject:s_obj];
                        [allDaysSessions addObject:s_obj];
                        [date_to_show addObject:[NSString stringWithFormat:@"%d",s_obj.day]];
                    }
                }
            }
            
            [self.myTableView reloadData];
            [HUD hideAnimated:YES];
            
        }
        
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    
    // Change button color
    _sidebarButton.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}



-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if(item.tag==0)
    {
        [name_to_view removeAllObjects];
        [location_to_view removeAllObjects];
        [startDate_to_view removeAllObjects];
        [endDate_to_view removeAllObjects];
        flag=0;
        for(int i=0;i<[allDaysSessions count];i++){
            [name_to_view addObject:[[allDaysSessions objectAtIndex:i] name]];
            [location_to_view addObject:[[allDaysSessions objectAtIndex:i] session_location]];
            [startDate_to_view addObject:[[allDaysSessions objectAtIndex:i] startDate]];
            [endDate_to_view addObject:[[allDaysSessions objectAtIndex:i] endDate]];
            [stat_to_view addObject:[[allDaysSessions objectAtIndex:i] sessionType]];
        }
        [self.myTableView reloadData];
    }
    else if(item.tag==1){
        flag=1;
        [name_to_view removeAllObjects];
        [location_to_view removeAllObjects];
        [startDate_to_view removeAllObjects];
        [endDate_to_view removeAllObjects];
        for(int i=0;i<[firstDaySession count];i++){
            [name_to_view addObject:[[firstDaySession objectAtIndex:i] name]];
            [location_to_view addObject:[[firstDaySession objectAtIndex:i] session_location]];
            [startDate_to_view addObject:[[firstDaySession objectAtIndex:i] startDate]];
            [endDate_to_view addObject:[[firstDaySession objectAtIndex:i] endDate]];
            [stat_to_view addObject:[[firstDaySession objectAtIndex:i] sessionType]];
            
        }
        [self.myTableView reloadData];
    }
    
    else if(item.tag==2){
        flag=2;
        [name_to_view removeAllObjects];
        [location_to_view removeAllObjects];
        [startDate_to_view removeAllObjects];
        [endDate_to_view removeAllObjects];
        [stat_to_view removeAllObjects];
        
        for(int i=0;i<[secondDaySession count];i++){
            
            [name_to_view addObject:[[secondDaySession objectAtIndex:i] name]];
            [location_to_view addObject:[[secondDaySession objectAtIndex:i] session_location]];
            [startDate_to_view addObject:[[secondDaySession objectAtIndex:i] startDate]];
            [endDate_to_view addObject:[[secondDaySession objectAtIndex:i] endDate]];
            [stat_to_view addObject:[[secondDaySession objectAtIndex:i] sessionType]];
            
            
            
        }
        [self.myTableView reloadData];
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
        [self.myTableView reloadData];
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
                NSMutableArray *arr1=[NSMutableArray new];
                arr1=[dbObj selectFromSessions];
                for(int i=0;i<[arr1 count];i++){
                    SessionBean *s_obj =[SessionBean new];
                    
                    s_obj=[arr1 objectAtIndex:i];
                    
                    if(s_obj.status==1 || s_obj.status==2){
                        [name_to_view addObject:s_obj.name];
                        [location_to_view addObject:s_obj.session_location];
                        [startDate_to_view addObject:s_obj.startDate];
                        [endDate_to_view addObject:s_obj.endDate];
                        [stat_to_view addObject:s_obj.sessionType];
                        if(s_obj.day==13){
                            [firstDaySession addObject:s_obj];
                            [allDaysSessions addObject:s_obj];
                        }else if(s_obj.day==14){
                            [secondDaySession addObject:s_obj];
                            [allDaysSessions addObject:s_obj];
                        }else if(s_obj.day==15){
                            [thirdDaySession addObject:s_obj];
                            [allDaysSessions addObject:s_obj];
                        }
                    }
                }
                
                [self.myTableView reloadData];
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return [name_to_view count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    
    
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
    UIImageView *myimage =[cell viewWithTag:4];
    UILabel* timeLabel=[cell viewWithTag:3];
    UILabel* daylb = [cell viewWithTag:8];
    
    [daylb setText:[date_to_show objectAtIndex:indexPath.row]];
    
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





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void) handle:(NSData*) dataRetreived :(NSString*) serviceName{
    
    if([serviceName isEqualToString:@"getAgenda"]){
        NSDictionary *myresult = [NSJSONSerialization JSONObjectWithData:dataRetreived options:0 error:nil];
        NSDictionary *result =[myresult objectForKey:@"result"];
        NSMutableArray *agendaArray =[result objectForKey:@"agendas"];
        
        agenda1 =[myobjParser getAgendaDictionaryFromArrayOfAgenda:agendaArray :0];
        agenda2 =[myobjParser getAgendaDictionaryFromArrayOfAgenda:agendaArray :1];
        agenda3 =[myobjParser getAgendaDictionaryFromArrayOfAgenda:agendaArray :2];
        
        sessionArray1=[myobjParser getArrayOfSessionsFromAgnedasobject:agenda1];
        sessionArray2=[myobjParser getArrayOfSessionsFromAgnedasobject:agenda2];
        sessionArray3=[myobjParser getArrayOfSessionsFromAgnedasobject:agenda3];
        
        NSDateFormatter *formatter_handle = [[NSDateFormatter alloc] init];
        [formatter_handle setDateFormat:@"dd"];
        
        NSString* f_date =[agenda1 objectForKey:@"date"];
        NSDate *f_datee = [NSDate dateWithTimeIntervalSince1970:[f_date longLongValue]/1000];
        firstDayDate=[formatter_handle stringFromDate: f_datee];
        
        NSString* s_date =[agenda2 objectForKey:@"date"];
        NSDate *s_datee = [NSDate dateWithTimeIntervalSince1970:[s_date longLongValue]/1000];
        SecondDayDate=[formatter_handle stringFromDate: s_datee];
        
        NSString* t_date =[agenda3 objectForKey:@"date"];
        NSDate *t_datee = [NSDate dateWithTimeIntervalSince1970:[t_date longLongValue]/1000];
        thirdDayDate=[formatter_handle stringFromDate: t_datee];
        
        [dbObj clearTables:@"DELETE FROM SESSIONS"];
        
        for(int i=0;i<[sessionArray1 count];i++){
            
            SessionBean *obj =[myobjParser getSessionObjectFromSessionArrayAtIndex:i :sessionArray1];
            obj.day=13;
            if(obj.status==1 || obj.status==2){
                //                NSLog(@"%@\n",obj.liked);
                printf("%d\n",obj.liked);
                [firstDaySession addObject:obj];
                [allDaysSessions addObject:obj];
                [date_to_show addObject:firstDayDate];
            }
            
            
            
        }
        
        for(int i=0;i<[sessionArray2 count];i++){
            SessionBean *obj =[SessionBean new];
            obj=[myobjParser getSessionObjectFromSessionArrayAtIndex:i :sessionArray2];
            obj.day=14;
            if(obj.status==1 || obj.status==2){
                
                [secondDaySession addObject:obj];
                [allDaysSessions addObject:obj];
                [date_to_show addObject:SecondDayDate];
            }
            
        }
        
        for(int i=0;i<[sessionArray3 count];i++){
            
            SessionBean *obj =[SessionBean new];
            
            obj=[myobjParser getSessionObjectFromSessionArrayAtIndex:i :sessionArray3];
            obj.day=15;
            if(obj.status==1 || obj.status==2){
                
                [thirdDaySession addObject:obj];
                [allDaysSessions addObject:obj];
                [date_to_show addObject:thirdDayDate];
            }
            
            
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
        
        
        [self.myTableView reloadData];
        NSMutableArray *arrr=[dbObj selectFromSessions];
        for(int i=0;i<[arrr count];i++){
            NSLog(@"\n %@",[[arrr objectAtIndex:i] name]);
        }
        
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
