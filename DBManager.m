//
//  DBManager.m
//  ProjectDatabase
//
//  Created by JETS on 2/24/17.
//  Copyright (c) 2017 JETS. All rights reserved.
//

#import "DBManager.h"
#import <sqlite3.h>

@implementation DBManager

- (id)init
{
    //Database create queries
    NSString *createSpeakersTable = @"CREATE TABLE IF NOT EXISTS SPEAKERS (ID INTEGER PRIMARY KEY AUTOINCREMENT, FIRSTNAME TEXT, LASTNAME TEXT, COMPANYNAME TEXT, TITLE TEXT, PHONES TEXT, MOBILES TEXT, MIDDLENAME TEXT, BIOGRAPHY TEXT, IMAGE BLOB, GENDER TEXT)";
    
    NSString *createAttendeesTable = @"CREATE TABLE IF NOT EXISTS ATTENDEE (ID INTEGER PRIMARY KEY AUTOINCREMENT, CODE TEXT, EMAIL TEXT, FIRSTNAME TEXT, LASTNAME TEXT, COUNTRYNAME TEXT, CITY TEXT, COMPANYNAME TEXT, TITLE TEXT, PHONES TEXT, MOBILES TEXT, MIDDLENAME TEXT, GENDER TEXT, IMAGE BLOB)";
    
    NSString *createSessionsTable = @"CREATE TABLE IF NOT EXISTS SESSIONS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, LOCATION TEXT, DESCRIPTION TEXT, SPEAKERS TEXT, STATUS INTEGER, STARTDATE TEXT, ENDDATE TEXT, SESSIONTYPE TEXT, LINKED TEXT, SESSIONTAGS TEXT, LIKED INTEGER, DAY INTEGER)";
    
    NSString *createExhibitorsTable = @"CREATE TABLE IF NOT EXISTS EXHIBITORS (ID INTEGER PRIMARY KEY AUTOINCREMENT, COMPANYADDRESS TEXT, EMAIL TEXT, COUNTRYNAME TEXT, CITYNAME TEXT, COMPANYNAME TEXT, PHONES TEXT, MOBILES TEXT, COMPANYABOUT TEXT, FAX TEXT, CONTACTNAME TEXT, CONTACTTITLE TEXT, COMPANYURL TEXT, IMAGE BLOB)";
    
    NSString *createSpeakerSessionTable = @"CREATE TABLE IF NOT EXISTS SPEAKER_SESSION (SESSION_ID INTEGER PRIMARY KEY, FIRSTNAME TEXT, LASTNAME TEXT, COMPANYNAME TEXT, IMAGE BLOB)";
    self = [super init];
    if (self) {
        [self createTable:createSessionsTable];
        [self createTable:createSpeakersTable];
        [self createTable:createAttendeesTable];
        [self createTable:createExhibitorsTable];
        [self createTable:createSpeakerSessionTable];
    }
    return self;
}

+(DBManager *)sharedInstance{
    static DBManager* sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[DBManager alloc] init];
    });
    return sharedInstance;
}

