//
//  MyAgendaUIViewController.h
//  SidebarDemo
//
//  Created by JETS on 2/27/17.
//  Copyright © 2017 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBProgressHUD;
@interface MyAgendaUIViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UITabBarDelegate>
{
    MBProgressHUD *HUD;
    
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UITabBar *mybar;
@end
