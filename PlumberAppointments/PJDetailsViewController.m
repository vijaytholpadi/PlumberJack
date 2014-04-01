//
//  PJDetailsViewController.m
//  PlumberAppointments
//
//  Created by Vijay Tholpadi on 31/03/14.
//  Copyright (c) 2014 TheGeekProjekt. All rights reserved.
//

#import "PJDetailsViewController.h"

@interface PJDetailsViewController ()

@end

@implementation PJDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Setting the respective appointment details labels based on the data recieved.
    UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, 300, 50)];
    [time setBackgroundColor:[UIColor whiteColor]];
    if ([self.appointDetails objectForKey:@"time"]!= nil && ![[self.appointDetails objectForKey:@"time"] isEqual: @""]) {
        [time setText:[NSString stringWithFormat:@"Time: %@",[self.appointDetails objectForKey:@"time"]]];
    }else{
        [time setText:@"Time: NA"];
    }
    [self.view addSubview:time];
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(10, 160, 300, 50)];
    [name setBackgroundColor:[UIColor whiteColor]];
    if ([self.appointDetails objectForKey:@"name"]!= nil && ![[self.appointDetails objectForKey:@"name"] isEqual: @""])
    {
        [name setText:[NSString stringWithFormat:@"Name: %@",[self.appointDetails objectForKey:@"name"]]];
    }else{
        [name setText:@"Name: NA"];
    }
    [self.view addSubview:name];
    
    
    UILabel *phone = [[UILabel alloc] initWithFrame:CGRectMake(10, 220, 300, 50)];
    [phone setBackgroundColor:[UIColor whiteColor]];
    if ([self.appointDetails objectForKey:@"phone"]!= nil && ![[self.appointDetails objectForKey:@"phone"] isEqual: @""])
    {
        [phone setText:[NSString stringWithFormat:@"Phone: %@",[self.appointDetails objectForKey:@"phone"]]];
    }else{
        [phone setText:@"Phone: NA"];
    }
    [self.view addSubview:phone];
    
    UILabel *address = [[UILabel alloc] initWithFrame:CGRectMake(10, 280, 300, 50)];
    [address setBackgroundColor:[UIColor whiteColor]];
    if ([self.appointDetails objectForKey:@"address"]!= nil && ![[self.appointDetails objectForKey:@"address"] isEqual: @""])
    {
        [address setText:[NSString stringWithFormat:@"Address: %@",[self.appointDetails objectForKey:@"address"]] ];
    }else {
        [address setText:@"Address: NA"];
    }
    [self.view addSubview:address];
    
    UILabel *city = [[UILabel alloc] initWithFrame:CGRectMake(10, 340, 300, 50)];
    [city setBackgroundColor:[UIColor whiteColor]];
    if ([self.appointDetails objectForKey:@"city"]!= nil && ![[self.appointDetails objectForKey:@"city"] isEqual: @""])
    {
        [city setText:[NSString stringWithFormat:@"City: %@",[self.appointDetails objectForKey:@"city"]]];
    }else{
        [city setText:@"City: NA"];
    }
    [self.view addSubview:city];
    
    
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

@end