//create tables
-(Boolean)createTable:(NSString *)query{
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = dirPaths[0];
    
    // Build the path to the database file
    _databasePath = [[NSString alloc]initWithString: [docsDir stringByAppendingPathComponent:@"agenda.db"]];
    
    
    const char *dbpath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        char *errMsg;
        const char *sql_stmt = [query UTF8String];
        
        if (sqlite3_exec(_contactDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
        {
            //_status.text = @"Failed to create table";
            printf("Failed to create table\n");
        }else{
            printf("Table Created Successfully\n");
        }
        sqlite3_close(_contactDB);
        printf("Database Opened Successfully\n");
        return true;
    } else {
        //_status.text = @"Failed to open/create database";
        printf("Failed to open/create database\n");
        return false;
    }
    
}

//clear tables
-(Boolean)clearTables:(NSString *)query{
    const char *utf8Dbpath = [_databasePath UTF8String];
    static sqlite3_stmt *statement = NULL;
    
       
    if (sqlite3_open(utf8Dbpath, &_contactDB) == SQLITE_OK) {
        
        NSString *deleteQuery = query;
        
        const char *utf8DeleteQuery = [deleteQuery UTF8String];
        
        sqlite3_prepare_v2(_contactDB, utf8DeleteQuery, -1, &statement, NULL);
        
        if (sqlite3_step(statement) == SQLITE_DONE) {
            
            sqlite3_reset(statement);
            printf("Table deleted\n");
            return true;
        } else {
            sqlite3_reset(statement);
            printf("Error deleting table\n");
            return false;
        }
    } else {
        sqlite3_reset(statement);
        printf("Error openning database");
        return false;
    }
    
}

//insert into speakers
-(Boolean)insertInSpeakers:(SpeakersBean *)speaker{
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt* statement;
    
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        
        
        const char* sqliteQuery = "INSERT INTO SPEAKERS (ID, FIRSTNAME , LASTNAME , COMPANYNAME , TITLE , PHONES , MOBILES , MIDDLENAME , BIOGRAPHY , IMAGE , GENDER ) VALUES (?,?,?,?,?,?,?,?,?,?,?)";
        
        
        if( sqlite3_prepare_v2(_contactDB, sqliteQuery, -1, &statement, NULL) == SQLITE_OK )
        {
            //insert int
            sqlite3_bind_int(statement, 1, speaker.idd);
            //insert text
            sqlite3_bind_text(statement, 2, [[speaker firstName] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 3, [[speaker lastName] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 4, [[speaker companyName] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 5, [[speaker title] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 6, [[speaker phone] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 7, [[speaker mobile] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 8, [[speaker middleName] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 9, [[speaker biography] UTF8String], -1, SQLITE_TRANSIENT);
            
            //insert image
            sqlite3_bind_blob(statement, 10, [[speaker img] bytes], [[speaker img] length], SQLITE_TRANSIENT);
            //insert gender
            sqlite3_bind_text(statement, 11, [[speaker gender] UTF8String], -1, SQLITE_TRANSIENT);
            printf("Row inserted\n");
            sqlite3_step(statement);
            return true;
        }
        else NSLog( @"SaveBody: Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(_contactDB) );
        
        // Finalize and close database.
        sqlite3_finalize(statement);
        return false;
    }
    sqlite3_close(_contactDB);
    return true;
}

//insert into speaker_session
-(Boolean)insertInSpeakerSession:(int)sessionId :(SpeakersBean*)speakerObj{
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt* statement;
    
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        
        //CREATE TABLE IF NOT EXISTS SPEAKER_SESSION (SESSION_ID INTEGER PRIMARY KEY, FIRSTNAME TEXT, LASTNAME TEXT, COMPANYNAME TEXT, IMAGE BLOB
        const char* sqliteQuery = "INSERT INTO SPEAKER_SESSION (SESSION_ID, FIRSTNAME , LASTNAME , COMPANYNAME, IMAGE) VALUES (?,?,?,?,?)";
        
        
        if( sqlite3_prepare_v2(_contactDB, sqliteQuery, -1, &statement, NULL) == SQLITE_OK )
        {
                //insert int
                sqlite3_bind_int(statement, 1, sessionId);
                //insert text
                sqlite3_bind_text(statement, 2, [[speakerObj firstName] UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 3, [[speakerObj lastName] UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 4, [[speakerObj companyName] UTF8String], -1, SQLITE_TRANSIENT);
                //insert image
                sqlite3_bind_blob(statement, 5, [[speakerObj img] bytes], [[speakerObj img] length], SQLITE_TRANSIENT);
            
                printf("\nRow inserted\n");
                sqlite3_step(statement);
                return true;
        }
        else NSLog( @"SaveBody: Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(_contactDB));
        
        // Finalize and close database.
        sqlite3_finalize(statement);
        return false;
    }
    sqlite3_close(_contactDB);
    return true;
}

//insert into attendees
-(Boolean)insertInAttendees:(AttendeeBean *)attendee{
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt* statement;
    
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        
        
        const char* sqliteQuery = "INSERT INTO ATTENDEE (ID, CODE , EMAIL , FIRSTNAME , LASTNAME , COUNTRYNAME , CITY , COMPANYNAME , TITLE , PHONES , MOBILES , MIDDLENAME , GENDER , IMAGE ) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        
        //NSString *q =  [NSString stringWithFormat:@"INSERT INTO ATTENDEE (ID, CODE , EMAIL , FIRSTNAME , LASTNAME , COUNTRYNAME , CITY , COMPANYNAME , TITLE , PHONES , MOBILES , MIDDLENAME , GENDER , IMAGE) VALUES (\"%d\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",attendee.idd, attendee.code, attendee.email, attendee.firstName, attendee.lastName, attendee.countryName, attendee.city, attendee.companyName, attendee.title, attendee.phone, attendee.mobile, attendee.middleName, attendee.gender, attendee.img];
        
        if( sqlite3_prepare_v2(_contactDB, sqliteQuery, -1, &statement, NULL) == SQLITE_OK )
        {
            //insert int
            sqlite3_bind_int(statement, 1, attendee.idd);
            //insert text
            if([attendee code]==nil || [[attendee code] isEqual:[NSNull null]]){
                attendee.code=@"";
                sqlite3_bind_text(statement, 2, [[attendee code] UTF8String], -1, SQLITE_TRANSIENT);
            }else{
                sqlite3_bind_text(statement, 2, [[attendee code] UTF8String], -1, SQLITE_TRANSIENT);
            }
            
            if([attendee email]==nil || [[attendee email] isEqual:[NSNull null]]){
                attendee.email=@"";
                 sqlite3_bind_text(statement, 3, [[attendee email] UTF8String], -1, SQLITE_TRANSIENT);
            }else{
                 sqlite3_bind_text(statement, 3, [[attendee email] UTF8String], -1, SQLITE_TRANSIENT);
            }
           
            if([attendee firstName]==nil || [[attendee firstName] isEqual:[NSNull null]]){
                attendee.firstName=@"";
                sqlite3_bind_text(statement, 4, [[attendee firstName] UTF8String], -1, SQLITE_TRANSIENT);
            }else{
                sqlite3_bind_text(statement, 4, [[attendee firstName] UTF8String], -1, SQLITE_TRANSIENT);
            }
            
            if([attendee lastName]==nil || [[attendee lastName] isEqual:[NSNull null]]){
                attendee.lastName=@"";
                sqlite3_bind_text(statement, 5, [[attendee lastName] UTF8String], -1, SQLITE_TRANSIENT);
            }else{
                sqlite3_bind_text(statement, 5, [[attendee lastName] UTF8String], -1, SQLITE_TRANSIENT);
            }
            
            if([attendee countryName]==nil || [[attendee countryName] isEqual:[NSNull null]]){
                attendee.countryName=@"";
                 sqlite3_bind_text(statement, 6, [[attendee countryName] UTF8String], -1, SQLITE_TRANSIENT);
            }else{
                 sqlite3_bind_text(statement, 6, [[attendee countryName] UTF8String], -1, SQLITE_TRANSIENT);
            }
           
            if([attendee city]==nil || [[attendee city] isEqual:[NSNull null]]){
                attendee.city=@"";
                
                sqlite3_bind_text(statement, 7, [[attendee city] UTF8String], -1, SQLITE_TRANSIENT);
            }else{
                sqlite3_bind_text(statement, 7, [[attendee city] UTF8String], -1, SQLITE_TRANSIENT);
            }
            
            if([attendee companyName]==nil || [[attendee companyName] isEqual:[NSNull null]]){
                    attendee.companyName=@"";
                  sqlite3_bind_text(statement, 8, [[attendee companyName] UTF8String], -1, SQLITE_TRANSIENT);
            }else{
                  sqlite3_bind_text(statement, 8, [[attendee companyName] UTF8String], -1, SQLITE_TRANSIENT);
            }
          
            if([attendee title]==nil || [[attendee title] isEqual:[NSNull null]]){
                attendee.title=@"";
                 sqlite3_bind_text(statement, 9, [[attendee title] UTF8String], -1, SQLITE_TRANSIENT);
            }else{
                 sqlite3_bind_text(statement, 9, [[attendee title] UTF8String], -1, SQLITE_TRANSIENT);
            }
            
            if([attendee phone]==nil || [[attendee phone] isEqual:[NSNull null]]){
                attendee.phone=@"";
                sqlite3_bind_text(statement, 10, [[attendee phone] UTF8String], -1, SQLITE_TRANSIENT);
            }else{
                sqlite3_bind_text(statement, 10, [[attendee phone] UTF8String], -1, SQLITE_TRANSIENT);
                
            }
            
            if([attendee mobile]==nil || [[attendee mobile] isEqual:[NSNull null]]){
                attendee.mobile=@"";
                sqlite3_bind_text(statement, 11, [[attendee mobile] UTF8String], -1, SQLITE_TRANSIENT);
            }else{
                sqlite3_bind_text(statement, 11, [[attendee mobile] UTF8String], -1, SQLITE_TRANSIENT);
            }
            
            if([attendee middleName]==nil || [[attendee middleName] isEqual:[NSNull null]]){
                attendee.middleName=@"";
                sqlite3_bind_text(statement, 12, [[attendee middleName] UTF8String], -1, SQLITE_TRANSIENT);
            }else{
                sqlite3_bind_text(statement, 12, [[attendee middleName] UTF8String], -1, SQLITE_TRANSIENT);
                
            }
            
            if([attendee gender]==nil || [[attendee gender] isEqual:[NSNull null]]){
                attendee.gender=@"";
                sqlite3_bind_text(statement, 13, [[attendee gender] UTF8String], -1, SQLITE_TRANSIENT);
            }else{
                sqlite3_bind_text(statement, 13, [[attendee gender] UTF8String], -1, SQLITE_TRANSIENT);
            }
            //insert image
            sqlite3_bind_blob(statement, 14, [[attendee img] bytes], [[attendee img] length], SQLITE_TRANSIENT);
           
            
            printf("Row inserted\n");
            sqlite3_step(statement);
            return true;
        }
        else NSLog( @"SaveBody: Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(_contactDB) );
        
        // Finalize and close database.
        sqlite3_finalize(statement);
        return false;
    }
    sqlite3_close(_contactDB);
    return true;

}

//insert into sessions
-(Boolean)insertInSessions:(SessionBean *)session{
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt* statement=nil;
    
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        const char* sqliteQuery = "INSERT INTO SESSIONS (ID, NAME , LOCATION , DESCRIPTION , STATUS , STARTDATE , ENDDATE , SESSIONTYPE , LINKED , SESSIONTAGS , LIKED, DAY) VALUES (?,?,?,?,?,?,?,?,?,?,?,?)";
        
//        /Users/jets/Library/Developer/CoreSimulator/Devices/73E012B2-1608-423C-BFC5-50E5E580FD8C/data/Containers/Data/Application/BB3EB719-7E10-46A7-AFB7-93AAB6534CDD/Documents
        
        printf("Database path : %s", [_databasePath UTF8String]);
        if( sqlite3_prepare_v2(_contactDB, sqliteQuery, -1, &statement, NULL) == SQLITE_OK )
        {
            //insert int
            sqlite3_bind_int(statement, 1, session.idd);
            //insert text
            sqlite3_bind_text(statement, 2, [[session name] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 3, [[session session_location] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 4, [[session descript] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_int(statement, 5, session.status);
            NSString* sdate =[NSString stringWithFormat:@"%@",[session startDate]];
            sqlite3_bind_text(statement, 6, [sdate UTF8String], -1, SQLITE_TRANSIENT);
            if([session endDate]==nil || [[session endDate] isEqual:[NSNull null]]){
                session.endDate =@"";
                sqlite3_bind_text(statement, 7, [[session endDate] UTF8String], -1, SQLITE_TRANSIENT);
            }else{
                NSString* edate =[NSString stringWithFormat:@"%@",[session endDate]];
                sqlite3_bind_text(statement, 7, [edate UTF8String], -1, SQLITE_TRANSIENT);
            }
           
            sqlite3_bind_text(statement, 8, [[session sessionType] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 9, [[session linked] UTF8String], -1, SQLITE_TRANSIENT);
            
            if([session sessionTags]==nil || [[session sessionTags] isEqual:[NSNull null]] ){
                session.sessionTags=@"";
                sqlite3_bind_text(statement, 10, [[session sessionTags] UTF8String], -1, SQLITE_TRANSIENT);
            }else{
                sqlite3_bind_text(statement, 10, [[session sessionTags] UTF8String], -1, SQLITE_TRANSIENT);
            }
            sqlite3_bind_int(statement, 11, session.liked);
            sqlite3_bind_int(statement, 12, session.day);
            
            
            printf("Row inserted\n");
            sqlite3_step(statement);
            return true;
        }
        else NSLog( @"SaveBody: Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(_contactDB) );
        
        // Finalize and close database.
        sqlite3_finalize(statement);
        return false;
    }
    sqlite3_close(_contactDB);
    return true;
}

//insert into exhibitors
-(Boolean)insertInExhibitors:(ExhibitorsBean *)exhibitor{
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt* statement=NULL;
    
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        
        
        const char* sqliteQuery = "INSERT INTO EXHIBITORS (ID, COMPANYADDRESS , EMAIL , COUNTRYNAME , CITYNAME , COMPANYNAME , PHONES  , MOBILES , COMPANYABOUT , FAX , CONTACTNAME , CONTACTTITLE , COMPANYURL , IMAGE ) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        
        
        if( sqlite3_prepare_v2(_contactDB, sqliteQuery, -1, &statement, NULL) == SQLITE_OK )
        {
            //insert int
            sqlite3_bind_int(statement, 1, exhibitor.idd);
            //insert text
            sqlite3_bind_text(statement, 2, [[exhibitor companyAddress] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 3, [[exhibitor email] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 4, [[exhibitor countryName] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 5, [[exhibitor cityName] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 6, [[exhibitor companyName] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 7, [[exhibitor phone] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 8, [[exhibitor mobile] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 9, [[exhibitor companyAbout] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 10, [[exhibitor fax] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 11, [[exhibitor contactName] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 12, [[exhibitor contactTitle] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 13, [[exhibitor companyUrl] UTF8String], -1, SQLITE_TRANSIENT);
            
            //insert image
            sqlite3_bind_blob(statement, 14, [[exhibitor img] bytes], [[exhibitor img] length], SQLITE_TRANSIENT);
            
            printf("Row inserted\n");
            
            sqlite3_step(statement);
            sqlite3_finalize(statement);
            return true;
        }
        else NSLog( @"SaveBody: Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(_contactDB) );
        
        // Finalize and close database.
        sqlite3_finalize(statement);
        return false;
    }
    sqlite3_close(_contactDB);
    return true;
}

//get speakers data
-(NSMutableArray *)selectFromSpeakers{
    NSMutableArray *array = [NSMutableArray new];
    
    
    // Open the database
    if(sqlite3_open([_databasePath UTF8String], &_contactDB) == SQLITE_OK)
    {
        // Setup the SQL Statement and compile it for faster access
        
        //SQLIte Statement
        NSString *sqlStatement =[NSString stringWithFormat:@"Select ID , FIRSTNAME , LASTNAME , COMPANYNAME , TITLE , PHONES , MOBILES , MIDDLENAME , BIOGRAPHY , IMAGE , GENDER from SPEAKERS"];
        
        sqlite3_stmt *compiledStatement;
        
        
        if(sqlite3_prepare_v2(_contactDB, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            
            // Loop through the results and add them to the feeds array
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                // Init the Data Dictionary
                SpeakersBean *speaker = [SpeakersBean new];
                
                int myId = sqlite3_column_int(compiledStatement, 0);
                
                NSString *firstName = ((char *)sqlite3_column_text(compiledStatement, 1)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)] : nil;
                
                NSString *lastName = ((char *)sqlite3_column_text(compiledStatement, 2)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)] : nil;
                
                NSString *companyName = ((char *)sqlite3_column_text(compiledStatement, 3)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)] : nil;
                
                NSString *title = ((char *)sqlite3_column_text(compiledStatement, 4)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)] : nil;
                
                NSString *phone = ((char *)sqlite3_column_text(compiledStatement, 5)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)] : nil;
                
                NSString *mobile = ((char *)sqlite3_column_text(compiledStatement, 6)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)] : nil;
                
                NSString *middleName = ((char *)sqlite3_column_text(compiledStatement, 7)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)] : nil;
                
                NSString *biography = ((char *)sqlite3_column_text(compiledStatement, 8)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 8)] : nil;
                
                int length = sqlite3_column_bytes(compiledStatement, 9);
                NSData *imageData = [NSData dataWithBytes:sqlite3_column_blob(compiledStatement, 9) length:length];
                
                NSString *gender = ((char *)sqlite3_column_text(compiledStatement, 10)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 10)] : nil;
                ///////////////////////////////////////////////////////////////
                speaker.idd = myId;
                speaker.firstName = firstName;
                speaker.lastName = lastName;
                speaker.companyName = companyName;
                speaker.title = title;
                speaker.phone = phone;
                speaker.mobile = mobile;
                speaker.middleName = middleName;
                speaker.biography = biography;
                speaker.img = imageData;
                speaker.gender = gender;
                //Add object to array
                [array addObject:speaker];
            }
        }
        else
        {
            NSLog(@"No Data Found");
        }
        
        // Release the compiled statement from memory
        sqlite3_finalize(compiledStatement);
    }
    
    sqlite3_close(_contactDB);
    
    return array;
}

//get speaker_session data
-(NSMutableArray *)selectFromSpeakerSession :(int)sessionId{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    //INSERT INTO SPEAKER_SESSION (SESSION_ID, FIRSTNAME , LASTNAME , COMPANYNAME, IMAGE)
    
    // Open the database
    if(sqlite3_open([_databasePath UTF8String], &_contactDB) == SQLITE_OK)
    {
        // Setup the SQL Statement and compile it for faster access
        
        //SQLIte Statement
        NSString *sqlStatement =[NSString stringWithFormat:@"Select SESSION_ID , FIRSTNAME , LASTNAME , COMPANYNAME, IMAGE from SPEAKER_SESSION WHERE SESSION_ID = \"%d\"", sessionId];
        
        sqlite3_stmt *compiledStatement;
        
        
        if(sqlite3_prepare_v2(_contactDB, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            
            // Loop through the results and add them to the feeds array
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                // Init the Data Dictionary
                SpeakersBean *speaker = [SpeakersBean new];
                
                int sessionId = sqlite3_column_int(compiledStatement, 0);
                
                NSString *firstName = ((char *)sqlite3_column_text(compiledStatement, 1)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)] : nil;
                
                NSString *lastName = ((char *)sqlite3_column_text(compiledStatement, 2)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)] : nil;
                
                NSString *companyName = ((char *)sqlite3_column_text(compiledStatement, 3)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)] : nil;
                
                
                int length = sqlite3_column_bytes(compiledStatement, 4);
                NSData *imageData = [NSData dataWithBytes:sqlite3_column_blob(compiledStatement, 4) length:length];
                ///////////////////////////////////////////////////////////////
                speaker.idd = sessionId;
                speaker.firstName = firstName;
                speaker.lastName = lastName;
                speaker.companyName = companyName;
                speaker.img = imageData;
                //Add object to array
                [array addObject:speaker];
            }
        }
        else
        {
            NSLog(@"No Data Found");
        }
        
        // Release the compiled statement from memory
        sqlite3_finalize(compiledStatement);
    }
    
    sqlite3_close(_contactDB);
    
    return array;
}

//get attendees data
-(NSMutableArray *)selectFromAttendees{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    
    // Open the database
    if(sqlite3_open([_databasePath UTF8String], &_contactDB) == SQLITE_OK)
    {
        // Setup the SQL Statement and compile it for faster access
        
        //SQLIte Statement
        NSString *sqlStatement =[NSString stringWithFormat:@"Select ID, CODE , EMAIL , FIRSTNAME , LASTNAME , COUNTRYNAME , CITY , COMPANYNAME , TITLE , PHONES , MOBILES , MIDDLENAME , GENDER , IMAGE from ATTENDEE"];
        
        sqlite3_stmt *compiledStatement;
        
        
        if(sqlite3_prepare_v2(_contactDB, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            
            // Loop through the results and add them to the feeds array
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                // Init the Data Dictionary
                AttendeeBean *attendee = [AttendeeBean new];
                
                int myId = sqlite3_column_int(compiledStatement, 0);
                
                NSString *code = ((char *)sqlite3_column_text(compiledStatement, 1)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)] : nil;
                
                NSString *email = ((char *)sqlite3_column_text(compiledStatement, 2)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)] : nil;
                
                NSString *firstName = ((char *)sqlite3_column_text(compiledStatement, 3)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)] : nil;
                
                NSString *lastName = ((char *)sqlite3_column_text(compiledStatement, 4)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)] : nil;
                
                NSString *countryName = ((char *)sqlite3_column_text(compiledStatement, 5)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)] : nil;
                
                NSString *city = ((char *)sqlite3_column_text(compiledStatement, 6)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)] : nil;
                
                NSString *companyName = ((char *)sqlite3_column_text(compiledStatement, 7)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)] : nil;
                
                NSString *title = ((char *)sqlite3_column_text(compiledStatement, 8)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 8)] : nil;
                
                NSString *phone = ((char *)sqlite3_column_text(compiledStatement, 9)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 9)] : nil;
                
                NSString *mobile = ((char *)sqlite3_column_text(compiledStatement, 10)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 10)] : nil;
                
                NSString *middleName = ((char *)sqlite3_column_text(compiledStatement, 11)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 11)] : nil;
                
                NSString *gender = ((char *)sqlite3_column_text(compiledStatement, 12)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 12)] : nil;
                
                
                int length = sqlite3_column_bytes(compiledStatement, 13);
                NSData *imageData = [NSData dataWithBytes:sqlite3_column_blob(compiledStatement, 13) length:length];
                ///////////////////////////////////////////////////////////////
                attendee.idd = myId;
                attendee.code = code;
                attendee.email = email;
                attendee.firstName = firstName;
                attendee.lastName = lastName;
                attendee.countryName = countryName;
                attendee.city = city;
                attendee.companyName = companyName;
                attendee.title = title;
                attendee.phone = phone;
                attendee.mobile = mobile;
                attendee.middleName = middleName;
                attendee.gender = gender;
                attendee.img = imageData;
                
                //Add object to array
                [array addObject:attendee];
            }
        }
        else
        {
            NSLog(@"No Data Found");
        }
        
        // Release the compiled statement from memory
        sqlite3_finalize(compiledStatement);
    }
    
    sqlite3_close(_contactDB);
    
    return array;
}

//get sessions data
-(NSMutableArray *)selectFromSessions{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    
    // Open the database
    if(sqlite3_open([_databasePath UTF8String], &_contactDB) == SQLITE_OK)
    {
        // Setup the SQL Statement and compile it for faster access
        
        //SQLIte Statement
        NSString *sqlStatement =[NSString stringWithFormat:@"Select ID , NAME , LOCATION , DESCRIPTION , SPEAKERS , STATUS , STARTDATE , ENDDATE , SESSIONTYPE , LINKED , SESSIONTAGS , LIKED , DAY from SESSIONS"];
        
        sqlite3_stmt *compiledStatement;
        
        
        if(sqlite3_prepare_v2(_contactDB, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            
            // Loop through the results and add them to the feeds array
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                // Init the Data Dictionary
                SessionBean *session = [SessionBean new];
                
                int myId = sqlite3_column_int(compiledStatement, 0);
                
                NSString *name = ((char *)sqlite3_column_text(compiledStatement, 1)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)] : nil;
                
                NSString *location = ((char *)sqlite3_column_text(compiledStatement, 2)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)] : nil;
                
                NSString *description = ((char *)sqlite3_column_text(compiledStatement, 3)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)] : nil;
                
                NSString *speakers = ((char *)sqlite3_column_text(compiledStatement, 4)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)] : nil;
                
                int status = sqlite3_column_int(compiledStatement, 5);
                
                NSString *startDate = ((char *)sqlite3_column_text(compiledStatement, 6)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)] : nil;
                
                NSString *endDate = ((char *)sqlite3_column_text(compiledStatement, 7)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)] : nil;
                
                NSString *sessionType = ((char *)sqlite3_column_text(compiledStatement, 8)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 8)] : nil;
                
                NSString *linked = ((char *)sqlite3_column_text(compiledStatement, 9)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 9)] : nil;
                
                NSString *sessionTags =((char *)sqlite3_column_text(compiledStatement, 10)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 10)] : nil;
                
                
                int liked = sqlite3_column_int(compiledStatement, 11);
                int day = sqlite3_column_int(compiledStatement, 12);
                ///////////////////////////////////////////////////////////////
                session.idd = myId;
                session.name = name;
                session.session_location = location;
                session.descript = description;
                session.speakers = speakers;
                session.status = status;
                session.startDate = startDate;
                session.endDate = endDate;
                session.sessionType = sessionType;
                session.linked = linked;
                session.sessionTags = sessionTags;
                session.liked = liked;
                session.day = day;
                
                //Add object to array
                [array addObject:session];
            }
        }
        else
        {
            NSLog(@"No Data Found");
        }
        
        // Release the compiled statement from memory
        sqlite3_finalize(compiledStatement);
    }
    
    sqlite3_close(_contactDB);
    
    return array;
}

