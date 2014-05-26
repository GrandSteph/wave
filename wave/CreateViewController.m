//
//  w1nSecondViewController.m
//  WaveIn
//
//  Created by GrandSteph on 4/30/14.
//  Copyright (c) 2014 GrandSteph. All rights reserved.
//

#import "CreateViewController.h"

@interface CreateViewController ()
@property (strong, nonatomic) IBOutlet UIDatePicker *datePiecker;
@property (strong, nonatomic) IBOutlet UITextField *eventDescription;

@property (strong, nonatomic) IBOutlet UIButton *myButton;

- (IBAction)createEventButton:(id)sender;

@end

@implementation CreateViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //[self.myButton setTitle:@"Create Event" forState:UIControlStateNormal];
    [self.datePiecker setDate:[NSDate dateWithTimeInterval:60 sinceDate:[NSDate date]]];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)createEventButton:(id)sender {

    // format date
    NSDate *chosenDate = [self.datePiecker date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd-hh-mm"];
    
    // Create object to add to events
    self.event = [[NSMutableDictionary alloc] init];
    [self.event setValue:self.eventDescription.text forKey:@"description"];
    [self.event setValue:chosenDate forKey:@"date"];
    [self.event setValue:@(0.0) forKey:@"second"];

}
@end
