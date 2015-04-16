//
//  ViewController.h
//  Lab11_Sqlite
//
//  Created by biespana on 4/8/15.
//  Copyright (c) 2015 biespana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentsTableController.h"

@interface ViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>
@property(strong, nonatomic)NSArray* studentResults;
@property(strong, nonatomic)StudentsTableController* parent;

-(void)reloadPickers;
@end

