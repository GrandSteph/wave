//
//  EventTableViewCell.m
//  wave
//
//  Created by GrandSteph on 5/10/14.
//  Copyright (c) 2014 GrandSteph. All rights reserved.
//

#import "EventTableViewCell.h"
#import "TimedViewController.h"

@interface EventTableViewCell ()



@end

@implementation EventTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        //init code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) handleTimerTick:(NSTimer*)theTimer {
    
    self.secondsLeft = [NSNumber numberWithInt:[self.secondsLeft intValue] - 1];
    self.eventTimerLabel.text = [self.secondsLeft stringValue];
    if ([self.secondsLeft intValue] < 2) {
        self.eventTimerLabel.text = @"Past event";
        [theTimer invalidate];

        
        //NSLog(@"Tic-fin");
    }
    //NSLog(@"Tic in %@",self.eventDescription.text);
}

@end
