//
//  FeedTableViewController.m
//  wave
//
//  Created by GrandSteph on 5/16/14.
//  Copyright (c) 2014 GrandSteph. All rights reserved.
//

#import "FeedTableViewController.h"
#import "EventTableViewCell.h"
#import "EventPictures.h"

@interface FeedTableViewController ()

@end

@implementation FeedTableViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];

    if (self) {
        // Custom initialization
        
        [Parse setApplicationId:@"2Opr9bqqsnE17OhV6SbhKg17MD9DYeuOMvyCeU6T"
                      clientKey:@"tynXypDpWPynCI7QUcPiqYRcLOg9CrS6YpXwtzXW"];
        
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.events = [[NSMutableArray alloc]init];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    PFQuery *query = [PFQuery queryWithClassName:@"Timer"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"Query to Parse");
        if (!error) {
            //sucess
            for (PFObject *object in objects) {
                [self.events addObject:object];
            }
        } else {
            //failure
            NSLog(@"Error no PFObject from query");
        }
        [self.tableView reloadData];
    }];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [self.events count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"eventCell";
    EventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[EventTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    PFObject *object = (self.events)[indexPath.row];
    
    // Configure the cell...
    
    // Set delegate for imagepicker
    cell.delegate = self.navigationController;
    
    //Cell properties
    cell.eventID = object.objectId;
    
    //Event Timing
    NSDate *eventDate = [object objectForKey:@"date"];
    NSTimeInterval secondsLeft = [eventDate timeIntervalSinceNow];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateStyle = NSDateFormatterShortStyle;
    dateFormat.timeStyle = NSDateFormatterShortStyle;
    dateFormat.doesRelativeDateFormatting = YES;

    // Labels and visuals
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.last20Label.hidden = YES;
    cell.eventDescription.text = [NSString stringWithFormat:@"%@", [object objectForKey:@"description"]];
    cell.eventDateLabel.text = [dateFormat stringFromDate:eventDate];
    cell.secondsLeft = [NSNumber numberWithDouble: secondsLeft];
    cell.eventDateLabel.text = [dateFormat stringFromDate:eventDate];  

    if (secondsLeft < 0) {
        cell.eventTimerLabel.hidden = YES;
        if (cell.cellTimer) {
            [cell.cellTimer invalidate];
        }
    } else {
        if (cell.cellTimer == nil) {
            cell.cellTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0
                                             target: cell
                                           selector: @selector(handleTimerTick:)
                                           userInfo: nil
                                            repeats: YES];
        }
    }
    
    NSLog(@"Tic");
    return cell;
}

#pragma mark - Segue

- (void) prepareForSegue:(UIStoryboardSegue *) segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"showEventPictures"]) {
        EventPictures *pix = segue.destinationViewController;
        
        EventTableViewCell *cell = sender;
        
        pix.eventID = cell.eventID;
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
