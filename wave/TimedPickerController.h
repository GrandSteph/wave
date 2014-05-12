//
//  TimedViewController.h
//  wave
//
//  Created by GrandSteph on 5/10/14.
//  Copyright (c) 2014 GrandSteph. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLCloudinary.h"
#import "CLUploader.h"

@interface TimedPickerController : UIImagePickerController <UINavigationControllerDelegate, UIImagePickerControllerDelegate,CLUploaderDelegate>

@property (strong,nonatomic) NSData *pictureData;

- (id) initBySteph;

@end
