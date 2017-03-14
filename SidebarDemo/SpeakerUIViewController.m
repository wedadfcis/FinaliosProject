//
//  SpeakerUIViewController.m
//  SidebarDemo
//
//  Created by JETS on 2/27/17.
//  Copyright © 2017 Appcoda. All rights reserved.
//

#import "SpeakerUIViewController.h"
#import "SWRevealViewController.h"
#import "NetworkManager.h"
#import "UIImageView+AFNetworking.h"
#import "ParseSpeakerWS.h"
#import "DBManager.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "SpeakerDetail.h"
@implementation SpeakerUIViewController{
    NSString *service_Name;
    NSString *url;
    ParseSpeakerWS *speakerParseObj;
    NSMutableArray *speakersFirstName;
    NSMutableArray *speakersLastName;
    NSMutableArray *speakersTitle;
    NSMutableArray *imageArray;
    DBManager* dbobj;
    NSMutableArray* arr_to_insert;
    
    int flag;
    NSMutableArray *db_selection_speaker;
    NSMutableArray *idarr;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    flag=0;
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    [HUD showAnimated:YES];
    idarr=[NSMutableArray new];
    db_selection_speaker=[NSMutableArray new];
    dbobj=[DBManager sharedInstance];
    arr_to_insert=[NSMutableArray new];
   
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor purpleColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(getLatestLoans)
                  forControlEvents:UIControlEventValueChanged];
    
    
    [self.mytableView addSubview:_refreshControl];
    
    speakerParseObj=[ParseSpeakerWS new];
    speakersFirstName=[NSMutableArray new];
    speakersLastName =[NSMutableArray new];
    speakersTitle =[NSMutableArray new];
    imageArray =[NSMutableArray new];
    
    service_Name =@"getSpeaker";
    url =@"http://www.mobiledeveloperweekend.net/service/getSpeakers?userName=eng.medhat.cs.h@gmail.com";
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"\n***********************Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        if ([[AFNetworkReachabilityManager sharedManager] isReachable]) {
            NSLog(@"***********Online***********");
            flag=0;
            [self myConnectMethod:service_Name andUrl:url];
        }else{
            //
            //select all speakers
            flag=1;
            [speakersTitle removeAllObjects];
            [speakersLastName removeAllObjects];
            [speakersFirstName removeAllObjects];
            [imageArray removeAllObjects];
            
            NSMutableArray *spList = [NSMutableArray new];
            //        db_selection_speaker=[dbobj selectFromSpeakers];
            spList = [dbobj selectFromSpeakers];
            for (int i = 0 ; i<spList.count; i++) {
                SpeakersBean *tmp = [SpeakersBean new];
                tmp = [spList objectAtIndex:i];
                [speakersFirstName addObject:tmp.firstName];
                [speakersLastName addObject:tmp.lastName];
                [speakersTitle addObject:tmp.title];
                [imageArray addObject:tmp.img];
                
                printf("speaker first name is: %s", [tmp.firstName UTF8String]);
            }
            [_mytableView reloadData];
            [HUD hideAnimated:YES];
            
        }
        
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    
    //    [self myConnectMethod:service_Name andUrl:url];
    self.title = @"MainView";
    
    // Change button color
    _sidebarButton.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [speakersFirstName count];
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SpeakerDetail *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SpeakerDetail"];
    SpeakersBean *sp=[SpeakersBean new];
    sp=[arr_to_insert objectAtIndex:indexPath.row];
    [vc setSpeaker: sp];
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nc animated:YES completion:nil];
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    
    UILabel *firstname =[cell viewWithTag:1];
    UILabel *title =[cell viewWithTag:2];
    UIImageView *myimage =[cell viewWithTag:3];
    myimage.frame = CGRectMake(0,0,32,32);
    [title setFont: [title.font fontWithSize: 12]];
    NSString* first =[speakersFirstName objectAtIndex:indexPath.row];
    NSString* second =[speakersLastName objectAtIndex:indexPath.row];
    NSString *full_name =[[first stringByAppendingString:@" "] stringByAppendingString:second];
    
    
    
    
    if(flag==0){
        NSURL *urll = [NSURL URLWithString:[imageArray objectAtIndex:indexPath.row]];
        NSURLRequest *request = [NSURLRequest requestWithURL:urll];
        UIImage *placeholderImage = [UIImage imageNamed:@"profile.png"];
        [cell.imageView setImageWithURLRequest:request
                              placeholderImage:placeholderImage
                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                           int Id=[[arr_to_insert objectAtIndex:indexPath.row] idd];
                                           
                                           
                                           
                                           CGSize newSize = CGSizeMake(50, 50);
                                           float widthRatio = newSize.width/image.size.width;
                                           float heightRatio = newSize.height/image.size.height;
                                           
                                           if(widthRatio > heightRatio)
                                           {
                                               newSize=CGSizeMake(image.size.width*heightRatio,image.size.height*heightRatio);
                                           }
                                           else
                                           {
                                               newSize=CGSizeMake(image.size.width*widthRatio,image.size.height*widthRatio);
                                           }
                                           
                                           
                                           UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
                                           [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
                                           UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
                                           UIGraphicsEndImageContext();
                                           
                                           
                                           
                                           
                                           
                                           if(response !=nil){
                                              NSData *imageData = UIImagePNGRepresentation(image);
                                              [dbobj updateSpeaker:[[idarr objectAtIndex:indexPath.row] intValue] :imageData];
                                               
                                           }
                                           cell.imageView.image=newImage;
                                           
                                       } failure:nil];
        
    }else if(flag==1){
        NSData *imgtoshow=[imageArray objectAtIndex:indexPath.row];
        UIImage *image1 = [UIImage imageWithData:imgtoshow];
        [myimage setImage:image1];
    }
    
    [firstname setText:full_name];
    [title setText:[speakersTitle objectAtIndex:indexPath.row]];
    myimage.clipsToBounds = YES;
    //
    //    cell.imageView.layer.cornerRadius = cell.imageView.frame.size.width / 2.0;;
    ////    cell.imageView.layer.borderWidth=2;
    ////    cell.imageView.layer.borderColor=(__bridge CGColorRef _Nullable)([UIColor colorWithRed:0 green:0 blue:0 alpha:1]);
    ////    cell.imageView.autoresizingMask=false;
    //    cell.imageView.layer.masksToBounds = YES;
    //
    
    cell.backgroundColor = [UIColor clearColor];
    UIView *backView1 = [[UIView alloc]initWithFrame:CGRectZero];
    backView1.backgroundColor = [UIColor clearColor];
    cell.backgroundView = backView1;
    return cell;
}


