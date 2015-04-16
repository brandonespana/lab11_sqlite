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
    
//    
//    NSLog(@"enrolled in: ");
//    for(int i = 0; i < [self.enrolledResults count]; i++){
//        NSLog(@"course: %@",self.enrolledResults[i][0]);
//    }
//    
//    NSLog(@"length of enrolled results is %lu",(unsigned long)[self.enrolledResults count]);
//    NSLog(@"loaded student details");
    // Do any additional setup after loading the view, typically from a nib.
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

- (IBAction)removeStudent:(id)sender {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
