//
//  TimedStillTaker.m
//  wave
//
//  Created by Stephane Giloppe on 5/26/14.
//  Copyright (c) 2014 GrandSteph. All rights reserved.
//

#import "TimedStillTaker.h"


@interface TimedStillTaker ()

@end

@implementation TimedStillTaker

- (id)initWithFilterType:(GPUImageFilterType)newFilterType;
{
    self = [super initWithNibName:@"TimedStillTaker" bundle:nil];
    if (self)
    {
        filterType = newFilterType;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupFilter];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    // Note: I needed to stop camera capture before the view went off the screen in order to prevent a crash from the camera still sending frames
    [stillCamera stopCameraCapture];
    
	[super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) setupFilter;
{
    stillCamera = [[GPUImageStillCamera alloc] init];
    stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    
    switch (filterType)
    {
        case GPUIMAGE_SEPIA:
        {
            self.title = @"Sepia Tone";
            
            filter = [[GPUImageSepiaFilter alloc] init];
        }; break;
    }
    
    [stillCamera addTarget:filter];
    GPUImageView *filterView = (GPUImageView *)self.view;
    [filter addTarget:filterView];
    [stillCamera startCameraCapture];
    
}
- (IBAction)takeStill:(id)sender {
    [stillCamera capturePhotoAsImageProcessedUpToFilter:filter withOrientation:UIImageOrientationUp withCompletionHandler:^(UIImage *processedImage, NSError *error) {
        
        NSData *dataForPNGFile = UIImageJPEGRepresentation([self resizeImageWithImage:processedImage toPixelLongest:1200] , 0.8);
        //Cloudinary stuff
        CLCloudinary *cloud = [[CLCloudinary alloc] init];
        [cloud.config setValue:@"dviu7tmrq" forKey:@"cloud_name"];
        [cloud.config setValue:@"252529254152278" forKey:@"api_key"];
        [cloud.config setValue:@"_EEzcqFdOcrv4ENrhroBepzWlMo" forKey:@"api_secret"];
        
        // Upload avec options
        CLUploader *theUploader = [[CLUploader alloc] init:cloud delegate:self];
        [theUploader upload:dataForPNGFile options:@{@"public_id":[NSString stringWithFormat:@"%@STEPHANE",@"123456789"]} withCompletion:^(NSDictionary *successResult, NSString *errorResult, NSInteger code, id context) {
            
            //completion
            NSLog(@"Upload success. Full result=%@", successResult);
            
        } andProgress:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite, id context) {
            float total = totalBytesExpectedToWrite;
            float current = totalBytesWritten;
            float percent = (current / total) * 100;
            
            //progress
            //self.countDownLabel.text = [NSString stringWithFormat:@" upload %1.0f%% ",percent];
            NSLog(@" upload %1.0f%% ",percent);
            
        }];

    }];
}

- (UIImage*)resizeImageWithImage:(UIImage*)image toPixelLongest:(int)newLongest
{
    //Compute size for lanscape
    CGSize newSize = CGSizeMake(newLongest, newLongest * (image.size.height/image.size.width));
    
    if (image.imageOrientation == UIImageOrientationUp) {
        //portrait
        newSize.width = newLongest * (image.size.width/image.size.height);
        newSize.height = newLongest;
    }
    
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // draw in new context, with the new size
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    return newImage;
}
         

@end
