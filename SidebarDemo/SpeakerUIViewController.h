//
//  SpeakerUIViewController.h
//  SidebarDemo
//
//  Created by JETS on 2/27/17.
//  Copyright © 2017 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MBProgressHUD;
@interface SpeakerUIViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
    MBProgressHUD *HUD;
    
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UITableView *mytableView;
@end
