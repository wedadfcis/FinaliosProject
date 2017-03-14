//
//  SpeakerDetail.m
//  iOSProject
//
//  Created by JETS on 3/10/17.
//  Copyright © 2017 Appcoda. All rights reserved.
//

#import "SpeakerDetail.h"
#import "DBManager.h"


@interface SpeakerDetail ()

@end

@implementation SpeakerDetail{
    DBManager *dbobj;
    SpeakersBean * speakerobj;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dbobj=[DBManager sharedInstance];
    
    speakerobj=[SpeakersBean new];
    
    speakerobj=[dbobj selectSpeaker:_speaker.idd];
    
    self.speakerTitle.preferredMaxLayoutWidth = 250;
    [_speakerTitle setFont: [_speakerTitle.font fontWithSize: 12]];
    NSString *space =@" ";

     NSString *all= [[_speaker.firstName stringByAppendingString:space] stringByAppendingString:_speaker.lastName ];
    
    [_speakerImage setImage:[UIImage imageWithData:speakerobj.img]];
    [_speakerName setText:all];
    [_speakerPosition setText:_speaker.companyName];
    [_aboutSpeaker setText:_speaker.biography];
    [_speakerTitle setText:_speaker.title];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}

@end
