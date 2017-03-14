//
//  DBManager.h
//  ProjectDatabase
//
//  Created by JETS on 2/24/17.
//  Copyright (c) 2017 JETS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "SpeakersBean.h"
#import "AttendeeBean.h"
#import "SessionBean.h"
#import "ExhibitorsBean.h"

@interface DBManager : NSObject

+(DBManager*) sharedInstance;
//Create tables
-(Boolean) createTable :(NSString*) query;


//Clear tables
-(Boolean) clearTables :(NSString*) query;
-(SpeakersBean*)selectSpeaker:(int)speakerId;
//insert (fill) tables with beans
-(Boolean) insertInSpeakers :(SpeakersBean*) speaker;
-(Boolean) insertInAttendees :(AttendeeBean*) attendee;
-(Boolean) insertInSessions :(SessionBean*) session;
-(Boolean) insertInExhibitors :(ExhibitorsBean*) exhibitor;
-(Boolean) insertInSpeakerSession :(int)sessionId :(SpeakersBean*)speakerObj;

//get (select) data from tables
-(NSMutableArray*) selectFromSpeakers;
-(NSMutableArray*) selectFromAttendees;
-(NSMutableArray*) selectFromSessions;
-(NSMutableArray*) selectFromExhibitors;
-(NSMutableArray*) selectFromSpeakerSession :(int)sessionId;
-(void)updateExhibitor:(int)speakerId :(NSData *)sexhibitorImage;
//get (select) my sessions
-(NSMutableArray*) selectMySessions;

//get (select) speakers for specified session
//-(NSMutableArray*) selectSpeakersForSession :(NSString*) sessionName;

//get speakers images
-(NSMutableArray*) selectSpeakersImages;

//get exhibitors images
-(NSMutableArray*) selectExhibitorsImages;

-(void) updateSpeaker :(int) speakerId :(NSData*) speakerImage;

@property (strong , nonatomic) NSString *databasePath;

@property (nonatomic) sqlite3 *contactDB;

@property NSString *query;

@end
