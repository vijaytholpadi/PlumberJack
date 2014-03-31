//
//  PAViewController.m
//  PlumberAppointments
//
//  Created by Vijay Tholpadi on 30/03/14.
//  Copyright (c) 2014 TheGeekProjekt. All rights reserved.
//

#import "PAViewController.h"
#import "PATableViewController.h"

@interface PAViewController ()

@property (nonatomic, strong) NSArray *weekArray;
@property (nonatomic, strong) NSDictionary *appointDictionary;
@property (nonatomic, strong) NSDictionary *mappingDictionary;
@property (nonatomic, strong) NSArray *appointmentsForSelectedDay;
@property (nonatomic, strong) NSArray *keysArray;

@end

@implementation PAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.weekArray = [[NSArray alloc] initWithObjects:@"Monday",@"Tuesday",@"Wednesday", @"Thursday", @"Friday",@"Saturday", @"Sunday", nil];
    //dispatch_queue_t currentQueue = dispatch_queue_create("fetch data in background", NULL);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *response = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://testing.jifflenow.com/cisco_gartner2013/calendar.json"]];
        
        if (response!=nil){
            [self performSelectorOnMainThread:@selector(fetchedData:) withObject:response waitUntilDone:YES];
        }
    });
    
    self.keysArray = [[NSArray alloc] initWithObjects:@"mon",@"tue",@"wed",@"thu",@"fri",@"sat",@"sun",nil];
    
    self.mappingDictionary = [[NSDictionary alloc] init];
    self.mappingDictionary = [NSDictionary dictionaryWithObjects:self.keysArray forKeys:self.weekArray];
}


- (void)fetchedData:(NSData *)response
{
    self.appointDictionary = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    
        
        PATableViewController *patvc =[segue destinationViewController];
        patvc.dayAppointArray = self.appointmentsForSelectedDay;
  
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    
    NSInteger selectedRow = [self.PickDate selectedRowInComponent:0];
    
    NSString *daySelected = [self.weekArray objectAtIndex:selectedRow];
    
    NSString *daySelectedJsonKey = [self.mappingDictionary objectForKey:daySelected];
    
    NSDictionary *dayAppointmentsDictionary = [self.appointDictionary objectForKey:@"days"];
    self.appointmentsForSelectedDay = [dayAppointmentsDictionary objectForKey:daySelectedJsonKey];
    
    if(!self.appointmentsForSelectedDay || ![self.appointmentsForSelectedDay count])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alas!" message:@"No appointment for this day" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        
        return NO;
        
    }
    else
    {
        return YES;
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

- (IBAction)datePicked:(id)sender {
}
@end