//get exhibitors data
-(NSMutableArray *)selectFromExhibitors{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    
    // Open the database
    if(sqlite3_open([_databasePath UTF8String], &_contactDB) == SQLITE_OK)
    {
        // Setup the SQL Statement and compile it for faster access
        
        //SQLIte Statement
        NSString *sqlStatement =[NSString stringWithFormat:@"Select ID , COMPANYADDRESS , EMAIL , COUNTRYNAME , CITYNAME , COMPANYNAME , PHONES , MOBILES , COMPANYABOUT , FAX , CONTACTNAME , CONTACTTITLE , COMPANYURL , IMAGE from EXHIBITORS"];
        
        sqlite3_stmt *compiledStatement;
        
        
        if(sqlite3_prepare_v2(_contactDB, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            
            // Loop through the results and add them to the feeds array
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                // Init the Data Dictionary
                ExhibitorsBean *exhibitor = [ExhibitorsBean new];
                
                int myId = sqlite3_column_int(compiledStatement, 0);
                
                NSString *companyAddress = ((char *)sqlite3_column_text(compiledStatement, 1)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)] : nil;
                
                NSString *email = ((char *)sqlite3_column_text(compiledStatement, 2)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)] : nil;
                
                NSString *countryName = ((char *)sqlite3_column_text(compiledStatement, 3)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)] : nil;
                
                NSString *cityName = ((char *)sqlite3_column_text(compiledStatement, 4)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)] : nil;
                
                NSString *companyName = ((char *)sqlite3_column_text(compiledStatement, 5)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)] : nil;
                
                NSString *phone = ((char *)sqlite3_column_text(compiledStatement, 6)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)] : nil;
                
                NSString *mobile = ((char *)sqlite3_column_text(compiledStatement, 7)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)] : nil;
                
                NSString *companyAbout = ((char *)sqlite3_column_text(compiledStatement, 8)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 8)] : nil;
                
                NSString *fax = ((char *)sqlite3_column_text(compiledStatement, 9)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 9)] : nil;
                
                NSString *contactName = ((char *)sqlite3_column_text(compiledStatement, 10)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 10)] : nil;
                
                NSString *contactTitle = ((char *)sqlite3_column_text(compiledStatement, 11)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 11)] : nil;
                
                NSString *companyUrl = ((char *)sqlite3_column_text(compiledStatement, 12)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 12)] : nil;
                
                int length = sqlite3_column_bytes(compiledStatement, 13);
                NSData *imageData = [NSData dataWithBytes:sqlite3_column_blob(compiledStatement, 13) length:length];
                ///////////////////////////////////////////////////////////////
                exhibitor.idd = myId;
                exhibitor.companyAddress = companyAddress;
                exhibitor.email = email;
                exhibitor.countryName = countryName;
                exhibitor.cityName = cityName;
                exhibitor.companyName = companyName;
                exhibitor.phone = phone;
                exhibitor.mobile = mobile;
                exhibitor.companyAbout = companyAbout;
                exhibitor.fax = fax;
                exhibitor.contactName = contactName;
                exhibitor.contactTitle = contactTitle;
                exhibitor.companyUrl = companyUrl;
                exhibitor.img = imageData;
                
                //Add object to array
                [array addObject:exhibitor];
            }
        }
        else
        {
            NSLog(@"No Data Found");
        }
        
        // Release the compiled statement from memory
        sqlite3_finalize(compiledStatement);
    }
    
    sqlite3_close(_contactDB);
    
    return array;
}
//////////////////////////////////////////////////
//get my agenda (liked sessions)
-(NSMutableArray *)selectMySessions{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    
    // Open the database
    if(sqlite3_open([_databasePath UTF8String], &_contactDB) == SQLITE_OK)
    {
        // Setup the SQL Statement and compile it for faster access
        
        //SQLIte Statement
        NSString *sqlStatement =[NSString stringWithFormat:@"Select ID , NAME , LOCATION , DESCRIPTION , SPEAKERS , STATUS , STARTDATE , ENDDATE , SESSIONTYPE , LINKED , SESSIONTAGS , LIKED , DAY from SESSIONS where liked = 1"];
        
        sqlite3_stmt *compiledStatement;
        
        
        if(sqlite3_prepare_v2(_contactDB, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            
            // Loop through the results and add them to the feeds array
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                // Init the Data Dictionary
                SessionBean *session = [SessionBean new];
                
                int myId = sqlite3_column_int(compiledStatement, 0);
                
                NSString *name = ((char *)sqlite3_column_text(compiledStatement, 1)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)] : nil;
                
                NSString *location = ((char *)sqlite3_column_text(compiledStatement, 2)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)] : nil;
                
                NSString *description = ((char *)sqlite3_column_text(compiledStatement, 3)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)] : nil;
                
                NSString *speakers = ((char *)sqlite3_column_text(compiledStatement, 4)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)] : nil;
                
                int status = sqlite3_column_int(compiledStatement, 5);
                
                NSString *startDate = ((char *)sqlite3_column_text(compiledStatement, 6)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)] : nil;
                
                NSString *endDate = ((char *)sqlite3_column_text(compiledStatement, 7)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)] : nil;
                
                NSString *sessionType = ((char *)sqlite3_column_text(compiledStatement, 8)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 8)] : nil;
                
                NSString *linked = ((char *)sqlite3_column_text(compiledStatement, 9)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 9)] : nil;
                
                NSString *sessionTags =((char *)sqlite3_column_text(compiledStatement, 10)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 10)] : nil;
                
                int liked = sqlite3_column_int(compiledStatement, 11);
                
                int day = sqlite3_column_int(compiledStatement, 12);
                ///////////////////////////////////////////////////////////////
                session.idd = myId;
                session.name = name;
                session.session_location = location;
                session.descript = description;
                session.speakers = speakers;
                session.status = status;
                session.startDate = startDate;
                session.endDate = endDate;
                session.sessionType = sessionType;
                session.linked = linked;
                session.sessionTags = sessionTags;
                session.liked = liked;
                session.day = day;
                
                //Add object to array
                [array addObject:session];
            }
        }
        else
        {
            NSLog(@"No Data Found");
        }
        
        // Release the compiled statement from memory
        sqlite3_finalize(compiledStatement);
    }
    
    sqlite3_close(_contactDB);
    
    return array;
}

