//
//  CourseTableController.m
//  Lab11_Sqlite
//
//  Created by biespana on 4/8/15.
//  Copyright (c) 2015 biespana. All rights reserved.
//

#import "CourseTableController.h"
#import "StudentsTableController.h"
#import "CourseDBManager.h"
#import "AddCourseController.h"

@interface CourseTableController ()
@property(strong,nonatomic) NSMutableArray* courses;
@property(strong,nonatomic) NSArray* students;

@property(strong,nonatomic) CourseDBManager* dbManager;
@end

@implementation CourseTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dbManager = [[CourseDBManager alloc]initDatabaseName:@"coursedb"];
    
    [self reloadTable];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    //self.courses = [self.dbManager executeQuery:@"select coursename from course;"];
    
    //self.courses = @[@"SER 321",@"SER 423", @"CST 450"];
    //self.students = @[@"Brandon Espana", @"Ivan Spain", @"Rando Spana"];
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
    return self.courses.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"courseCell" forIndexPath:indexPath];
    
    // Configure the cell...
    //cell.textLabel.text = [self.courses objectAtIndex:indexPath.row];
    cell.textLabel.text = self.courses[indexPath.row][0];
    return cell;
}
- (IBAction)reload:(id)sender {
    [self reloadTable];
}

-(void)reloadTable{
    NSLog(@"Reloading the data");
    self.courses = [self.dbManager executeQuery:@"select coursename from course;"];
    [self.tableView reloadData];
    NSLog(@"This many courses: %lu",(unsigned long)[self.courses count]);
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSString* selectedCourse = self.courses[indexPath.row];
        NSString* realString = [self.courses[indexPath.row] componentsJoinedByString:@","];

        [self.courses removeObjectAtIndex:indexPath.row];
        
        NSString* query1 = [NSString stringWithFormat:@"select courseid from course where coursename='%@';",realString];
        NSLog(@"The first query is: %@",query1);
        NSArray* result = [self.dbManager executeQuery:query1];
        NSString* courseId = [result[0] componentsJoinedByString:@","];
        NSLog(@"will delete the row with courseid = %@",courseId);
        
        NSString* query2 = [NSString stringWithFormat:@"delete from studenttakes where courseid=%@;",courseId];
        [self.dbManager executeUpdate:query2];
        
    
        NSString* query3 = [NSString stringWithFormat:@"delete from course where coursename='%@';",realString];
        [self.dbManager executeUpdate:query3];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [self reloadTable];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
    }
}


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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSLog(@"Checking segue identifier");
    NSLog(@"the identifier is: %@",segue.identifier);
    if ([segue.identifier isEqualToString:@"showStudents"]) {
        NSLog(@"going to students");
        StudentsTableController* destinationController = segue.destinationViewController;
        //destinationController.courseStudents = self.students;
        NSIndexPath* indexPath = [self.tableView indexPathForSelectedRow];
        destinationController.courseName = self.courses[indexPath.row][0];
        NSLog(@"done preparing student segue");
        
    }
    else if([segue.identifier isEqualToString:@"addCourse"]){
        AddCourseController* destinationController = segue.destinationViewController;
        NSIndexPath* indexPath = [self.tableView indexPathForSelectedRow];
        destinationController.parent = self;
        NSLog(@"Going to add course");
    }
}


@end
