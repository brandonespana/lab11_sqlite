//
//  StudentsTableController.m
//  Lab11_Sqlite
//
//  Copyright (c) 2015 Brandon Espana,
//  @author: Brandon Espana mailto:biespana@asu.edu
//  @Version: April 16, 2015
//  The professor and TA have the right to build and evaluate this software package

#import "StudentsTableController.h"
#import "CourseDBManager.h"
#import "ViewController.h"
#import "AddStudentController.h"

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
    NSString* newTitle = [NSString stringWithFormat:@"In %@",self.courseName];
    self.title = newTitle;
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

-(void)reloadStudents{
    self.studentList = [self.dbManager executeQuery:self.query];
    [self.tableView reloadData];

}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"studentDetail"]) {
        NSIndexPath* indexPath = [self.tableView indexPathForSelectedRow];
        NSString* selectedStudent = [self.studentList[indexPath.row] componentsJoinedByString:@","];
        NSString* studentQuery = [NSString stringWithFormat:@"select name,major,email,studentid from student where name='%@';",selectedStudent];
        
        NSArray* studentsResult = [self.dbManager executeQuery:studentQuery];
        
        ViewController* destination = segue.destinationViewController;
        destination.studentResults = studentsResult;
        destination.parent = self;
        
    }
    else if ([segue.identifier isEqualToString:@"addStudent"]){
        AddStudentController* destination = segue.destinationViewController;
        destination.parent = self;
    }
}
//name TEXT,
//major TEXT,
//email TEXT,
//studentid INTEGER PRIMARY KEY

@end