//get speakers images
-(NSMutableArray *)selectSpeakersImages{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    
    // Open the database
    if(sqlite3_open([_databasePath UTF8String], &_contactDB) == SQLITE_OK)
    {
        // Setup the SQL Statement and compile it for faster access
        
        //SQLIte Statement
        NSString *sqlStatement =[NSString stringWithFormat:@"Select IMAGE from SPEAKERS"];
        
        sqlite3_stmt *compiledStatement;
        
        
        if(sqlite3_prepare_v2(_contactDB, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            
            // Loop through the results and add them to the feeds array
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                int length = sqlite3_column_bytes(compiledStatement, 9);
                NSData *imageData = [NSData dataWithBytes:sqlite3_column_blob(compiledStatement, 9) length:length];
                UIImage *uiImg = [UIImage imageWithData:imageData];
                ///////////////////////////////////////////////////////////////
                //Add object to array
                [array addObject:uiImg];
            }
        }
        else
        {
            NSLog(@"No Data Found");
        }
        
        // Release the compiled statement from memory
        sqlite3_finalize(compiledStatement);
    }
    
    sqlite3_close(_contactDB);
    
    return array;
}
////////////////////////////////////////////////////////
//get exhibitors images
-(NSMutableArray *)selectExhibitorsImages{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    
    // Open the database
    if(sqlite3_open([_databasePath UTF8String], &_contactDB) == SQLITE_OK)
    {
        // Setup the SQL Statement and compile it for faster access
        
        //SQLIte Statement
        NSString *sqlStatement =[NSString stringWithFormat:@"Select IMAGE from EXHIBITORS"];
        
        sqlite3_stmt *compiledStatement;
        
        
        if(sqlite3_prepare_v2(_contactDB, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            
            // Loop through the results and add them to the feeds array
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                int length = sqlite3_column_bytes(compiledStatement, 9);
                NSData *imageData = [NSData dataWithBytes:sqlite3_column_blob(compiledStatement, 9) length:length];
                UIImage *uiImg = [UIImage imageWithData:imageData];
                ///////////////////////////////////////////////////////////////
                //Add object to array
                [array addObject:uiImg];
            }
        }
        else
        {
            NSLog(@"No Data Found");
        }
        
        // Release the compiled statement from memory
        sqlite3_finalize(compiledStatement);
    }
    
    sqlite3_close(_contactDB);
    
    return array;
}


