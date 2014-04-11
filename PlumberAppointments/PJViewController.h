//
//  PJViewController.h
//  PlumberAppointments
//
//  Created by Vijay Tholpadi on 30/03/14.
//  Copyright (c) 2014 TheGeekProjekt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AWSS3/AWSS3.h>

@interface PJViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, strong) AmazonS3Client *s3;
@property (weak, nonatomic) IBOutlet UIPickerView *PickDate;
//@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *networkSpinner;

@end
