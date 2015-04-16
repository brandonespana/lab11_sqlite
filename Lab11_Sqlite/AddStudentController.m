//
//  AddStudentController.m
//  Lab11_Sqlite
//
//  Created by biespana on 4/16/15.
//  Copyright (c) 2015 biespana. All rights reserved.
//

#import "AddStudentController.h"

@interface AddStudentController ()
@property (weak, nonatomic) IBOutlet UITextField *studentName;
@property (weak, nonatomic) IBOutlet UITextField *studentId;
@property (weak, nonatomic) IBOutlet UITextField *studentMajor;
@property (weak, nonatomic) IBOutlet UITextField *studentEmail;
@property (weak, nonatomic) IBOutlet UITextField *addCourseName;

@property(strong, nonatomic) UIPickerView * enrollPicker;
@property(strong, nonatomic)NSArray* courses;
@end

@implementation AddStudentController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dbManager = [[CourseDBManager alloc]initDatabaseName:@"coursedb"];
    
    
    self.enrollPicker.delegate = self;
    self.enrollPicker.dataSource = self;
    self.addCourseName.inputView = self.enrollPicker;
    
}

- (IBAction)addACourse:(id)sender {
    if ([self.addCourseName hasText]) {
        NSLog(@"Will add the course: %@",self.addCourseName.text);

    }
    else{
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Add course" message:@"Select a course first" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Okay", nil];
        [alert show];
    }
}

- (IBAction)addStudent:(id)sender {
    if ([self.studentName hasText]&&[self.studentId hasText]&&[self.studentMajor hasText]&&[self.studentEmail hasText]) {
        NSString* insertQuery = [NSString stringWithFormat:@"insert into student values ('%@', '%@', '%@', %@);",self.studentName.text, self.studentMajor.text, self.studentEmail.text, self.studentId.text];
        [self.dbManager executeUpdate:insertQuery];
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Add Student" message:@"Successfully added student" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Okay", nil];
        
        [alert show];
        [[self navigationController]popViewControllerAnimated:YES ];
    }
    else{
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Add Student" message:@"Enter a name, id, major and email" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Okay", nil];
        [alert show];
    }
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSString* coursesQuery = @"select coursename from course;";
    self.courses = [self.dbManager executeQuery:coursesQuery];
    
    return [self.courses count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
        return self.courses[row][0];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