-(void)updateSpeaker:(int)speakerId :(NSData *)speakerImage{
    sqlite3_stmt *updateStmt = NULL;
    const char *dbpath = [_databasePath UTF8String];
    
    if(sqlite3_open(dbpath, &_contactDB) == SQLITE_OK){
        
        
        const char *sql = "UPDATE SPEAKERS Set IMAGE = ? WHERE ID = ?";
        
        if(sqlite3_prepare_v2(_contactDB, sql, -1, &updateStmt, NULL)==SQLITE_OK){
            //update image
            sqlite3_bind_blob(updateStmt, 1, [speakerImage bytes], [speakerImage length], SQLITE_TRANSIENT);
            sqlite3_bind_int(updateStmt, 2, speakerId);
        }
    }
    char* errmsg;
    sqlite3_exec(_contactDB, "COMMIT", NULL, NULL, &errmsg);
    
    if(SQLITE_DONE != sqlite3_step(updateStmt)){
        NSLog(@"Error while updating. %s", sqlite3_errmsg(_contactDB));
    }
    else{
        printf("Speaker data updated successfully");
    }
    sqlite3_finalize(updateStmt);
    sqlite3_close(_contactDB);
}


-(void)updateExhibitor:(int)speakerId :(NSData *)sexhibitorImage{
    sqlite3_stmt *updateStmt = NULL;
    const char *dbpath = [_databasePath UTF8String];
    
    if(sqlite3_open(dbpath, &_contactDB) == SQLITE_OK){
        
        
        const char *sql = "UPDATE EXHIBITORS Set IMAGE = ? WHERE ID = ?";
        
        if(sqlite3_prepare_v2(_contactDB, sql, -1, &updateStmt, NULL)==SQLITE_OK){
            //update image
            sqlite3_bind_blob(updateStmt, 1, [sexhibitorImage bytes], [sexhibitorImage length], SQLITE_TRANSIENT);
            sqlite3_bind_int(updateStmt, 2, speakerId);
        }
    }
    char* errmsg;
    sqlite3_exec(_contactDB, "COMMIT", NULL, NULL, &errmsg);
    
    if(SQLITE_DONE != sqlite3_step(updateStmt)){
        NSLog(@"Error while updating. %s", sqlite3_errmsg(_contactDB));
    }
    else{
        printf("Speaker data updated successfully");
    }
    sqlite3_finalize(updateStmt);
    sqlite3_close(_contactDB);
}






