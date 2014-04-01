//
//  PJViewController.m
//  PlumberAppointments
//
//  Created by Vijay Tholpadi on 30/03/14.
//  Copyright (c) 2014 TheGeekProjekt. All rights reserved.
//

#import "PJViewController.h"
#import "PJTableViewController.h"

@interface PJViewController ()

@property (nonatomic, strong) NSArray *weekArray;
@property (nonatomic, strong) NSDictionary *appointDictionary;
@property (nonatomic, strong) NSDictionary *mappingDictionary;
@property (nonatomic, strong) NSArray *appointmentsForSelectedDay;
@property (nonatomic, strong) NSArray *keysArray;

@end

@implementation PJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Initiatializing the Array containing the days which is the input to UIPickerView
    self.weekArray = [[NSArray alloc] initWithObjects:@"Monday",@"Tuesday",@"Wednesday", @"Thursday", @"Friday",@"Saturday", @"Sunday", nil];
    
    //Creating a seperate to run the JSON fetch
    dispatch_queue_t currentQueue = dispatch_queue_create("fetch data in background", NULL);
    
    //Dispatching the fetch request Asynchronously in the newly created queue. So that the Main thread is not blocked.
    dispatch_async(currentQueue, ^{
        NSData *response = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://testing.jifflenow.com/cisco_gartner2013/calendar.json"]];
        
        if (response!=nil){
            [self performSelectorOnMainThread:@selector(fetchedData:) withObject:response waitUntilDone:YES];
        }
    });
    
    //Initializing an array containing the keys of appointment items we are expecting in the JSON
    self.keysArray = [[NSArray alloc] initWithObjects:@"mon",@"tue",@"wed",@"thu",@"fri",@"sat",@"sun",nil];
    
    //Initializing the map between the elements in UIPickerView and the keysArray to launch for appropriate day later
    self.mappingDictionary = [[NSDictionary alloc] init];
    self.mappingDictionary = [NSDictionary dictionaryWithObjects:self.keysArray forKeys:self.weekArray];
}


- (void)fetchedData:(NSData *)response
{   //Converting the recieved rawJSON response into NSDictionary items
    self.appointDictionary = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    
    NSInteger selectedRow = [self.PickDate selectedRowInComponent:0];
    
    NSString *daySelected = [self.weekArray objectAtIndex:selectedRow];
    
    NSString *daySelectedJsonKey = [self.mappingDictionary objectForKey:daySelected];
    
    //Get the value for the key "days" as its value contains all the day objects in the JSON
    NSDictionary *appointmentDaysDictionary = [self.appointDictionary objectForKey:@"days"];
    
    //Get appointments object for the given day by passing its key value. The object is an array
    self.appointmentsForSelectedDay = [appointmentDaysDictionary objectForKey:daySelectedJsonKey];
    
    // Avoid the segue if the Appointments for the selected day is either nil or an empty array and show an alert for the same else return YES to perform the segue
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //Getting a reference to the destination view controller and passing on the appointments for the selected day
    PJTableViewController *patvc =[segue destinationViewController];
    patvc.dayAppointArray = self.appointmentsForSelectedDay;
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

- (IBAction)datePicked:(id)sender {
}
@end
