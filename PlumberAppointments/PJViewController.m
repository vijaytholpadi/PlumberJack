//
//  PJViewController.m
//  PlumberAppointments
//
//  Created by Vijay Tholpadi on 30/03/14.
//  Copyright (c) 2014 TheGeekProjekt. All rights reserved.
//

#import "PJViewController.h"
#import "PJTableViewController.h"
#import "PJAddAppointment.h"
#import <AWSRuntime/AWSRuntime.h>


#define ACCESS_KEY_ID    @"AKIAJZADV6UP3C3SRRNQ"
#define SECRET_KEY       @"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"

#define JSON_BUCKET      @"VijayFiles"
#define JSON_NAME        @"Appointments.json"

@interface PJViewController ()

@property (nonatomic, strong) NSArray *weekArray;
@property (nonatomic, strong) NSDictionary *appointDictionary;
@property (nonatomic, strong) NSDictionary *mappingDictionary;
@property (nonatomic, strong) NSArray *appointmentsForSelectedDay;
@property (nonatomic, strong) NSString *daySelectedJsonKey;
@property (nonatomic, strong) NSDictionary *appointmentDaysDictionary;
@property (nonatomic, strong) NSArray *keysArray;
@property (strong, nonatomic) UIImageView *loadingAlpha;
@property (assign, nonatomic) NSInteger showFetchScreen;

@end

@implementation PJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Initiatializing the Array containing the days which is the input to UIPickerView
    self.weekArray = [[NSArray alloc] initWithObjects:@"Monday",@"Tuesday",@"Wednesday", @"Thursday", @"Friday",@"Saturday", @"Sunday", nil];
    
    self.s3 = [[AmazonS3Client alloc] initWithAccessKey:ACCESS_KEY_ID withSecretKey:SECRET_KEY];
    
    self.s3.endpoint = [AmazonEndpoints s3Endpoint:US_EAST_1];
    [AmazonLogger verboseLogging];
    
    self.showFetchScreen = 1;
    
    //
    //    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //    dispatch_async(queue, ^{
    //        S3GetObjectRequest *gor = [[S3GetObjectRequest alloc]initWithKey:@"appointments.json" withBucket:@"VijayFiles"];
    //
    //        gor.contentType = @"application/json";
    //
    //        S3GetObjectResponse *getObjectResponse = [self.s3 getObject:gor];
    //        NSLog(@"%@", getObjectResponse);
    //
    //        if (getObjectResponse!=nil){
    //            [self performSelectorOnMainThread:@selector(fetchedData:) withObject:getObjectResponse.body waitUntilDone:YES];
    //        }
    //    });
    
    //Creating a seperate to run the JSON fetch
    //    dispatch_queue_t currentQueue = dispatch_queue_create("fetch data in background", NULL);
    
    //Dispatching the fetch request Asynchronously in the newly created queue. So that the Main thread is not blocked.
    //    dispatch_async(currentQueue, ^{
    //        NSData *response = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://s3.amazonaws.com/VijayFiles/calendar.json"]];
    //
    //        if (response!=nil){
    //            [self performSelectorOnMainThread:@selector(fetchedData:) withObject:response waitUntilDone:YES];
    //        }
    //    });
    
    //Initializing an array containing the keys of appointment items we are expecting in the JSON
    self.keysArray = [[NSArray alloc] initWithObjects:@"mon",@"tue",@"wed",@"thu",@"fri",@"sat",@"sun",nil];
    
    //Initializing the map between the elements in UIPickerView and the keysArray to launch for appropriate day later
    self.mappingDictionary = [[NSDictionary alloc] init];
    self.mappingDictionary = [NSDictionary dictionaryWithObjects:self.keysArray forKeys:self.weekArray];
}


- (void)fetchedData:(NSData *)response
{   //Converting the recieved rawJSON response into NSDictionary items
    self.appointDictionary = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
    NSLog(@"%@", self.appointDictionary);
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    
    NSInteger selectedRow = [self.PickDate selectedRowInComponent:0];
    
    NSString *daySelected = [self.weekArray objectAtIndex:selectedRow];
    
    self.daySelectedJsonKey = [self.mappingDictionary objectForKey:daySelected];
    
    
    //Get the value for the key "days" as its value contains all the day objects in the JSON
    self.appointmentDaysDictionary = [self.appointDictionary objectForKey:@"days"];
    
    //Get appointments object for the given day by passing its key value. The object is an array
    self.appointmentsForSelectedDay = [self.appointmentDaysDictionary objectForKey:self.daySelectedJsonKey];
    
    // Avoid the segue if the Appointments for the selected day is either nil or an empty array and show an alert for the same else return YES to perform the
    NSLog(@"%@", identifier);
    if([identifier isEqualToString:@"ShowAppointmentSegue"])
    {
        if(!self.appointmentsForSelectedDay || ![self.appointmentsForSelectedDay count])
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alas!" message:@"No appointments for this day" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            
            return NO;
        }
        else
        {
            return YES;
        }
    }
    else if ([identifier isEqualToString:@"AddAppointmentSegue"]) {
        return  YES;
    }
    else {
        return NO; // Remember this decision
    }
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if([segue.identifier isEqualToString:@"ShowAppointmentSegue"])
    {
        // Getting a reference to the destination view controller and passing on the appointments for the selected day
        PJTableViewController *pjtvc =[segue destinationViewController];
        pjtvc.dayAppointArray = self.appointmentsForSelectedDay;
    }
    else if ([segue.identifier isEqualToString:@"AddAppointmentSegue"])
    {
        PJAddAppointment *pjvc = [segue destinationViewController];
        pjvc.selectedDayJsonKey = self.daySelectedJsonKey;
        pjvc.appointDictionaryForJson = self.appointDictionary;
    }
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.weekArray count];
}


-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.weekArray objectAtIndex:row];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    self.loadingAlpha = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.loadingAlpha setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.95]];
    self.loadingAlpha.hidden = NO;
    UITextField *loadingText = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.origin.x + 50, self.view.center.y - 100, self.view.frame.size.width, 100)];
    [loadingText setText:@"Fetching Data. Please wait."];
    CGPoint centerPoint = CGPointMake(self.view.center.x + 60, self.view.center.y -20);
    [loadingText setCenter:centerPoint];
    UIActivityIndicatorView *loadingSpinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.view.center.x,self.view.center.y, 10.0, 10.0)];
    loadingSpinner.hidesWhenStopped=YES;
    [loadingSpinner setColor:[UIColor blackColor]];
    [loadingSpinner startAnimating];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        S3GetObjectRequest *gor = [[S3GetObjectRequest alloc]initWithKey:@"appointments.json" withBucket:@"VijayFiles"];
        
        gor.contentType = @"application/json";
        
        S3GetObjectResponse *getObjectResponse = [self.s3 getObject:gor];
        //        NSLog(@"%@", getObjectResponse);
        
        if (getObjectResponse!=nil){
            [self performSelectorOnMainThread:@selector(fetchedData:) withObject:getObjectResponse.body waitUntilDone:YES];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            self.loadingAlpha.hidden = YES;
            [loadingSpinner stopAnimating];
        });
    });
    
    if(self.showFetchScreen == 1){
        [self.view addSubview:self.loadingAlpha];
        [self.view bringSubviewToFront:self.loadingAlpha];
        [self.loadingAlpha addSubview:loadingSpinner];
        [self.loadingAlpha addSubview:loadingText];
        self.showFetchScreen = 0;
    }
}
- (IBAction)datePicked:(id)sender {
}
@end
