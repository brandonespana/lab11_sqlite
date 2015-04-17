//
//  AddStudentController.h
//  Lab11_Sqlite
//
//  Created by biespana on 4/16/15.
//  Copyright (c) 2015 biespana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseDBManager.h"
#import "StudentsTableController.h"
#import <AddressBookUI/AddressBookUI.h>

@interface AddStudentController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate,ABPeoplePickerNavigationControllerDelegate>
@property(strong, nonatomic)CourseDBManager* dbManager;
@property(strong,nonatomic)StudentsTableController* parent;
-(void)displayPerson:(ABRecordRef) person;
@end
