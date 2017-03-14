//
//  ViewController.h
//  SidebarDemo
//
//  Created by Simon on 28/6/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MBProgressHUD;
@interface MainViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UITabBarDelegate>
{
    MBProgressHUD *HUD;
    
}
@property UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UITabBarItem *myBar;
@property (weak, nonatomic) IBOutlet UITableView *mytableView;

@end
