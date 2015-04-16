//
//  StudentsTableController.m
//  Lab11_Sqlite
//
//  Created by biespana on 4/8/15.
//  Copyright (c) 2015 biespana. All rights reserved.
//

#import "StudentsTableController.h"
#import "CourseDBManager.h"
#import "ViewController.h"

@interface StudentsTableController ()
@property(strong,nonatomic)NSArray* studentList;
@property(strong,nonatomic)CourseDBManager* dbManager;
@property(strong,nonatomic)NSString* query;
@end

@implementation StudentsTableController

//select name from student,studenttakes,course where course.coursename = 'Ser502 Emerging Langs' and course.courseid = studenttakes.courseid and student.studentid = studenttakes.studentid;
//select name from student,studenttakes,course where course.coursename != 'Ser502 Emerging Langs' and course.courseid = studenttakes.courseid and student.studentid = studenttakes.studentid;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.query = [NSString stringWithFormat:@"select name from student,studenttakes,course where course.coursename = '%@' and course.courseid = studenttakes.courseid and student.studentid = studenttakes.studentid;",self.courseName];

    self.dbManager = [[CourseDBManager alloc]initDatabaseName:@"coursedb"];
    self.studentList = [self.dbManager executeQuery:self.query];
    NSLog(@"Type of one student : %@",[self.studentList[0] class]);
    NSString* newTitle = [NSString stringWithFormat:@"In %@",self.courseName];
    self.title = newTitle;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.studentList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"studentCell" forIndexPath:indexPath];
    
    // Configure the cell...
    //cell.textLabel.text = [self.courseStudents objectAtIndex:indexPath.row];
    cell.textLabel.text = self.studentList[indexPath.row][0];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/



// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"studentDetail"]) {
        NSIndexPath* indexPath = [self.tableView indexPathForSelectedRow];
        NSString* selectedStudent = [self.studentList[indexPath.row] componentsJoinedByString:@","];
        NSString* studentQuery = [NSString stringWithFormat:@"select name,major,email,studentid from student where name='%@';",selectedStudent];
        
        NSArray* studentsResult = [self.dbManager executeQuery:studentQuery];
        
        ViewController* destination = segue.destinationViewController;
        destination.studentResults = studentsResult;
        
    }
}
//name TEXT,
//major TEXT,
//email TEXT,
//studentid INTEGER PRIMARY KEY

@end
