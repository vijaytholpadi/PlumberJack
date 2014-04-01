//
//  PJViewController.h
//  PlumberAppointments
//
//  Created by Vijay Tholpadi on 30/03/14.
//  Copyright (c) 2014 TheGeekProjekt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PJViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *PickDate;

@end
