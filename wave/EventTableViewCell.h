//
//  EventTableViewCell.h
//  wave
//
//  Created by GrandSteph on 5/10/14.
//  Copyright (c) 2014 GrandSteph. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventTableViewCell : UITableViewCell <UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *eventDescription;
@property (strong, nonatomic) IBOutlet UILabel *eventTimerLabel;
@property (strong, nonatomic) IBOutlet UILabel *eventDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *last20Label;

@property (nonatomic,strong) NSNumber *secondsLeft;
@property (nonatomic,strong) id delegate;

- (void) handleTimerTick:(NSTimer*)theTimer;

@end
