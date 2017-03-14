//
//  ProfileUIViewController.m
//  SidebarDemo
//
//  Created by JETS on 2/27/17.
//  Copyright © 2017 Appcoda. All rights reserved.
//

#import "ProfileUIViewController.h"
#import "SWRevealViewController.h"
#import <ZXingObjC.h>
#import "AttendeeBean.h"
#import "DBManager.h"

@implementation ProfileUIViewController{
    UIImage  * myimage;
    NSString * qr;
    CGImageRef * image;
    NSString * email;
    NSString  * phone;
    AttendeeBean  *attend_obj;
    UIImage *im ;
    DBManager* dbobj;
    NSMutableArray *arr;
    NSData *imgtoshow;
    UIImage *image1;
    NSString *all;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"my profile";
    NSUserDefaults* userObj=[NSUserDefaults standardUserDefaults];
    NSData *mydata = [userObj objectForKey:@"myprofile"];
    dbobj=[DBManager sharedInstance];
    arr=[dbobj selectFromAttendees];
    attend_obj=[AttendeeBean new];
    if([arr count]!=0){
        attend_obj=[arr objectAtIndex:0];
    }
    
    imgtoshow= attend_obj.img;
    image1 = [UIImage imageWithData:imgtoshow];
    [_myImage setImage:image1];
    
    NSString *space =@" ";
    
    all= [[attend_obj.firstName stringByAppendingString:space] stringByAppendingString:attend_obj.lastName ];

    
    //    attend_obj=[userObj objectForKey:@"myprofile"];
    printf("my name is ***** %s",[attend_obj.firstName UTF8String]);
    
    _sidebarButton.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    qr=[ NSString new ];
    email=[NSString new];
    phone=[NSString new];
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

-(void)viewWillAppear:(BOOL)animated

{
    qr=@"1cd733f1764e7228cc4d4b4562442337b1c338a6";
    NSError *error = nil;
    ZXMultiFormatWriter * writer = [ZXMultiFormatWriter writer];
    ZXBitMatrix* result = [writer encode:qr
                                  format:kBarcodeFormatQRCode
                                   width:500
                                  height:500
                                   error:&error];
    if (result) {
        
        myimage=[[UIImage alloc]initWithCGImage:[[ZXImage imageWithMatrix:result] cgimage]];
        self.qrimage.image=myimage;
        NSLog(@"imageqr");
        
        // This CGImageRef image can be placed in a UIImage, NSImage, or written to a file.
    } else {
        NSString *errorMessage = [error localizedDescription];
        NSLog(@"imageqr false");

    }
    
    
  
    [_name setText:all];
    [_depart setText:attend_obj.title];
    [_org setText:attend_obj.companyName];
    [_email setHidden:YES];
    [_mobile setHidden:YES];
    [_myMobile setHidden:YES];
  

    ////////////////////////////////////////////
    
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    //NSLog(@"test");
    if(item.tag==1)
    {
        self.title=@"My Profile";

        [_myTicket setText:@"My Ticket"];
        
        [_name setText:all];
        [_depart setText:attend_obj.title];
        [_org setText:attend_obj.companyName];
        [_email setHidden:YES];
        [_mobile setHidden:YES];
        [_myMobile setHidden:YES];
[_myImage setImage:image1];

        NSError *error = nil;
        ZXMultiFormatWriter * writer = [ZXMultiFormatWriter writer];
        ZXBitMatrix* result = [writer encode:attend_obj.code
                                      format:kBarcodeFormatQRCode
                                       width:500
                                      height:500
                                       error:&error];
        if (result) {
            image = [[ZXImage imageWithMatrix:result] cgimage];
            myimage =[[UIImage alloc]initWithCGImage:[[ZXImage imageWithMatrix:result] cgimage]];
            self.qrimage.image=myimage;
            
            // This CGImageRef image can be placed in a UIImage, NSImage, or written to a file.
        } else {
            NSString *errorMessage = [error localizedDescription];
        }
        
        
    }
    else if(item.tag==2){
        self.title=@"My Contact";
        [_email setHidden:NO];
        [_mobile setHidden:NO];
        [_myMobile setHidden:NO];
        [_myImage setImage:[UIImage imageNamed:@"agenda.png"]];
        [_name setText:all];
        [_depart setText:attend_obj.title];
        [_org setText:attend_obj.companyName];
        [_myTicket setText:attend_obj.email];
        [_myMobile setText:attend_obj.phone];
        [_myImage setImage:image1];
        email=attend_obj.email;
        phone=attend_obj.phone;
        if(phone != nil)
        {
            
            qr=[email stringByAppendingString:phone];
            [self.myTicket setText:email];
            [self.myMobile setText:phone];
            
        }
        else{
            [self.myTicket setText:email];
            [self.myMobile setText:@"No Mobile"];
            
            qr=email;
        }
        NSError *error = nil;
        ZXMultiFormatWriter * writer = [ZXMultiFormatWriter writer];
        ZXBitMatrix* result = [writer encode:qr
                                      format:kBarcodeFormatQRCode
                                       width:500
                                      height:500
                                       error:&error];
        if (result) {
            
            myimage=[[UIImage alloc]initWithCGImage:[[ZXImage imageWithMatrix:result] cgimage]];
            self.qrimage.image=myimage;
            
        } else {
            NSString *errorMessage = [error localizedDescription];
        }

        NSLog(@"test 2");
        
        
        
        
    }
    
}


@end

