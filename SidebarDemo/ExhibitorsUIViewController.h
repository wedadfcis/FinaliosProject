//
//  ExhibitorsUIViewController.h
//  SidebarDemo
//
//  Created by JETS on 2/27/17.
//  Copyright © 2017 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MBProgressHUD;
@interface ExhibitorsUIViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
    MBProgressHUD *HUD;
    
}
@property UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end
