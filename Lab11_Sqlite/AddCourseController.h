//
//  AddCourseController.h
//  Lab11_Sqlite
//
//  Created by biespana on 4/14/15.
//  Copyright (c) 2015 biespana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseDBManager.h"
#import "CourseTableController.h"
@interface AddCourseController : UIViewController
@property(strong,nonatomic) CourseTableController* parent;
@end
