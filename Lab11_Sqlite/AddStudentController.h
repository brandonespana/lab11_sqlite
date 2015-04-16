//
//  AddStudentController.h
//  Lab11_Sqlite
//
//  Created by biespana on 4/16/15.
//  Copyright (c) 2015 biespana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseDBManager.h"

@interface AddStudentController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource>
@property(strong, nonatomic)CourseDBManager* dbManager;

@end
