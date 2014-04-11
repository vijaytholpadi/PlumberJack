//
//  PJAddAppointment.h
//  PlumberAppointments
//
//  Created by Vijay Tholpadi on 02/04/14.
//  Copyright (c) 2014 TheGeekProjekt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AWSS3/AWSS3.h>

@interface PJAddAppointment : UIViewController

@property (nonatomic, strong) AmazonS3Client *s3;

@property (nonatomic, strong) NSString *selectedDayJsonKey;
@property (nonatomic, strong) NSDictionary *appointDictionaryForJson;
@property (nonatomic, strong) NSMutableDictionary *changedAppointmentDictionary;

@property (weak, nonatomic) IBOutlet UITextField *TimeEntered;
@property (weak, nonatomic) IBOutlet UITextField *NameEntered;
@property (weak, nonatomic) IBOutlet UITextField *PhoneEntered;
@property (weak, nonatomic) IBOutlet UITextField *AddressEntered;
@property (weak, nonatomic) IBOutlet UITextField *CityEntered;
- (IBAction)AddButtonPressed:(id)sender;
- (IBAction)dismissKeyboard:(id)sender;
- (IBAction)AddressTextfieldPressed:(id)sender;
- (IBAction)TimeTextFieldPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *networkSpinner;

@end
