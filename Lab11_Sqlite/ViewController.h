//
//  ViewController.h
//  Lab11_Sqlite
//
//  Created by biespana on 4/8/15.
//  Copyright (c) 2015 biespana. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource>
@property(strong, nonatomic)NSArray* studentResults;

@end

