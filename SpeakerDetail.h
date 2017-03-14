//
//  SpeakerDetail.h
//  iOSProject
//
//  Created by JETS on 3/10/17.
//  Copyright © 2017 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpeakersBean.h"

@interface SpeakerDetail : UIViewController

- (IBAction)backBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *speakerImage;

@property (weak, nonatomic) IBOutlet UILabel *speakerName;

@property (weak, nonatomic) IBOutlet UILabel *speakerTitle;

@property (weak, nonatomic) IBOutlet UILabel *speakerPosition;
@property (weak, nonatomic) IBOutlet UITextView *aboutSpeaker;
@property SpeakersBean *speaker;
@end
