//
//  EventTableViewCell.m
//  wave
//
//  Created by GrandSteph on 5/10/14.
//  Copyright (c) 2014 GrandSteph. All rights reserved.
//

#import "EventTableViewCell.h"
#import "TimedPickerController.h"
#import "CLCloudinary.h"
#import "CLUploader.h"


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
        self.eventTimerLabel.text = @"Past event";
        [theTimer invalidate];
        
        //launch camera
        TimedPickerController *picker = [[TimedPickerController alloc] initBySteph];
        //TimedPickerController *picker = [[TimedPickerController alloc] initWithRootViewController:self.delegate];

        [self.delegate presentViewController:picker animated:YES completion: ^ {
            [UIView animateWithDuration:5
                                  delay:0
                                options:NO
                             animations:^ {
                                 picker.cameraOverlayView.alpha = 1;
                                 picker.cameraOverlayView.transform = CGAffineTransformMakeRotation(M_PI);
                             }
                             completion:^(BOOL finished) {
                                 [picker takePicture];
                             }
             ];
        
        
            //Cloudinary stuff
//            CLCloudinary *cloudinary = [[CLCloudinary alloc] init];
//            [cloudinary.config setValue:@"dviu7tmrq" forKey:@"cloud_name"];
//            [cloudinary.config setValue:@"252529254152278" forKey:@"api_key"];
//            [cloudinary.config setValue:@"_EEzcqFdOcrv4ENrhroBepzWlMo" forKey:@"api_secret"];
//            
//            CLUploader *theUploader = [[CLUploader alloc] init:cloudinary delegate:self];
//            [theUploader upload:picker.pictureData options:@{@"folder":@"Wave1n-Test"}];
        }];
        

        
        
        //NSLog(@"Tic-fin");
        
    }
    //NSLog(@"Tic in %@",self.eventDescription.text);
}

/*
- (void) uploaderSuccess:(NSDictionary*)result context:(id)context {
    NSString* url = [result valueForKey:@"url"];
    NSLog(@"Upload success. Full result=%@", result);
    self.last20Label.text = @"UPLOAD COMPLETE";
    
    self.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
    
}

- (void) uploaderError:(NSString*)result code:(int) code context:(id)context {
    NSLog(@"Upload error: %@, %d", result, code);
}

- (void) uploaderProgress:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite context:(id)context {
    NSLog(@"Upload progress: %d/%d (+%d)", totalBytesWritten, totalBytesExpectedToWrite, bytesWritten);
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:(NSNumberFormatterPercentStyle)];
    float uploadProgress = (float)totalBytesWritten / (float)totalBytesExpectedToWrite;
    NSString *formattedUploadProgress = [formatter stringFromNumber:[NSNumber numberWithFloat:uploadProgress]];
    self.last20Label.text = [NSString stringWithFormat:@"Upload in progress: %@", formattedUploadProgress];
}*/

@end
