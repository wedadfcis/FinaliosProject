//
//  SessionDetailed.h
//  iOSProject
//
//  Created by JETS on 3/3/17.
//  Copyright © 2017 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SessionBean.h"

@class MBProgressHUD;

@interface SessionDetailed : UIViewController<UITableViewDelegate,UITableViewDataSource>

{
    MBProgressHUD *HUD;
    
}
@property (weak, nonatomic) IBOutlet UILabel *myLabel;
@property  NSString *myData;
- (IBAction)backbtn:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *sessionName;
@property (weak, nonatomic) IBOutlet UILabel *sessionDay;
@property (weak, nonatomic) IBOutlet UILabel *sessionTitle;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property SessionBean* sessionToSHow;
@property (weak, nonatomic) IBOutlet UITextView *descrip;
- (IBAction)myagenda:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *favouriteBtn;

@end
