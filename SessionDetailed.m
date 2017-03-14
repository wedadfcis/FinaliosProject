//
//  SessionDetailed.m
//  iOSProject
//
//  Created by JETS on 3/3/17.
//  Copyright © 2017 Appcoda. All rights reserved.
//

#import "SessionDetailed.h"
#import "NetworkManager.h"
#import "MBProgressHUD.h"
#import "DBManager.h"

@implementation SessionDetailed{
    NSString *html;
    NSString* userName ,*password;
    NSUserDefaults *defaults;
    int status;
    NSMutableArray *speakersarr;
    DBManager *dbobj;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    userName=[NSString new];
    password=[NSString new];
    dbobj=[DBManager sharedInstance];
    defaults= [NSUserDefaults standardUserDefaults];
    userName=[defaults objectForKey:@"username"];
    password=[defaults objectForKey:@"password"];
    
    speakersarr=[NSMutableArray new];
    
    speakersarr =[dbobj selectFromSpeakerSession:_sessionToSHow.idd];
    
    printf("%s \n %s",[userName UTF8String],[password UTF8String]);
    
    html=[NSString new];
    html=_sessionToSHow.name;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a"];
 
    NSString* startdate =_sessionToSHow.startDate;
    NSString* enddate =_sessionToSHow.endDate;
        NSDate *s_date = [NSDate dateWithTimeIntervalSince1970:[startdate longLongValue]/1000];
    
    NSDate *e_date = [NSDate dateWithTimeIntervalSince1970:[enddate longLongValue]/1000];
    
    NSString *s_date_Str=   [formatter stringFromDate: s_date];
    
    NSString *space =@" - ";
    NSString *e_date_Str=   [formatter stringFromDate: e_date];
    
    NSString *alltime= [[s_date_Str stringByAppendingString:space] stringByAppendingString:e_date_Str ];
    
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[html dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
     NSDate *dayy = [NSDate dateWithTimeIntervalSince1970:[startdate longLongValue]/1000];
    
    
    if(_sessionToSHow.status==0){
        [_favouriteBtn setBackgroundImage:[UIImage imageNamed:@"sessionnotadded.png"] forState:UIControlStateNormal];
    }else if(_sessionToSHow.status==1){
        [_favouriteBtn setBackgroundImage:[UIImage imageNamed:@"sessionpending.png"] forState:UIControlStateNormal];
    }else if(_sessionToSHow.status==2){
        [_favouriteBtn setBackgroundImage:[UIImage imageNamed:@"sessionapproved.png"] forState:UIControlStateNormal];
    }
    
    [formatter setDateFormat:@"MM/dd/yyyy"];
    [_sessionTitle setText:[formatter stringFromDate: dayy]];
    [_location setText:_sessionToSHow.session_location];
    [_sessionName setAttributedText:attrStr];
    [_sessionDay setText:alltime];
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[_sessionToSHow.descript dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];

    
    [_descrip setEditable:false];
    [_descrip setAttributedText:attributedString];
    [_myLabel setText:[self myData]];
    printf("%s",[[self myData] UTF8String]) ;
    NSLog(@"backload");
  //  self.navigationItem.hidesBackButton = YES;
   // UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(back:)];
   // self.navigationItem.leftBarButtonItem = newBackButton;

}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [speakersarr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    UILabel *name=[cell viewWithTag:1];
    UILabel *company=[cell viewWithTag:2];
    UIImageView *img=[cell viewWithTag:3];
    
    [name setText:[[speakersarr objectAtIndex:indexPath.row] firstName]];
    [company setText:[[speakersarr objectAtIndex:indexPath.row] companyName]];
    [img setImage:[UIImage imageNamed:@"profile.png"]];
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.label.text = @"Some message...";
    hud.label.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    hud.label.textColor=[UIColor colorWithRed:250 green:250 blue:250 alpha:1];
    
    hud.margin = 10.f;
    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hideAnimated:YES afterDelay:2];
    
    
//    UIStoryboard *storyboard = self.storyboard;
//    SessionDetailed *vc = [storyboard instantiateViewControllerWithIdentifier:@"SessionDetailed"];
//    
//    
//    
//    vc.myData = sessionName;
//    
//    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
//    
//    [self presentViewController:nc animated:YES completion:nil];
    
}



//
//- (void) back:(UIBarButtonItem *)sender {
//    // Perform your custom actions
//    // ...
//    // Go back to the previous ViewController
//    [self.navigationController popViewControllerAnimated:YES];
//}


- (IBAction)backbtn:(id)sender {
    NSLog(@"back");
       // [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    

}
- (IBAction)myagenda:(id)sender {
 
//    http://www.mobiledeveloperweekend.net/service/registerSession?userName=moh.said511@gmail.com&sessionId=4482&enforce=false&status=0
//
    
    int s_id=_sessionToSHow.idd;
    status =_sessionToSHow.status;
    
    if(status==0){
        status=1;
    }else if (status==1){
        status=2;
    }else if (status==2){
        status=0;
    }
   
    NSString *serviceName =@"registersession";
    NSString* baseUrl =  [NSString stringWithFormat:@"http://www.mobiledeveloperweekend.net/service/registerSession?userName=%@&sessionId=%d&enforce=false&status=0",userName,s_id];
    
    [self myConnectMethod:serviceName andUrl:baseUrl];
}



-(void) handle:(NSData*) dataRetreived :(NSString*) serviceName{
    
    if([serviceName isEqualToString:@"registersession"]){
        [super viewDidLoad];
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        [HUD showAnimated:YES];
        
    
        
        NSDictionary *myresult = [NSJSONSerialization JSONObjectWithData:dataRetreived options:0 error:nil];
        NSDictionary *result=[myresult objectForKey:@"result"];
        
        NSString *statussss=[result objectForKey:@"status"];
        NSString *oldSessionId=[result objectForKey:@"oldSessionId"];
        
        if([oldSessionId intValue]==0){
            if([statussss intValue]==0){
                printf("first");
                [_favouriteBtn setBackgroundImage:[UIImage imageNamed:@"sessionnotadded.png"] forState:UIControlStateNormal];
            }else if([statussss intValue]==1){
                printf("second");
                [_favouriteBtn setBackgroundImage:[UIImage imageNamed:@"sessionpending.png"] forState:UIControlStateNormal];
            }else if([statussss intValue]==2){
                printf("third");
                [_favouriteBtn setBackgroundImage:[UIImage imageNamed:@"sessionapproved.png"] forState:UIControlStateNormal];
            }
            
            _sessionToSHow.status=[statussss intValue];
            [self viewDidLoad];
        }else{
            
        }

        
        [HUD hideAnimated:YES];
        
    }
}
-(void)myConnectMethod:(NSString*)serviceName andUrl:(NSString*)serviceUrl{
    
    NSURL *myUrl =[NSURL URLWithString:serviceUrl];
    
    NetworkManager *netObj =[NetworkManager new];
    [netObj setNetworkDelegate:self];
    [NetworkManager connect:myUrl:serviceName:netObj];
}

@end
