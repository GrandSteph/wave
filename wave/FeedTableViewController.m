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
#import "CreateViewController.h"
#import "TimedStillTaker.h"

@interface FeedTableViewController ()

@end

@implementation FeedTableViewController
- (IBAction)pushTimed:(id)sender {
    TimedStillTaker *photoTaker = [[TimedStillTaker alloc] initWithFilterType:(GPUImageFilterType)GPUIMAGE_SEPIA];
    [self.navigationController pushViewController:photoTaker animated:YES];
}

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

- (void) loadFromBackEnd {
    
    self.events = [[NSMutableArray alloc]init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Timer"];
    [query orderByAscending:@"date"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"Query to Parse");
        if (!error) {
            //sucess
            for (PFObject *object in objects) {
                
                // mapping of PFObject to Dictionnary
                NSMutableDictionary *event = [[NSMutableDictionary alloc] init];
                [event setValue:[object objectForKey:@"description"] forKey:@"description"];
                [event setValue:[object objectForKey:@"date"] forKey:@"date"];
                [event setValue:[object objectForKey:@"date"] forKey:@"second"];
                [event setValue:object.objectId forKey:@"eventID"];
                
                [self.events addObject:event];
            }
        } else {
            //failure
            NSLog(@"Error no PFObject from query");
        }
        [self.tableView reloadData];
    }];
}

- (void) viewWillAppear:(BOOL)animated {
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // init table of event before filling with PFQuery
    [self loadFromBackEnd];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
}

- (void)refresh{
    [self loadFromBackEnd];
    [self.refreshControl endRefreshing];
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
    NSMutableDictionary *object = (self.events)[indexPath.row];
    
    // Configure the cell...
    
    // Set delegate for imagepicker
    cell.delegate = self.navigationController;
    
    //Cell properties
    cell.eventID = [object objectForKey:@"eventID"];
    
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
    return cell;
}

#pragma mark - Segue

- (void) prepareForSegue:(UIStoryboardSegue *) segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"showEventPictures"]) {

        //Pass evend ID to destination view controller
        EventPictures *pix = segue.destinationViewController;
        EventTableViewCell *cell = sender;
        pix.eventID = cell.eventID;
    }
}

- (IBAction)unwindToFeed:(UIStoryboardSegue *)unwindSegue {
    
    // Get event from unwinding ViewController
    CreateViewController *sourceViewController = unwindSegue.sourceViewController;
    NSMutableDictionary *event = sourceViewController.event;
    
    // Save to backend
    PFObject *testTimer = [PFObject objectWithClassName:@"Timer"];
    testTimer[@"date"] = [event objectForKey:@"date"];
    testTimer[@"description"] = [event objectForKey:@"description"];
    testTimer[@"second"] = [event objectForKey:@"second"];
    
    [testTimer saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [event setObject:testTimer.objectId forKey:@"objectId"];
        //[self.events addObject:event];
        [self.tableView reloadData];
    }];

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
