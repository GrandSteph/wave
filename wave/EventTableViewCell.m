//
//  EventTableViewCell.m
//  wave
//
//  Created by GrandSteph on 5/10/14.
//  Copyright (c) 2014 GrandSteph. All rights reserved.
//

#import "EventTableViewCell.h"
#import "TimedPickerController.h"
#import "EventPictures.h"


@interface EventTableViewCell () //<CLUploaderDelegate>



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
    self.last20Label.text = [self.secondsLeft stringValue];
    
    if ([self.secondsLeft intValue] == 21) {
        //self.eventDescription.hidden = YES;
        self.eventTimerLabel.hidden = YES;
        self.eventDateLabel.hidden = YES;
        self.last20Label.Hidden = NO;
    }
    
    //Camera interface trigger
    if ([self.secondsLeft intValue] < 5) {
        self.eventTimerLabel.hidden = YES;
        [theTimer invalidate];
        
        //launch camera
        TimedPickerController *picker = [[TimedPickerController alloc] initWithCloud:self.eventID];

        [self.delegate presentViewController:picker animated:YES completion: ^ {
            
            //Animation
            [UIView animateWithDuration:5
                                  delay:0
                                options:NO
                             animations:^ {
                                 picker.cameraOverlayView.alpha = 1;
                                 picker.cameraOverlayView.transform = CGAffineTransformMakeRotation(M_PI);
                             }
                             completion:^(BOOL finished) {
                                 [picker takePicture];
                                 self.last20Label.hidden = YES;
                             }
             ];
        }];
    }

}






@end
