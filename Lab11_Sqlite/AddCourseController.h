//
//  AddCourseController.h
//  Lab11_Sqlite
//
//  Copyright (c) 2015 Brandon Espana,
//  @author: Brandon Espana mailto:biespana@asu.edu
//  @Version: April 16, 2015
//  The professor and TA have the right to build and evaluate this software package

#import <UIKit/UIKit.h>
#import "CourseDBManager.h"
#import "CourseTableController.h"
@interface AddCourseController : UIViewController<UITextFieldDelegate>
@property(strong,nonatomic) CourseTableController* parent;
@end
