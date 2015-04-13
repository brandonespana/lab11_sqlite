/**
 * Copyright 2015 Tim Lindquist,
 * <p/>
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * <p/>
 * http://www.apache.org/licenses/LICENSE-2.0
 * <p/>
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * <p/>
 * Purpose: A sample Objective-C class to wrap the c-Language binding calls for sqlite3
 * although Apple recommends use of core data instead of sqlite3 (and these are
 * good facilities), if an app developer has a corresponding app (on any platform)
 * that uses Sqlite3, then its the right choice.
 *
 * To learn about the C-Language bindings for Sqlite see:
 *
 *  Reference:  https://www.sqlite.org/capi3ref.html
 *  Introduction:  https://www.sqlite.org/cintro.html
 *
 * Best Practices:
 *   (1) close the db as soon as you are done. On limited memory
 *       device, the space of keeping open connection often out weighs time
 *   (2) Do batch inserts and updates by wrappoing them in a transaction
 *       'BEGIN' ad 'COMMIT'
 *   (3) Do not ship a large DB with your app. Stay minimal and have app
 *       download its fullest version. Also, store a version in the db for
 *       aid when updating.
 *
 * @author Tim Lindquist Tim.Lindquist@asu.edu
 *         Software Engineering, CIDSE, IAFSE, Arizona State University Polytechnic
 * @version April 4, 2015
 */

#import "CourseDBManager.h"
#import "sqlite3.h"

@interface CourseDBManager()

@property (strong, nonatomic) NSString * documentsDirectory;
@property (strong, nonatomic) NSString * databaseFilename;
@property (strong, nonatomic) NSString * bundlePath;
@property (strong, nonatomic) NSMutableArray * arrResults;

@end

@implementation CourseDBManager

- (id) initDatabaseName:(NSString *) dbName {
    if (self = [super init]) {
        self.bundlePath = [[NSBundle mainBundle] pathForResource: dbName ofType:@"db"];
        // Set the documents directory path to the documentsDirectory property.
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.documentsDirectory = [paths objectAtIndex:0];
        self.databaseFilename = [dbName stringByAppendingString:@".db"];
        [self copyDatabaseIntoDocumentsDirectory];
    }
    return self;
}

// So the database can be modified, when the app is first installed, copy the db from the bundle to Documents
-(void)copyDatabaseIntoDocumentsDirectory{
    // Check whether the database file exists in the documents directory.
    NSString *destinationPath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    if (![[NSFileManager defaultManager] fileExistsAtPath:destinationPath]) {
        // The database file does not exist in the documents directory, so copy it from the main bundle now.
        NSString * sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.databaseFilename];
        NSError * error;
        [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:destinationPath error:&error];
        if (error != nil) {
            NSLog(@"Error in copying database to documents directory: %@", [error localizedDescription]);
        }else{
            NSLog(@"Database copied to documents directory");
        }
    } else {
        NSLog(@"Database already exists in documents directory. No copy necessary.");
    }
}

-(NSArray *)executeQuery:(NSString *)query {
    sqlite3 * sqlite3DB;
    self.arrResults = [[NSMutableArray alloc] init];
    self.arrColNames = [[NSMutableArray alloc] init];
    // Set the database file path.
    NSString * dbPath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    self.arrColNames = [[NSMutableArray alloc] init];
    int openResult = sqlite3_open([dbPath UTF8String], &sqlite3DB);
    if(openResult == SQLITE_OK) {
        sqlite3_stmt *compiledStmt;
        int preparedStmt = sqlite3_prepare_v2(sqlite3DB, [query UTF8String], -1, &compiledStmt, NULL);
        if(preparedStmt == SQLITE_OK) {
            NSMutableArray * dataRow;
            // Loop through the results and add them to the results array row by row.
            while(sqlite3_step(compiledStmt) == SQLITE_ROW) {
                dataRow = [[NSMutableArray alloc] init];
                int totalColumns = sqlite3_column_count(compiledStmt);
                for (int i=0; i<totalColumns; i++){
                    // Convert the column data to characters.
                    char * dataAsChars = (char *)sqlite3_column_text(compiledStmt, i);
                    if (dataAsChars != NULL) {
                        [dataRow addObject:[NSString  stringWithUTF8String:dataAsChars]];
                    }
                    if (self.arrColNames.count != totalColumns) {
                        dataAsChars = (char *)sqlite3_column_name(compiledStmt, i);
                        [self.arrColNames addObject:[NSString stringWithUTF8String:dataAsChars]];
                    }
                }
                if (dataRow.count > 0) {
                    [self.arrResults addObject: dataRow];
                    //NSLog(@"adding %@ to result",arrDataRow);
                }
            }
        } else {
            NSLog(@"Error in preparing SQL query: %s", sqlite3_errmsg(sqlite3DB));
        }
        sqlite3_finalize(compiledStmt);
    }
    sqlite3_close(sqlite3DB);
    return self.arrResults;
}

-(BOOL)executeUpdate:(NSString *)query {
    BOOL ret = NO;
    return ret;
}

@end
