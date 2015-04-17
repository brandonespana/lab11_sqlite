//
//  AddCourseController.m
//  Lab11_Sqlite
//
//  Created by biespana on 4/14/15.
//  Copyright (c) 2015 biespana. All rights reserved.
//

#import "AddCourseController.h"
#import "CourseTableController.h"
#import "CourseDBManager.h"

@interface AddCourseController ()
@property (weak, nonatomic) IBOutlet UITextField *courseName;
@property (strong, nonatomic)CourseDBManager* dbManager;

@end

//TODO: reload the tableview in the parent correctly
@implementation AddCourseController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"In the add course controlller");
    self.courseName.delegate = self;
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)clickedDone:(id)sender {
    NSString* name = self.courseName.text;
    NSString* theMessage;
    //UIAlertView* addCourseAlert = [[UIAlertView alloc] initWithTitle:@"Added the Course" message:theMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Okay", nil];
    
    if([self.courseName hasText]){
        self.dbManager = [[CourseDBManager alloc]initDatabaseName:@"coursedb"];
        NSString* query = [NSString stringWithFormat:@"insert into course (coursename) values('%@');",name];
        [self.dbManager executeUpdate:query];
        
        [self.parent reloadTable];
        
        [[self navigationController]popViewControllerAnimated:YES ];
    }
    else{
       theMessage = @"Please enter a course name";
        UIAlertView* addCourseAlert = [[UIAlertView alloc] initWithTitle:@"Added the Course" message:theMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Okay", nil];

        [addCourseAlert show];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.courseName resignFirstResponder];
} 
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
