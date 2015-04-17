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
 * Modified by: Brandon Espana
 * Modifications: Added functionality for lab 11 to do insert and delete queries
 * @version April 16, 2015
 */

#import <Foundation/Foundation.h>

@interface CourseDBManager : NSObject

@property (strong, nonatomic) NSMutableArray * arrColNames;
@property (assign, nonatomic) int64_t lastInsertID;

- (id) initDatabaseName: (NSString *) dbName;

/**
 * method for executing insert, update, and delete statements.
 * The return value indicates whether the update was successful
 * The lastInsertID property is set when this method is called.
 */
- (BOOL) executeUpdate: (NSString *) query;

/**
 * method for executing select statements. The query must be a
 * select statement. The return value is an array of arrays
 * Subscriptig the return gives you the row, and subscripting
 * the row gives you each column. For each column, the
 * property arrColumnNames contains, at the same index,
 * the name of the column.
 */
- (NSArray *) executeQuery: (NSString *) query;

@end
