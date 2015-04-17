//
//  StudentsTableController.h
//  Lab11_Sqlite
//
//  Copyright (c) 2015 Brandon Espana,
//  @author: Brandon Espana mailto:biespana@asu.edu
//  @Version: April 16, 2015
//  The professor and TA have the right to build and evaluate this software package

#import <UIKit/UIKit.h>

@interface StudentsTableController : UITableViewController
//@property(strong,nonatomic)NSArray* courseStudents;
@property(strong,nonatomic)NSString* courseName;

-(void)reloadStudents;
@end
