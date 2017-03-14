//
//  Login.h
//  SidebarDemo
//
//  Created by JETS on 2/27/17.
//  Copyright © 2017 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Login : UIViewController

- (IBAction)sucessLogin:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *userNameText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;

- (IBAction)signUp:(id)sender;

@end
