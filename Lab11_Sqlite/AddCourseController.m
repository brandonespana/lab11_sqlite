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
@property (weak, nonatomic) IBOutlet UITextField *courseId;
@property (strong, nonatomic)CourseTableController* parent;
@property (strong, nonatomic)CourseDBManager* dbManager;

@end

//TODO: reload the tableview in the parent correctly
@implementation AddCourseController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"In the add course controlller");
    //self.courseName.delegate = self;
    //self.courseId.delegate = self;
    // Do any additional setup after loading the view.
}

- (IBAction)clickedDone:(id)sender {
    NSString* name = self.courseName.text;
    NSString* cid = self.courseId.text;
    NSString* theMessage;
    //UIAlertView* addCourseAlert = [[UIAlertView alloc] initWithTitle:@"Added the Course" message:theMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Okay", nil];
    
    if([self.courseName hasText] && [self.courseId hasText]){
        self.dbManager = [[CourseDBManager alloc]initDatabaseName:@"coursedb"];
        NSString* query = [NSString stringWithFormat:@"insert into course values('%@', %@);",name,cid];
        [self.dbManager executeUpdate:query];
        
        
        theMessage = [NSString stringWithFormat:@"Course name %@ ,id %@",name,cid];
        UIAlertView* addCourseAlert = [[UIAlertView alloc] initWithTitle:@"Added the Course" message:theMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Okay", nil];

        [addCourseAlert show];
        [self.parent reloadTable];
        [[self navigationController]popViewControllerAnimated:YES ];
    }
    else{
       theMessage = @"Don't leave inputs blank";
        UIAlertView* addCourseAlert = [[UIAlertView alloc] initWithTitle:@"Added the Course" message:theMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Okay", nil];

        [addCourseAlert show];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
