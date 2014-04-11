//
//  PJAddAppointment.m
//  PlumberAppointments
//
//  Created by Vijay Tholpadi on 02/04/14.
//  Copyright (c) 2014 TheGeekProjekt. All rights reserved.
//

#import "PJAddAppointment.h"
#import <AWSRuntime/AWSRuntime.h>


#define ACCESS_KEY_ID    @"AKIAJCPOOL3V5QYPD7DA"
#define SECRET_KEY       @"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"

#define JSON_BUCKET      @"VijayFiles"
#define JSON_NAME        @"Appointments.json"

@interface PJAddAppointment ()
@property (nonatomic, strong) NSMutableArray *currentDayAppointments;
@property (nonatomic, strong) NSMutableDictionary *appointmentDaysDictionary;
@end

@implementation PJAddAppointment

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.networkSpinner.hidesWhenStopped = YES;
    [self.navigationController setTitle:[NSString stringWithFormat: @"Adding appointment for %@", self.selectedDayJsonKey]];
    
    self.appointmentDaysDictionary = [[NSMutableDictionary alloc] init];
    self.appointmentDaysDictionary = [[self.appointDictionaryForJson objectForKey:@"days"] mutableCopy];
    
    self.currentDayAppointments = [[NSMutableArray alloc] init];
    NSArray *samplearray = [self.appointmentDaysDictionary valueForKey:self.selectedDayJsonKey];
    for (NSDictionary *element in samplearray)
    {
        [self.currentDayAppointments addObject:element];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)AddButtonPressed:(id)sender {
    
    
    [self.TimeEntered resignFirstResponder];
    [self.NameEntered resignFirstResponder];
    [self.PhoneEntered resignFirstResponder];
    [self.AddressEntered resignFirstResponder];
    [self.CityEntered resignFirstResponder];
    [self.view setFrame:CGRectMake(0,0,320,480)];
    
    self.networkSpinner.hidesWhenStopped = YES;
    [self.networkSpinner startAnimating];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSMutableDictionary *innerMostDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[self.TimeEntered text], @"time",[self.NameEntered text], @"name", [self.PhoneEntered text], @"phone", [self.AddressEntered text], @"address",[self.CityEntered text], @"city",  nil];
    
    [self.view resignFirstResponder];
    [self.TimeEntered resignFirstResponder];
    [self.currentDayAppointments addObject:innerMostDictionary];
    
    [self.appointmentDaysDictionary setValue:self.currentDayAppointments forKey:self.selectedDayJsonKey];
    
    NSDictionary *currentDayAppointmentsWithMainDaysKey = [[NSDictionary alloc] initWithObjectsAndKeys:self.appointmentDaysDictionary, @"days", nil];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:currentDayAppointmentsWithMainDaysKey options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *checkJson = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *path = [[self applicationDocumentsDirectory].path stringByAppendingString:@"Appointments.json"];
    [checkJson writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
    
    [self.view resignFirstResponder];
    
    
    self.s3 = [[AmazonS3Client alloc] initWithAccessKey:ACCESS_KEY_ID withSecretKey:SECRET_KEY];
    
    self.s3.endpoint = [AmazonEndpoints s3Endpoint:US_EAST_1];
    [AmazonLogger verboseLogging];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        // Upload json data.  Remember to set the content type.
        S3PutObjectRequest *por = [[S3PutObjectRequest alloc] initWithKey:@"appointments.json"
                                                                 inBucket:@"VijayFiles"];
        por.contentType = @"txt/json";
        por.data        = jsonData;
        
        // Put the image data into the specified s3 bucket and object.
        S3PutObjectResponse *putObjectResponse = [self.s3 putObject:por];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.networkSpinner stopAnimating];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        });
    });
    
    
    
}

- (IBAction)dismissKeyboard:(id)sender {
    
    [self.TimeEntered resignFirstResponder];
    [self.NameEntered resignFirstResponder];
    [self.PhoneEntered resignFirstResponder];
    [self.AddressEntered resignFirstResponder];
    [self.CityEntered resignFirstResponder];
    [self.view setFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    
}

- (IBAction)AddressTextfieldPressed:(id)sender {
    if (self.view.frame.size.height != 568.000000){
        NSLog(@" the height is %f", self.view.frame.size.height);
    [self.view setFrame:CGRectMake(0,-25,self.view.frame.size.width,self.view.frame.size.height + 25)];
}
}

- (IBAction)TimeTextFieldPressed:(id)sender {
    [self.view setFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
}


//-(void)

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
}

@end