- (void)refreshdata
{
    if (self.refreshControl) {
        [self myConnectMethod:service_Name andUrl:url];
        [self.refreshControl endRefreshing];
    }
}

- (void)getLatestLoans
{
    
    [self performSelectorOnMainThread:@selector(refreshdata) withObject:nil waitUntilDone:NO];
    
}

-(void) handle:(NSData*) dataRetreived :(NSString*) serviceName{
    
    //    [dbobj clearTables:@"DELETE FROM SPEAKERS"];
    if([serviceName isEqualToString:@"getSpeaker"]){
        [dbobj clearTables:@"DELETE FROM SPEAKERS"];
        NSDictionary *myresult = [NSJSONSerialization JSONObjectWithData:dataRetreived options:0 error:nil];
        NSMutableArray *result=[myresult objectForKey:@"result"];
        
        speakersFirstName=[speakerParseObj getArrayOfSpeakersFirstName:result];
        speakersLastName=[speakerParseObj getArrayOfSpeakersLastName:result];
        speakersTitle =[speakerParseObj getTitleArrayForSpeakers:result];
        imageArray =[speakerParseObj getImageArrayForSpeakers:result];
        
        arr_to_insert=[speakerParseObj getAllSpeakers:myresult];
        
        for (int j = 0 ; j<result.count; j++) {
            NSDictionary *speakerDict = [result objectAtIndex:j];
            SpeakersBean *tmpSpeaker = [SpeakersBean new];
            tmpSpeaker.idd = [[speakerDict objectForKey:@"id"] intValue];
            [idarr addObject:[speakerDict objectForKey:@"id"] ];
            tmpSpeaker.firstName = [speakerDict objectForKey:@"firstName"];
            tmpSpeaker.lastName = [speakerDict objectForKey:@"lastName"];
            tmpSpeaker.companyName = [speakerDict objectForKey:@"companyName"];
            tmpSpeaker.title = [speakerDict objectForKey:@"title"];
            tmpSpeaker.middleName = [speakerDict objectForKey:@"middleName"];
            tmpSpeaker.biography = [speakerDict objectForKey:@"biography"];
            NSMutableArray *speakerPhone = [speakerDict objectForKey:@"phones"];
            NSMutableArray *speakerMobile = [speakerDict objectForKey:@"mobiles"];
            if (speakerPhone.count != 0) {
                tmpSpeaker.phone = [speakerPhone objectAtIndex:0];
            }else{ tmpSpeaker.phone = @"no phone"; }
            
            if (speakerMobile.count != 0) {
                tmpSpeaker.mobile = [speakerMobile objectAtIndex:0];
            }else{ tmpSpeaker.mobile = @"no mobile"; }
            
            NSString *genderString = ([speakerDict objectForKey:@"gender"]) ? @"true" : @"false";
            tmpSpeaker.gender = genderString;
            
            [dbobj insertInSpeakers:tmpSpeaker];
            printf("Done");
        }
        
        db_selection_speaker=[dbobj selectFromSpeakers];
        
        [self.mytableView reloadData];
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
