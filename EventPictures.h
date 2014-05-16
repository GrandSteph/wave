//
//  EventView.h
//  wave
//
//  Created by GrandSteph on 5/15/14.
//  Copyright (c) 2014 GrandSteph. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLCloudinary.h"

@interface EventPictures : UIViewController

@property (strong,nonatomic) NSString *eventID;

@property (strong, nonatomic) IBOutlet UILabel *eventDescLabel;

@property (strong, nonatomic) IBOutlet UIImageView *image1;
@property (strong, nonatomic) IBOutlet UIImageView *image2;
@property (strong, nonatomic) IBOutlet UIImageView *image3;
@property (strong, nonatomic) IBOutlet UIImageView *image5;

@end
