//
//  AddStudentController.m
//  Lab11_Sqlite
//
//  Copyright (c) 2015 Brandon Espana,
//  @author: Brandon Espana mailto:biespana@asu.edu
//  @Version: April 16, 2015
//  The professor and TA have the right to build and evaluate this software package

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
    
    self.enrollPicker = [[UIPickerView alloc]init];
    self.enrollPicker.delegate = self;
    self.enrollPicker.dataSource = self;
    
    self.addCourseName.inputView = self.enrollPicker;
    
    self.studentName.delegate = self;
    self.studentId.delegate = self;
    self.studentMajor.delegate = self;
    self.studentEmail.delegate = self;
    
    self.studentId.keyboardType = UIKeyboardTypeNumberPad;
    self.studentEmail.keyboardType = UIKeyboardTypeEmailAddress;
    
}
- (IBAction)selectFromContacts:(id)sender {
    NSLog(@"About to present list of contacts");
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    
    [self presentModalViewController:picker animated:YES];
}

//Contacts picker delegate methods
-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    [self dismissModalViewControllerAnimated:YES];
}

-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person{
    [self displayPerson:person];
    [self dismissModalViewControllerAnimated:YES];
    
    return NO;
}

-(void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person{
    [self displayPerson:person];
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    return NO;
}

-(void)displayPerson:(ABRecordRef)person{
    NSString* firstName = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    NSString* lastName = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
    NSString* name = [NSString stringWithFormat:@"%@ %@",firstName,lastName];

    NSLog(@"The contact name is: %@",name);
    self.studentName.text = name;
    
    ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
    
    NSString* email = (__bridge_transfer NSString*)ABMultiValueCopyValueAtIndex(emails, 0);
     NSLog(@"The contact email is: %@",email);
    self.studentEmail.text = email;
    
}

- (IBAction)addStudent:(id)sender {
    if ([self.studentName hasText]&&[self.studentId hasText]&&[self.studentMajor hasText]&&[self.studentEmail hasText]) {
        NSString* insertQuery = [NSString stringWithFormat:@"insert into student values ('%@', '%@', '%@', %@);",self.studentName.text, self.studentMajor.text, self.studentEmail.text, self.studentId.text];
        [self.dbManager executeUpdate:insertQuery];
        if([self.addCourseName hasText]){
            NSLog(@"Adding a class to the new user");
            NSString* courseIdQuery = [NSString stringWithFormat:@"select courseid from course where coursename='%@';",self.addCourseName.text];
            NSArray* result = [self.dbManager executeQuery:courseIdQuery];
            NSString* selectedCourseId = result[0][0];
            NSLog(@"The id to add as a course is this: %@",selectedCourseId);
            NSString* enrollQuery = [NSString stringWithFormat:@"insert into studenttakes values(%@, %@);",self.studentId.text, selectedCourseId];
            [self.dbManager executeUpdate:enrollQuery];
        }
        
        [self.parent reloadStudents];
        
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
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
        [self.addCourseName resignFirstResponder];
        self.addCourseName.text = self.courses[row][0];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.studentName resignFirstResponder];
    [self.studentMajor resignFirstResponder];
    [self.studentId resignFirstResponder];
    [self.studentEmail resignFirstResponder];
    [self.addCourseName resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
