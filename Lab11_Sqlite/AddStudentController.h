//
//  AddStudentController.h
//  Lab11_Sqlite
//
//  Copyright (c) 2015 Brandon Espana,
//  @author: Brandon Espana mailto:biespana@asu.edu
//  @Version: April 16, 2015
//  The professor and TA have the right to build and evaluate this software package

#import <UIKit/UIKit.h>
#import "CourseDBManager.h"
#import "StudentsTableController.h"
#import <AddressBookUI/AddressBookUI.h>

@interface AddStudentController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate,ABPeoplePickerNavigationControllerDelegate>
@property(strong, nonatomic)CourseDBManager* dbManager;
@property(strong,nonatomic)StudentsTableController* parent;
-(void)displayPerson:(ABRecordRef) person;
@end
