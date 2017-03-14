//
//  ProfileUIViewController.h
//  SidebarDemo
//
//  Created by JETS on 2/27/17.
//  Copyright © 2017 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileUIViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property (weak, nonatomic) IBOutlet UIImageView *qrimage;
@property (weak, nonatomic) IBOutlet UIImageView *myImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *depart;
@property (weak, nonatomic) IBOutlet UILabel *org;
@property (weak, nonatomic) IBOutlet UILabel *myTicket;
@property (weak, nonatomic) IBOutlet UILabel *mobile;
@property (weak, nonatomic) IBOutlet UILabel *myMobile;
@property (weak, nonatomic) IBOutlet UILabel *email;

@end