//get speaker by id
-(SpeakersBean*)selectSpeaker:(int)speakerId{
    SpeakersBean *speaker = [SpeakersBean new];
    // Open the database
    if(sqlite3_open([_databasePath UTF8String], &_contactDB) == SQLITE_OK)
    {
        // Setup the SQL Statement and compile it for faster access
        
        //SQLIte Statement
        NSString *sqlStatement =[NSString stringWithFormat:@"Select ID , FIRSTNAME , LASTNAME , COMPANYNAME , TITLE , PHONES , MOBILES , MIDDLENAME , BIOGRAPHY , IMAGE , GENDER from SPEAKERS WHERE ID = \"%d\"", speakerId];
        
        sqlite3_stmt *compiledStatement = NULL;
        
        
        if(sqlite3_prepare_v2(_contactDB, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            
            if(sqlite3_step(compiledStatement) == SQLITE_ROW){
                
                int myId = sqlite3_column_int(compiledStatement, 0);
                
                NSString *firstName = ((char *)sqlite3_column_text(compiledStatement, 1)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)] : nil;
                
                NSString *lastName = ((char *)sqlite3_column_text(compiledStatement, 2)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)] : nil;
                
                NSString *companyName = ((char *)sqlite3_column_text(compiledStatement, 3)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)] : nil;
                
                NSString *title = ((char *)sqlite3_column_text(compiledStatement, 4)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)] : nil;
                
                NSString *phone = ((char *)sqlite3_column_text(compiledStatement, 5)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)] : nil;
                
                NSString *mobile = ((char *)sqlite3_column_text(compiledStatement, 6)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)] : nil;
                
                NSString *middleName = ((char *)sqlite3_column_text(compiledStatement, 7)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)] : nil;
                
                NSString *biography = ((char *)sqlite3_column_text(compiledStatement, 8)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 8)] : nil;
                
                int length = sqlite3_column_bytes(compiledStatement, 9);
                NSData *imageData = [NSData dataWithBytes:sqlite3_column_blob(compiledStatement, 9) length:length];
                
                NSString *gender = ((char *)sqlite3_column_text(compiledStatement, 10)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 10)] : nil;
                ///////////////////////////////////////////////////////////////
                speaker.idd = myId;
                speaker.firstName = firstName;
                speaker.lastName = lastName;
                speaker.companyName = companyName;
                speaker.title = title;
                speaker.phone = phone;
                speaker.mobile = mobile;
                speaker.middleName = middleName;
                speaker.biography = biography;
                speaker.img = imageData;
                speaker.gender = gender;
            }
        }
        else
        {
            NSLog(@"No Data Found");
        }
        
        // Release the compiled statement from memory
        sqlite3_finalize(compiledStatement);
    }
    
    sqlite3_close(_contactDB);
    
    return speaker;
}


















@end
