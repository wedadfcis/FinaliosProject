//
//  ExhibitorsUIViewController.m
//  SidebarDemo
//
//  Created by JETS on 2/27/17.
//  Copyright © 2017 Appcoda. All rights reserved.
//

#import "ExhibitorsUIViewController.h"
#import "SWRevealViewController.h"
#import "UIImageView+AFNetworking.h"
#import "NetworkManager.h"
#import "ExhibitorsBean.h"
#import "ParseExhibitorsWs.h"
#import "AFNetworking.h"
#import "DBManager.h"
#import "MBProgressHUD.h"
@implementation ExhibitorsUIViewController{
    NSString *service_Name;
    NSString *url;
    NSMutableArray *ExhibitorArrayObject; // array of object from exhibitors
    ParseExhibitorsWs *parseObj;
    NSMutableArray *imgArray;
    DBManager *dbobj;
    NSMutableArray *urlarray;
    NSMutableArray *imgfromdb;
    int flag;
    NSMutableArray* idarr;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor purpleColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(getLatestLoans)
                  forControlEvents:UIControlEventValueChanged];
    
    
    [self.myTableView addSubview:_refreshControl];
    
    flag=0;
    imgfromdb=[NSMutableArray new];
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    idarr=[NSMutableArray new];
    [HUD showAnimated:YES];
    imgArray=[NSMutableArray new];
    parseObj=[ParseExhibitorsWs new];
    dbobj=[DBManager sharedInstance];
    urlarray=[NSMutableArray new];
    ExhibitorArrayObject=[NSMutableArray new];
    service_Name =@"getExhibitors";
    url =@"http://www.mobiledeveloperweekend.net/service/getExhibitors?userName=eng.medhat.cs.h@gmail.com";
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"\n***********************Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        if ([[AFNetworkReachabilityManager sharedManager] isReachable]) {
            NSLog(@"***********Online***********");
            flag=0;
            [self myConnectMethod:service_Name andUrl:url];
        }else{
            flag=1;
            [imgArray removeAllObjects];
            [urlarray removeAllObjects];
            ExhibitorArrayObject=[dbobj selectFromExhibitors];
            ExhibitorsBean *obj=[ExhibitorsBean new];
            for(int i=0;i<[ExhibitorArrayObject count];i++){
                obj=[ExhibitorArrayObject objectAtIndex:i];
                printf("\n %s",[obj.companyUrl UTF8String]);
                [urlarray addObject:obj.companyUrl];
                
                if(obj.img==NULL){
                    UIImage *img= [UIImage imageNamed:@"profile.png"];
                    NSData *imageData = UIImagePNGRepresentation(img);
                    
                    [imgArray addObject:imageData];
                }else{
                    [imgArray addObject:obj.img];
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
- (void)refreshdata
{
    if (self.refreshControl) {
        //        [self myConnectMethod:service_Name andUrl:url];
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            NSLog(@"\n***********************Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
            if ([[AFNetworkReachabilityManager sharedManager] isReachable]) {
                NSLog(@"***********Online***********");
                flag=0;
                [self myConnectMethod:service_Name andUrl:url];
            }else{
                flag=1;
                [imgArray removeAllObjects];
                [urlarray removeAllObjects];
                ExhibitorArrayObject=[dbobj selectFromExhibitors];
                ExhibitorsBean *obj=[ExhibitorsBean new];
                for(int i=0;i<[ExhibitorArrayObject count];i++){
                    obj=[ExhibitorArrayObject objectAtIndex:i];
                    printf("\n %s",[obj.companyUrl UTF8String]);
                    [urlarray addObject:obj.companyUrl];
                    
                    if(obj.img==NULL){
                        UIImage *img= [UIImage imageNamed:@"profile.png"];
                        NSData *imageData = UIImagePNGRepresentation(img);
                        
                        [imgArray addObject:imageData];
                    }else{
                        [imgArray addObject:obj.img];
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
    
    return [ExhibitorArrayObject count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    
    UILabel *nameof_exhibitors=[cell viewWithTag:2]; // label for exhibitor name with tag= 2
    [nameof_exhibitors setText:[[ExhibitorArrayObject objectAtIndex:indexPath.row] companyName]];
    
    
    ExhibitorsBean *obj=[ExhibitorsBean new];
    obj=[ExhibitorArrayObject objectAtIndex:indexPath.row];
    UIImageView *myimage=[cell viewWithTag:1];
    
    if(flag==0){
        
        NSURL *urll = [NSURL URLWithString:[imgArray objectAtIndex:indexPath.row]];
        NSURLRequest *request = [NSURLRequest requestWithURL:urll];
        UIImage *placeholderImage = [UIImage imageNamed:@"profile.png"];
        [cell.imageView setImageWithURLRequest:request
                              placeholderImage:placeholderImage
                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                           
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
                                               [dbobj updateExhibitor:[[idarr objectAtIndex:indexPath.row] intValue] :imageData];
                                               
                                               
                                           }
                                           cell.imageView.image=newImage;
                                           
                                       } failure:nil];
        
    }else if(flag==1){
        NSData *imageData = [imgArray objectAtIndex:indexPath.row];
        
        if (imageData.length > 0) {
            UIImage *image1 = [UIImage imageWithData:imageData];
            //            [myimage setImage:image1];
            cell.imageView.image=image1;
        }else{
            UIImage *img =[UIImage imageNamed:@"profile.png"];
            //            [myimage setImage:img];
            cell.imageView.image=img;
        }
        
    }
    
    
    
    
    cell.backgroundColor = [UIColor clearColor];
    UIView *backView1 = [[UIView alloc]initWithFrame:CGRectZero];
    backView1.backgroundColor = [UIColor clearColor];
    cell.backgroundView = backView1;
    
    
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"selected");
    NSURL *urll = [NSURL URLWithString:[urlarray objectAtIndex:indexPath.row]];
    
    if ([[UIApplication sharedApplication] canOpenURL:urll]) {
        [[UIApplication sharedApplication] openURL:urll];
        
    }else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"Invalid Url";
        hud.label.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:1];
        hud.label.textColor=[UIColor colorWithRed:250 green:250 blue:250 alpha:1];
        
        hud.margin = 10.f;
        hud.yOffset = 150.f;
        hud.removeFromSuperViewOnHide = YES;
        
        [hud hideAnimated:YES afterDelay:2];

    }
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


/// this method to insert here in database
-(void) handle:(NSData*) dataRetreived :(NSString*) serviceName{
    
    
    
    
    if([serviceName isEqualToString:@"getExhibitors"]){
        NSDictionary *myresult = [NSJSONSerialization JSONObjectWithData:dataRetreived options:0 error:nil];
        NSMutableArray *resultArray =[myresult objectForKey:@"result"];
        [dbobj clearTables:@"DELETE FROM EXHIBITORS"];
        
        [imgArray removeAllObjects];
        [urlarray removeAllObjects];
        
        ExhibitorArrayObject=[parseObj getExhibitorsObject:resultArray];
        idarr=[parseObj getIdArr:resultArray];
        for(int i=0;i<[resultArray count];i++){
            
            [imgArray addObject:[[resultArray objectAtIndex:i] objectForKey:@"imageURL"]];
        }
        
        
        for(int i=0;i<[ExhibitorArrayObject count];i++){
            ExhibitorsBean *ex_obj=[ExhibitorsBean new];
            ex_obj=[ExhibitorArrayObject objectAtIndex:i];
            [dbobj insertInExhibitors:ex_obj];
            [urlarray addObject:ex_obj.companyUrl];
            
        }
        [self.myTableView reloadData];
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
