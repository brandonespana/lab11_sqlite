//
//  ViewController.m
//  Lab11_Sqlite
//
//  Created by biespana on 4/8/15.
//  Copyright (c) 2015 biespana. All rights reserved.
//

#import "ViewController.h"
#import "CourseDBManager.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *studentid;
@property (weak, nonatomic) IBOutlet UITextField *major;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *enrolledCourses;
@property (weak, nonatomic) IBOutlet UITextField *notEnrolledCourses;

@property (strong,nonatomic)NSArray* enrolledResults;
@property (strong,nonatomic)NSArray* notEnrolledResults;

@property(strong, nonatomic) UIPickerView * dropPicker;
@property(strong, nonatomic) UIPickerView * enrollPicker;

@property (strong,nonatomic) CourseDBManager* dbManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.name.text = self.studentResults[0][0];
    self.major.text = self.studentResults[0][1];
    self.email.text = self.studentResults[0][2];
    self.studentid.text = self.studentResults[0][3];
    
    self.name.delegate = self;
    self.major.delegate = self;
    self.email.delegate = self;
    self.studentid.delegate = self;
    
    self.dropPicker = [[UIPickerView alloc]init];
    self.dropPicker.delegate = self;
    self.dropPicker.dataSource = self;
    
    self.enrollPicker = [[UIPickerView alloc]init];
    self.enrollPicker.delegate = self;
    self.enrollPicker.dataSource = self;
    
    self.enrolledCourses.inputView = self.dropPicker;
    self.notEnrolledCourses.inputView = self.enrollPicker;
    
    self.dbManager = [[CourseDBManager alloc]initDatabaseName:@"coursedb"];
    
    NSString* query = [NSString stringWithFormat:@"select coursename from course, studenttakes, student where student.name = '%@' and student.studentid = studenttakes.studentid and course.courseid = studenttakes.courseid;",self.name.text];
//    NSLog(@"QUERY: %@",query);
    self.enrolledResults = [self.dbManager executeQuery:query];
    
    NSString* query2 = [NSString stringWithFormat:@"select coursename from course where course.courseid not in (select courseid from studenttakes where studenttakes.studentid=%@);",self.studentid.text];
    self.notEnrolledResults = [self.dbManager executeQuery:query2];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (pickerView == self.dropPicker) {
        [self.enrolledCourses resignFirstResponder];
        self.enrolledCourses.text = self.enrolledResults[row][0];
    }
    else if(pickerView == self.enrollPicker){
        [self.notEnrolledCourses resignFirstResponder];
        self.notEnrolledCourses.text = self.notEnrolledResults[row][0];
        
    }
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if(pickerView == self.dropPicker){
        return self.enrolledResults[row][0];
    }
    else{
        return self.notEnrolledResults[row][0];
    }
    
}
-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (pickerView == self.dropPicker) {
        return [self.enrolledResults count];
    }
    else{
        return (NSInteger)[self.notEnrolledResults count];
    }
}

-(void) reloadPickers{
    NSString* query = [NSString stringWithFormat:@"select coursename from course, studenttakes, student where student.name = '%@' and student.studentid = studenttakes.studentid and course.courseid = studenttakes.courseid;",self.name.text];
    self.enrolledResults = [self.dbManager executeQuery:query];
    
    NSString* query2 = [NSString stringWithFormat:@"select coursename from course where course.courseid not in (select courseid from studenttakes where studenttakes.studentid=%@);",self.studentid.text];
    self.notEnrolledResults = [self.dbManager executeQuery:query2];
    [self.parent reloadStudents];
}

- (IBAction)removeStudent:(id)sender {
    NSString* deleteQuery = [NSString stringWithFormat:@"delete from studenttakes where studentid=%@;",self.studentid.text];
    [self.dbManager executeUpdate:deleteQuery];
    deleteQuery = [NSString stringWithFormat:@"delete from student where name='%@';",self.name.text];
    [self.dbManager executeUpdate:deleteQuery];
    
    [self.parent reloadStudents];
}
- (IBAction)dropCourse:(id)sender {
    if ([self.enrolledCourses hasText]) {
        NSString* getCourseIdQuery = [NSString stringWithFormat:@"select courseid from course where coursename='%@';",self.enrolledCourses.text];
        NSArray* result = [self.dbManager executeQuery:getCourseIdQuery];
        NSString* courseToDropId = result[0][0];
        NSLog(@"about to drop this course: %@",courseToDropId);
        
        NSString* dropQuery = [NSString stringWithFormat:@"delete from studenttakes where studentid=%@ and courseid=%@",self.studentid.text,courseToDropId];
        [self.dbManager executeUpdate:dropQuery];
        self.enrolledCourses.text = @"";
        [self reloadPickers];
        
    }
    else{
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Drop Course" message:@"Select a course first" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Okay", nil];
        [alert show];
    }
}

- (IBAction)addCourse:(id)sender {
    if ([self.notEnrolledCourses hasText]) {
        NSString* getCourseIdQuery = [NSString stringWithFormat:@"select courseid from course where coursename='%@';",self.notEnrolledCourses.text];
        NSArray* result = [self.dbManager executeQuery:getCourseIdQuery];
        NSString* courseIdToAdd = result[0][0];
        NSLog(@"about to add this course: %@",courseIdToAdd);
        
        NSString* addQuery = [NSString stringWithFormat:@"insert into studenttakes values(%@, %@);",self.studentid.text,courseIdToAdd];
        [self.dbManager executeUpdate:addQuery];
        self.notEnrolledCourses.text = @"";
        [self reloadPickers];
    }
    else{
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Add Course" message:@"Select a course first" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Okay", nil];
        [alert show];
    }
}

                         
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.enrolledCourses resignFirstResponder];
    [self.notEnrolledCourses resignFirstResponder];
    [self.name resignFirstResponder];
    [self.email resignFirstResponder];
    [self.major resignFirstResponder];
    [self.studentid resignFirstResponder];
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
