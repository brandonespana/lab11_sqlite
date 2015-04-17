//
//  ViewController.h
//  Lab11_Sqlite
//
//  Copyright (c) 2015 Brandon Espana,
//  @author: Brandon Espana mailto:biespana@asu.edu
//  @Version: April 16, 2015
//  The professor and TA have the right to build and evaluate this software package

#import <UIKit/UIKit.h>
#import "StudentsTableController.h"

@interface ViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>
@property(strong, nonatomic)NSArray* studentResults;
@property(strong, nonatomic)StudentsTableController* parent;

-(void)reloadPickers;
@end

